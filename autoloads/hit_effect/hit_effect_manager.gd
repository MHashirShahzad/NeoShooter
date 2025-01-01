extends Node2D

# VFX
const NORMAL_HIT : PackedScene = preload("res://particles/bullet_hit/hit_normal_vfx.tscn")
const SMALL_HIT : PackedScene = preload("res://particles/bullet_hit/hit_small_vfx.tscn")
const BIG_HIT : PackedScene = preload("res://particles/bullet_hit/hit_big_vfx.tscn")


@onready var chroma_rect: ColorRect = $CanvasLayer/ChromaticAbberation
@onready var ani_player: AnimationPlayer = $AnimationPlayer
var camera : SpaceShooterCamera


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

func hit_vfx(hitbox: ProjectileHitBox) -> void:
	chormatic_abberation(hitbox)
	var particle_vfx  : CPUParticles2D = get_vfx_type(hitbox.bullet)
	self.add_child(particle_vfx)
	
	particle_vfx.global_position = hitbox.global_position
	particle_vfx.emitting = true
	
	await particle_vfx.finished
	
	self.remove_child(particle_vfx)
	particle_vfx.queue_free()

func chormatic_abberation(hitbox : HitBox):
	#chroma_rect.material.shader_parameter.spread = hitbox.chroma_str
	# set chroma str
	chroma_rect.material.set("shader_parameter/spread", hitbox.chroma_str)
	ani_player.play("hit")

func get_vfx_type(bullet : Bullet2D) -> CPUParticles2D:
	const BULLET_TYPE = BulletManager.BULLET_TYPE
	var particle_vfx : CPUParticles2D
	# get the bullet type
	match bullet.type:
		BULLET_TYPE.NORMAL:
			particle_vfx = NORMAL_HIT.instantiate()
		BULLET_TYPE.BIG:
			particle_vfx = BIG_HIT.instantiate()
		BULLET_TYPE.SMALL:
			particle_vfx = SMALL_HIT.instantiate()
		_:
			particle_vfx = NORMAL_HIT.instantiate()
			
	return particle_vfx
