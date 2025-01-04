extends Button
class_name TweenedButton

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	self.mouse_entered.connect(_on_hovered)
	self.mouse_exited.connect(_on_unhovered)
	
func _on_pressed() -> void:
	pass

func _on_hovered() -> void:
	pass

func _on_unhovered() -> void:
	pass
