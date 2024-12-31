extends CharacterBody2D
class_name Bullet2D

static var speed = 300.0
var direction : Vector2
@onready var hit_box: ProjectileHitBox = $HitBox

func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
