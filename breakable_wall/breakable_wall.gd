extends CharacterBody2D
class_name Wall2D

@export var health : float = 200
@export var player : Player2D
@export var near_death_color : Color
@export var is_unbreakable : bool = false
## only applied to movable walls
@export var speed : float = 0.2

@onready var hurtbox_coll: CollisionPolygon2D = $HurtBox/Coll
@onready var coll: CollisionPolygon2D = $Coll
@onready var breakable_wall: PlayerBody = $BreakableWall



func _ready() -> void:
	hurtbox_coll.polygon = breakable_wall.polygon
	coll.polygon = breakable_wall.polygon
	
	# unbreakable walls dont belong to player so they dont need to update color
	if is_unbreakable:
		# disable collision cuz issue
		coll.disabled = true
		return
	breakable_wall.color = player.body.color
	
func on_hit(dmg: float, hitbox : HitBox) -> void:
	if is_unbreakable:
		VFXManager.hit_effects(hitbox, 0)
		return
	#if player == hitbox.to_ignore:
		#VFXManager.hit_effects(hitbox)
		#return
		
	self.health -= abs(dmg) #  might be -ve
	var weight : float = pow(1 - (health / 200), 3) 
	breakable_wall.color = lerp(breakable_wall.color, near_death_color, weight)
	
	if health <= 0:
		health = 0
		die()
	else: 
		VFXManager.hit_effects(hitbox, abs(dmg))

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
