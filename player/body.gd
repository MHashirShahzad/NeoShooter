extends Polygon2D

@export_group("Screw Shake")
@export var rand_str : float = 30
@export var fade_out : float = 5

var rng = RandomNumberGenerator.new()
var shake_str : float = 0

func screw_state():
	shake_str = rand_str

func _process(delta: float) -> void:
	if shake_str > 0:
		shake_str = lerpf(shake_str, 0, fade_out * delta)
		offset = rand_offset()

func rand_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str, shake_str), rng.randf_range(-shake_str, shake_str))
