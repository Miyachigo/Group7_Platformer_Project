# run_state.gd
extends PlayerState

func enter(_msg: Dictionary = {}) -> void:
	player.animation_player.play("run")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.handle_movement_input()
	player.move_and_slide()

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	elif is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
