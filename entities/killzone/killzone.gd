extends Area2D

## Simple script for a "Void" or "Killzone" area.
## Attach this to an Area2D with a CollisionShape2D.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.respawn()
