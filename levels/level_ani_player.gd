extends AnimationPlayer

func _ready() -> void:
	return
	self.play("default")
	GameManager.p1.is_input_enabled = false
	GameManager.p2.is_input_enabled = false
	

func enable_input() -> void:
	GameManager.p1.is_input_enabled = true
	GameManager.p2.is_input_enabled = true
