extends Button
class_name TweenedButton

@export_group("Sounds")
@export var hover : AudioStream = preload("res://assets/audio/effects/btn_hover.mp3")
@export var press : AudioStream = preload("res://assets/audio/effects/btn_press.mp3")

var shake_str : float 
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	self.pivot_offset = Vector2(.5, .5)
	self.pressed.connect(_on_pressed)
	self.mouse_entered.connect(_on_hovered)
	self.mouse_exited.connect(_on_unhovered)
	
func _on_pressed() -> void:
	SFXManager.play_FX(press, -8)

	#var tween : Tween = get_tree().create_tween()
	#tween.tween_property(self, "rotation", 1, 1)
	#await  tween.finished
	
	
func _on_hovered() -> void:
	SFXManager.play_FX(hover, -8)
	#var tween : Tween = get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(1.2, 1.2), .2)
	#await  tween.finished
	#tween.kill()

func _on_unhovered() -> void:
	return
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), .2)
	await  tween.finished
	tween.kill()
