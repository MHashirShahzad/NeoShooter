extends CharacterBody2D
## Custom Class used for all bullets :C
class_name Bullet2D

@export var speed : float = 900.0
@export var description : String 
@export var label : String = "[N]"
@export var type : BulletManager.BULLET_TYPE

var hit_box: ProjectileHitBox
var body: Polygon2D 
var trails_vfx: CPUParticles2D 
var visible_onscreen : VisibleOnScreenNotifier2D
var direction : Vector2

## i know this is stupid but it works and for God's sake dont touch it
## i wasted other ppl's time trynna figure out whats the issue was
## in bullet manager i call this func MANUALLY, 
func assign_var() -> void:
	hit_box = $ProjHitBox
	body = $MainBody
	trails_vfx = $Trails
	visible_onscreen = $VisibleOnScreenNotifier2D
	# print_debug(hit_box)

func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()

func _ready() -> void:
	await $KillTimer.timeout
	
	if hit_box:
		hit_box.destroy()


# if not in screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if hit_box:
		hit_box.destroy()
