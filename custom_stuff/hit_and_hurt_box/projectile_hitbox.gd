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
	bullet.queue_free()
	#self.to_ignore.queue_free()
