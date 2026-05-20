# attack_state.gd
extends PlayerState

func enter(_msg: Dictionary = {}) -> void:
	player.animated_sprite_2d.play("attack")
	if not player.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite_2d.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	if player.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.handle_movement_input()
	player.move_and_slide()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		if player.is_on_floor():
			if is_zero_approx(player.velocity.x):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Fall")
