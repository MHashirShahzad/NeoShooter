extends Bullet2D
class_name BoomerangBullet2D

@export var rotation_speed : float = 20
@export var acceleration : float = 1000

func _process(delta: float) -> void:
	rotation += delta * rotation_speed
	speed -= delta * acceleration

# override timer
func _ready() -> void:
	pass


# if not in screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# didnt reverse direction
	if speed <= 0:
		if hit_box:
			print_debug("- Boomerang Bullet dead -")
			hit_box.destroy()
