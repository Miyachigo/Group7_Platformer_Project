# player_state.gd
extends State
class_name PlayerState

## Helper class for Player states.
## Provides quick access to the Player node.

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "PlayerState must be a child of a Player node (or its StateMachine).")
