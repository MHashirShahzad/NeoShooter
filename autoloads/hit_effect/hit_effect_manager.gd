extends Node2D

@onready var ani_player: AnimationPlayer = $AnimationPlayer
var camera : SpaceShooterCamera
const PARTICLES_HIT : PackedScene = preload("res://particles/hit_vfx.tscn")



func hit_stop(duration : float, time_scale : float = 0.05) -> void:
	
	if Engine.time_scale == 0.05: # if already  started
		return
		
	var engine_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	
	await  get_tree().create_timer(duration * time_scale).timeout
	
	Engine.time_scale = engine_time_scale

func camera_shake(shake_str : float)  -> void:
	camera.rand_str = shake_str
	camera.apply_shake()

func hit_vfx(hitbox: HitBox) -> void:
	ani_player.play("hit")
	var particle_vfx = PARTICLES_HIT.instantiate()
	self.add_child(particle_vfx)
	
	particle_vfx.global_position = hitbox.global_position
	particle_vfx.emitting = true
	
	await particle_vfx.finished
	
	self.remove_child(particle_vfx)
	particle_vfx.queue_free()
