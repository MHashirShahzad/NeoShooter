extends CharacterBody2D
class_name Players

@export_group("Physics")
@export var speed : int = 300
@export var friction : float = 0.08
@export var acceleration : float = 0.4

var direction : Vector2
var wish_dir : Vector2


func _physics_process(delta: float) -> void:
	move()
	move_and_slide()

func move() -> void:
	wish_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (Vector2(wish_dir.x, wish_dir.y)).normalized()
	if direction:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
