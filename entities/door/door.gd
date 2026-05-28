extends Area2D

var player_in_area: Player = null

# Nhớ đảm bảo bạn đã tạo Node Label tên là PromptLabel trong Scene cửa
@onready var prompt_label: Label = $PromptLabel 

func _ready() -> void:
	# ÉP CỬA TỰ ĐỘNG NỐI DÂY TÍN HIỆU (Sửa tận gốc lỗi kẹt âm thanh)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt_label.hide()

# Khi Cáo bước vào vùng cửa
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = body
		
		# Quét xem Cáo có chìa khóa chưa để hiện chữ tương ứng
		if player_in_area.has_key:
			prompt_label.text = "Press F to open the door"
		else:
			prompt_label.text = "No key collected, find the key!"
		
		prompt_label.show()

# Khi Cáo rời khỏi vùng cửa
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_area = null
		prompt_label.hide()

# Xử lý ấn nút F
func _unhandled_input(event: InputEvent) -> void:
	if player_in_area and event.is_action_pressed("interact"):
		
		if player_in_area.has_key:
			print("CỬA MỞ! CHÚC MỪNG BẠN ĐÃ QUA MÀN!")
			AudioManager.play_sound("door_open")
			player_in_area.complete_level()
			queue_free() 
		else:
			print("Cửa bị khóa! Bạn phải đi tìm chìa khóa trước.")
			AudioManager.play_sound("door_locked") # Tiếng lạch cạch
			prompt_label.text = "No key collected, find the key!"
