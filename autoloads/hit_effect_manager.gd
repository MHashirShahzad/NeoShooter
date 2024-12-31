extends Node

var camera : SpaceShooterCamera

func _ready() -> void:
	var cameras : Array[Node] = get_tree().get_nodes_in_group("Camera")
	if cameras[0] is SpaceShooterCamera:
		camera = cameras[0]

func hit_stop(duration : float, time_scale : float = 0.05) -> void:

	var engine_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	
	await  get_tree().create_timer(duration * time_scale).timeout
	
	Engine.time_scale = engine_time_scale

func camera_shake(shake_str : float)  -> void:
	camera.rand_str = shake_str
	camera.apply_shake()
