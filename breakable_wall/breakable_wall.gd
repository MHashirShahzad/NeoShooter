extends CharacterBody2D
class_name Wall2D

@export var health : float = 200
@export var player : Player2D
@export var near_death_color : Color

@onready var hurtbox_coll: CollisionPolygon2D = $HurtBox/Coll
@onready var coll: CollisionPolygon2D = $Coll
@onready var breakable_wall: PlayerBody = $BreakableWall


func _ready() -> void:
	hurtbox_coll.polygon = breakable_wall.polygon
	coll.polygon = breakable_wall.polygon
	breakable_wall.color = player.body.color
	
func on_hit(dmg: float, hitbox : HitBox) -> void:
	#if player == hitbox.to_ignore:
		#VFXManager.hit_effects(hitbox)
		#return
		
	self.health -= dmg
	var weight : float = pow(1 - (health / 200), 3) 
	breakable_wall.color = lerp(breakable_wall.color, near_death_color, weight)
	
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
