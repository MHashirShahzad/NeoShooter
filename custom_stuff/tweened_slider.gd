extends HSlider
class_name HTweendSlider

const SLIDER : AudioStream = preload("res://assets/audio/slider.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(focused)
	self.focus_entered.connect(focused)


func focused() -> void:
	SFXManager.play_FX(SLIDER, -10)
