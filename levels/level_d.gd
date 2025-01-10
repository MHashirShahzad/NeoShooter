extends Node2D

@onready var path_follow_2d_1: PathFollow2D = $Path2D/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Path2D2/PathFollow2D

@onready var wall: Wall2D = $Path2D/PathFollow2D/Wall


func _process(delta: float) -> void:
	if !wall:
		return
	path_follow_2d_1.progress_ratio += delta * wall.speed
	path_follow_2d_2.progress_ratio += delta * wall.speed
