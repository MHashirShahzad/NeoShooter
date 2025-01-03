extends Node2D
@onready var player: Player2D = $Players/Player1

func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player.is_input_enabled:
		return
	var uv = (player.get_global_transform_with_canvas().get_origin()/ get_viewport().get_visible_rect().size)
	print(uv.y, get_viewport().get_visible_rect().size)
	player.body.color = Color(uv.x, uv.y, 0, 1)
