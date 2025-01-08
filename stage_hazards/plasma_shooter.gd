extends Node2D
class_name PlasmaShooter2D

@export var speed : float = 0.2

var bullet_spawn_locations : Array[Marker2D]
const PLASMA_BULLET = preload("res://bullets/plasma_bullet.tscn")

@onready var body: Polygon2D = $MainBody

func _ready() -> void:
	for child in $BulletSpawnLocations.get_children():
		if child is Marker2D:
			bullet_spawn_locations.append(child)

func shoot_in_all_dir() -> void:
	for loc in bullet_spawn_locations:
		shoot_bullet(loc)

func shoot_bullet(spawn_location : Marker2D) -> void:
	var bullet : Bullet2D = PLASMA_BULLET.instantiate() # sets the bullet variable accr to type
	
	bullet.assign_var()
	bullet.body.color = body.color
	bullet.rotation = spawn_location.rotation
	
	VFXManager.shoot_vfx(spawn_location.global_position)
	SFXManager.play_FX_2D(SFXManager.SHOOT, spawn_location.global_position, -20)
	
	# bullet.hit_box.to_ignore = self
	# apply_bullet_color(player, bullet)
	BulletManager.add_child(bullet)
	bullet.global_position = spawn_location.global_position
	bullet.direction = self.global_position.direction_to(bullet.global_position)
