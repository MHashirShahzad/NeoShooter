extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction : Vector2

func _physics_process(delta: float) -> void:

	# Handle jump.
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
