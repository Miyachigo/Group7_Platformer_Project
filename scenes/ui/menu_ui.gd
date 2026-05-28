extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	resume_button.pressed.connect(resume)
	quit_button.pressed.connect(_on_quit_pressed)

func toggle_pause() -> void:
	if visible:
		resume()
	else:
		pause()

func pause() -> void:
	show()
	get_tree().paused = true

func resume() -> void:
	hide()
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()
