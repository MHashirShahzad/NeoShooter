extends Button
class_name TweenedButton

@export var description : String

@export_group("Sounds")
@export var hover : AudioStream = preload("res://assets/audio/effects/btn_hover.mp3")
@export var press : AudioStream = preload("res://assets/audio/effects/btn_press.mp3")

## DEPRECATED
#var shake_str : float 
#var rng = RandomNumberGenerator.new()

func _ready() -> void:

	
	self.pivot_offset = Vector2(self.size / 2)
	self.pressed.connect(_on_pressed)
	
	self.mouse_entered.connect(_on_hovered)
	self.focus_entered.connect(_on_hovered)
	
	self.mouse_exited.connect(_on_unhovered)
	self.focus_exited.connect(_on_unhovered)
	

func _on_pressed() -> void:
	SFXManager.play_FX(press, -8)

	#var tween : Tween = get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(0.9, 0.9), .1)
	#await tween.finished
	#tween.kill()

func _on_hovered() -> void:
	SFXManager.play_FX(hover, -8)
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .2)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	tween.kill()
	
func _on_unhovered() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), .2)
	tween.set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	tween.kill()
