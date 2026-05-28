extends CanvasLayer

@onready var start_button: Button = %StartButton

func _ready() -> void:
	# Pause the game when the popup appears
	get_tree().paused = true
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	# Unpause and remove the popup
	get_tree().paused = false
	queue_free()
