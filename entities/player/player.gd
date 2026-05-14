extends CharacterBody2D
class_name Player

enum State{
	IDLE,
	RUN,
	FALLING,
	JUMPING,
	ATTACKING
}

@export_group("Player Properties")
@export_range(0, 1000, 0.1) var walk_speed: float = 300.0
@export var acceleration_speed_multiplier: float = 6.0
@export_range(-2000, 0, 1) var jump_velocity: float = -725.0 
@export var terminal_velocity: float = 700.0

@onready var platform_detector: RayCast2D = %PlatformDetector
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var camera_2d: Camera2D = %Camera2D
@onready var jump_sound: AudioStreamPlayer2D = %JumpSound


var gravity:int = ProjectSettings.get("physics/2d/default_gravity")
var _double_jump_charged: bool = false
var current_state := State.IDLE
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	print("X")
	_apply_gravity(delta)
	_handle_input()
	_update_state()
	_update_animation()
	floor_stop_on_slope = not platform_detector.is_colliding()
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		pass #Attacking
	#Animation

func _apply_gravity(delta: float)->void:
	if is_on_floor():
		_double_jump_charged = true
	velocity.y = minf(terminal_velocity, velocity.y + gravity * delta)


func _handle_input()->void:
	var direction := Input.get_axis("move_left", "move_right") * walk_speed
	velocity.x = move_toward(
		velocity.x,
		direction,
		walk_speed * get_physics_process_delta_time() * acceleration_speed_multiplier
	)
	
	if not is_zero_approx(velocity.x):
		sprite_2d.flip_h = velocity.x <0
	
	if Input.is_action_just_pressed("jump"):
		_try_jump()
	elif Input.is_action_just_released("jump") and velocity.y <= 0.0:
		velocity.y *= 0.6

	if Input.is_action_just_pressed("attack") and not is_attacking:
		_attack()


func _update_state()->void:
	if is_attacking:
		current_state = State.ATTACKING
		return
	if is_on_floor():
		if is_zero_approx(velocity.x):
			current_state = State.IDLE
		else:
			current_state = State.RUN
	else:
		if velocity.y < 0: 
			current_state = State.JUMPING
		else:
			current_state = State.FALLING


func _update_animation()->void:
	var anim_name: String = ""
	match current_state:
		State.IDLE: anim_name = "idle"
		State.RUN: anim_name = "run"
		State.FALLING: anim_name = "fall"
		State.JUMPING: anim_name = "jump"
		State.ATTACKING: anim_name = "attack"
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)


func _attack()->void:
	is_attacking = true
	if not animation_player.animation_finished.is_connected(_on_attack_finished):
		animation_player.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)



func _try_jump()->void:
	if is_on_floor():
		jump_sound.pitch_scale = 1.0
	elif _double_jump_charged:
		_double_jump_charged= false
		jump_sound.pitch_scale = 1.5
		var move_dir := Input.get_axis("move_left", "move_right")
		if move_dir != 0:
			velocity.x = move_dir * maxf(absf(velocity.x) * 1.5, walk_speed * 0.8)
	else:
		return
	velocity.y= jump_velocity
	jump_sound.play()


func _on_attack_finished(anim_name: String)->void:
	if anim_name == "attack":
		is_attacking = false
