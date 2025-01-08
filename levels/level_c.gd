extends Node2D

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var plasma_shooter: PlasmaShooter2D = $Path2D/PathFollow2D/PlasmaShooter


func _process(delta: float) -> void:
	if !plasma_shooter:
		return
	path_follow_2d.progress_ratio += delta * plasma_shooter.speed
