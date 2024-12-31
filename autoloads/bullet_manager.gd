extends Node2D

var p1_bullets : Array[Bullet2D] = []
var p2_bullets : Array[Bullet2D] = []

const BULLET : PackedScene = preload("res://bullets/big_bullet.tscn")

func del_all_bullets():
	p1_bullets = []
	p2_bullets = []

func shoot_bullet(player : Player):
	var bullet = BULLET.instantiate()
	bullet._init()
	
	bullet.rotation = player.rotation
	bullet.hit_box.to_ignore = player
	apply_bullet_color(player, bullet)
	BulletManager.add_child(bullet)
	bullet.global_position = player.bullet_spawn_location.global_position
	bullet.direction = player.global_position.direction_to(bullet.global_position)
	
	# p1_bullets.append(bullet)

func apply_bullet_color(player : Player, bullet : Bullet2D):
	bullet.body.color = player.body.color
	bullet.trails_vfx.color_ramp = player.trails_vfx.color_ramp
