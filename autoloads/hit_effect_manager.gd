extends Node2D

var camera : SpaceShooterCamera
const PARTICLES_HIT : PackedScene = preload("res://particles/hit_vfx.tscn")

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

func hit_vfx(hitbox: HitBox) -> void:
	var particle_vfx = PARTICLES_HIT.instantiate()
	self.add_child(particle_vfx)
	
	particle_vfx.global_position = hitbox.global_position
	particle_vfx.emitting = true
	
	await particle_vfx.finished
	
	self.remove_child(particle_vfx)
	particle_vfx.queue_free()
