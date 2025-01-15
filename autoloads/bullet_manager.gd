extends Node2D

# WONT BE USED
enum BULLET_TYPE{
	NORMAL,
	SMALL,
	BIG,
	PLASMA
}
const BULLET : PackedScene = preload("res://bullets/missile_bullet.tscn")
const SMALL_BULLET : PackedScene = preload("res://bullets/small_bullet.tscn")
const BIG_BULLET : PackedScene = preload("res://bullets/big_bullet.tscn")



## deprecated dont use with_scene one
## @deprecated: Use bullet_with_scene instead
func shoot_bullet(player : Player2D, type : BULLET_TYPE):
	var bullet : Bullet2D = get_bullet_type(type) # sets the bullet variable accr to type
	
	bullet.assign_var()
	
	bullet.rotation = player.rotation
	bullet.hit_box.to_ignore = player
	apply_bullet_color(player, bullet)
	BulletManager.add_child(bullet)
	bullet.global_position = player.bullet_spawn_location.global_position
	bullet.direction = player.global_position.direction_to(bullet.global_position)

## called by player only :C
func shoot_bullet_with_scene(player : Player2D, scene : PackedScene):
	var bullet : Bullet2D = scene.instantiate()
	bullet.assign_var()
	bullet.rotation = player.rotation
	bullet.hit_box.to_ignore = player
	apply_bullet_color(player, bullet)
	BulletManager.add_child(bullet)
	bullet.global_position = player.bullet_spawn_location.global_position
	bullet.direction = player.global_position.direction_to(bullet.global_position)


func get_bullet_type(type : BULLET_TYPE) -> Bullet2D:
	var bullet : Bullet2D
	# get the bullet type
	match type:
		BULLET_TYPE.NORMAL:
			bullet = BULLET.instantiate()
			bullet.type = BULLET_TYPE.NORMAL
		BULLET_TYPE.BIG:
			bullet = BIG_BULLET.instantiate()
			bullet.type = BULLET_TYPE.BIG
		BULLET_TYPE.SMALL:
			bullet = SMALL_BULLET.instantiate()
			bullet.type = BULLET_TYPE.SMALL
		_:
			bullet = BULLET.instantiate()
			bullet.type = BULLET_TYPE.NORMAL
	return bullet

func apply_bullet_color(player : Player2D, bullet : Bullet2D):
	bullet.body.color = player.body.color
	bullet.trails_vfx.color_ramp = player.trails_vfx.color_ramp

func add_bullet_group(bullet : Bullet2D, player : Player2D):
	if player == GameManager.p1:
		bullet.add_to_group(GameManager.p1_bullet_id)
	elif player == GameManager.p2:
		bullet.add_to_group(GameManager.p2_bullet_id)

func destroy_all_bullets() -> void:
	var nodes = get_tree().get_nodes_in_group("Bullet")
	for node in nodes:
		if node is Bullet2D:
			node.hit_box.destroy()
