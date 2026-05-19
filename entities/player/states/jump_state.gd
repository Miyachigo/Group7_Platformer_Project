# jump_state.gd
extends PlayerState

func enter(_msg: Dictionary = {}) -> void:
	player.animation_player.play("jump")
	player.jump()


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.handle_movement_input()
	player.move_and_slide()

	if Input.is_action_just_pressed("jump") and player.can_double_jump():
		state_machine.transition_to("Jump", {"double_jump": true})
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if player.velocity.y >= 0:
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
