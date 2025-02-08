extends HSlider
class_name HTweendSlider

const SLIDER : AudioStream = preload("res://assets/audio/slider.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pivot_offset = Vector2(self.size / 2)
	
	self.mouse_entered.connect(focused)
	self.focus_entered.connect(focused)
	
	self.mouse_exited.connect(un_focused)
	self.focus_exited.connect(un_focused)


func focused() -> void:
	SFXManager.play_FX(SLIDER, -10)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .2)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	tween.kill()

func un_focused() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), .2)
	tween.set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	tween.kill()
