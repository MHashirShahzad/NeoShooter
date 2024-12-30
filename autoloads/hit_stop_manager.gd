extends Node


func hit_stop(duration : float, time_scale : float = 0.05) -> void:

	var engine_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	
	await  get_tree().create_timer(duration * time_scale).timeout
	
	Engine.time_scale = engine_time_scale
