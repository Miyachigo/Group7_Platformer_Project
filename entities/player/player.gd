extends CharacterBody2D
class_name Player

@export_group("Player Properties")
@export_range(0, 1000, 0.1) var walk_speed: float = 300.0
@export var acceleration_speed_multiplier: float = 6.0
@export_range(-2000, 0, 1) var jump_velocity: float = -725.0 
@export var terminal_velocity: float = 700.0

@onready var platform_detector: RayCast2D = %PlatformDetector
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var camera_2d: Camera2D = %Camera2D
@onready var jump_sound: AudioStreamPlayer2D = %JumpSound
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


var gravity:int = ProjectSettings.get("physics/2d/default_gravity")
var _double_jump_charged: bool = false

var spawn_point: Vector2
var has_key: bool = false


func _ready() -> void:
	# Store the starting position as the respawn point
	spawn_point = global_position
	

func _physics_process(_delta: float) -> void:
	floor_stop_on_slope = not platform_detector.is_colliding()



func respawn() -> void:
	print("Player died/fell! Respawning...")
	global_position = spawn_point
	velocity = Vector2.ZERO # Reset movement


func collect_key() -> void:
	has_key = true
	print("Key collected! You can now complete the level.")


func complete_level() -> void:
	if has_key:
		print("WIN! Level Completed.")
	else:
		print("The door is locked... You need a key!")


func apply_gravity(delta: float)->void:
	if is_on_floor():
		_double_jump_charged = true
	velocity.y = minf(terminal_velocity, velocity.y + gravity * delta)


func handle_movement_input()->void:
	var direction := Input.get_axis("move_left", "move_right") * walk_speed
	velocity.x = move_toward(
		velocity.x,
		direction,
		walk_speed * get_physics_process_delta_time() * acceleration_speed_multiplier
	)
	
	if not is_zero_approx(velocity.x):
		animated_sprite_2d.flip_h = velocity.x <0
	
	if Input.is_action_just_released("jump") and velocity.y <= 0.0:
		velocity.y *= 0.6


func jump() -> void:
	if is_on_floor():
		pass # Không cần chỉnh pitch của loa cũ nữa
	elif _double_jump_charged:
		_double_jump_charged = false
		var move_dir := Input.get_axis("move_left", "move_right")
		if move_dir != 0:
			velocity.x = move_dir * maxf(absf(velocity.x) * 1.5, walk_speed * 0.8)
	else:
		# This shouldn't happen if can_double_jump() is checked
		return
		
	velocity.y = jump_velocity   
	
	# Đặt bẫy in nhật ký để xem game có bị lỗi gọi liên tục (Spam) không
	#print(">> Bắt đầu nhảy và phát âm thanh!")
	AudioManager.play_sound("player_jump")
	
func can_double_jump()->bool:
	return _double_jump_charged and not is_on_floor()
