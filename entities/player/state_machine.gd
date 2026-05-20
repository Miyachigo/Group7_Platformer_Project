extends Node
class_name StateMachine

## The state the machine starts in.
@export var initial_state: State

## The current active state.
var current_state: State


func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is State:
			child.state_machine = self
	
	if initial_state:
		transition_to(initial_state.name)


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	var target_state := get_node(target_state_name) as State
	if not target_state:
		return

	if current_state:
		current_state.exit()

	current_state = target_state
	current_state.enter(msg)
