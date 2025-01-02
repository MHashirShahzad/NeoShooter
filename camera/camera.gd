extends Camera2D
class_name SpaceShooterCamera


@export_group("Camera Shake")
@export var rand_str : float = 30
@export var fade_out : float = 5

var rng = RandomNumberGenerator.new()
var shake_str : float = 0


func _ready() -> void:
	VFXManager.camera = self

func apply_shake():
	shake_str = rand_str
	
func _process(delta: float) -> void:
	if shake_str > 0:
		shake_str = lerpf(shake_str, 0, fade_out * delta)
		offset = rand_offset()

func rand_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str, shake_str), rng.randf_range(-shake_str, shake_str))
