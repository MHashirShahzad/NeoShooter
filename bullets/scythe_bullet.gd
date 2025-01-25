extends Bullet2D
class_name ScytheBullet2D

@onready var sour_spot_hit_box: ProjectileHitBox = $SourSpot
@onready var sweet_spot_hit_box: ProjectileHitBox = $SweetSpot

@export var rotation_speed : float = 20

func _process(delta: float) -> void:
	rotation -= delta * rotation_speed

# override timer
func _ready() -> void:
	sour_spot_hit_box.to_ignore = hit_box.to_ignore
	sweet_spot_hit_box.to_ignore = hit_box.to_ignore
	await $KillTimer.timeout
	
	if hit_box:
		print_debug("- Main Bullet.gd Timed out -")
		hit_box.destroy()


# if not in screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if hit_box:
		print_debug("- Scythe Bullet dead -")
		hit_box.destroy()
