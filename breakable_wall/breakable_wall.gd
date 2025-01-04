extends CharacterBody2D
class_name Wall2D

@export var health : float = 50
@onready var hurtbox_coll: CollisionPolygon2D = $HurtBox/Coll
@onready var coll: CollisionPolygon2D = $Coll
@export var player : Player2D
@onready var breakable_wall: PlayerBody = $BreakableWall


func _ready() -> void:
	hurtbox_coll.polygon = breakable_wall.polygon
	coll.polygon = breakable_wall.polygon
	
	
func on_hit(dmg: float, hitbox : HitBox) -> void:
	if player == hitbox.to_ignore:
		return
	self.health -= dmg
	
	if health <= 0:
		health = 0
		die()
	else: 
		VFXManager.hit_effects(hitbox)

func die() -> void:
	
	# hide visuals
	#self.hide()
	for child in get_children():
		if child is Node2D:
			child.hide()
	
	breakable_wall.is_player_dead = true
	breakable_wall.shatter()
	self.coll.set_deferred("disabled", true)
	self.hurtbox_coll.set_deferred("disabled", true)
