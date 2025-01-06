extends HitBox
class_name ProjectileHitBox

@onready var bullet: Bullet2D = $".."

func _init() -> void:
	collision_layer = 32
	collision_mask = 0

func _ready() -> void:
	var child = self.get_child(0)
	if child is CollisionShape3D:
		collision_shape = child

func destroy():
	# i know poor code :C 
	if !bullet.hit_box:
		return
	if !bullet:
		return
	if !bullet.hit_box.to_ignore:
		return
		
		
	var owner : Player2D = bullet.hit_box.to_ignore
	owner.spawned_bullets -= 1
	
	# play the bullet refill ani
	if owner.spawned_bullets <= 0:
		owner.bullets_refilled()
	
	bullet.queue_free()
	#self.to_ignore.queue_free()
