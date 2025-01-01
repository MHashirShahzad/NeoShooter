extends CharacterBody2D
class_name Bullet2D

@export var speed : float = 900.0
var direction : Vector2

@onready var hit_box: ProjectileHitBox = $ProjHitBox
@onready var body: Polygon2D = $MainBody
@onready var trails_vfx: CPUParticles2D = $Trails

func _init() -> void:
	hit_box = $ProjHitBox
	body = $MainBody
	trails_vfx = $Trails
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
	self.queue_free()
