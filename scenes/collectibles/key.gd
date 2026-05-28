extends Area2D

@onready var interact_prompt: Control = $InteractPrompt
var player: Player = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interact_prompt.hide()
	add_to_group("keys")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		interact_prompt.show()

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		interact_prompt.hide()

# Dùng _unhandled_input để tránh lỗi bấm phím lung tung
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player:
		collect()

func collect() -> void:
	player.collect_key()
	hide()
	process_mode = PROCESS_MODE_DISABLED

func respawn_key() -> void:
	show()
	process_mode = PROCESS_MODE_INHERIT
	player = null
	interact_prompt.hide()
