extends Bullet2D
class_name MissileBullet2D

@export var acceleration : float = 1
@export var dmg_increase : float = 2



func _process(delta: float) -> void:
	speed += delta * acceleration
	hit_box.damage += delta  * dmg_increase
