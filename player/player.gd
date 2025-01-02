extends CharacterBody2D
class_name Player2D
# =============================================================================================
# Exports
@export_group("Physics")
@export var speed : int = 60000
@export var friction : float = 0.2
@export var acceleration : float = 0.4
@export var tilt_strength_x: float = 0.1  # Tilt intensity for X-axis
@export var tilt_strength_y: float = 0.1  # Tilt intensity for Y-axis
@export var tilt_speed: float = 10.0  # Speed of the tilt adjustment


@export_group("Input")
@export var input : CustomInput

@export_group("Bullets")
@export var max_bullet_count : int = 6

# =============================================================================================
# On ready
@onready var body: PlayerBody = $Polygon2D
@onready var bullet_spawn_location: Marker2D = $BulletSpawnLocation
@onready var ani_manager: PlayerAnimationManager = $AniManager

@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var hurt_box: HurtBox = $HurtBox
@onready var trails_vfx: CPUParticles2D = $Trails_VFX

# =============================================================================================
# variables
var direction : Vector2
var wish_dir : Vector2
var health : float = 100
var is_input_enabled : bool = true
var spawned_bullets : int = 0
var tilt_x: float = 0.0
var tilt_y: float = 0.0
# =============================================================================================
# Code

func _ready() -> void:
	# GameManager References
	if self.name == "Player2":
		GameManager.p2 = self
	else:
		GameManager.p1 = self

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()

func move(delta : float) -> void:
	if !is_input_enabled:
		return
	wish_dir = Input.get_vector(input.left, input.right, input.up, input.down)
	
	skew_char()
	direction = (Vector2(wish_dir.x, wish_dir.y)).normalized()
	
	if direction:
		velocity = velocity.lerp(direction * speed * delta, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
func _input(event: InputEvent) -> void:
	if !is_input_enabled:
		return
	bullet_input()
	
func bullet_input() -> void:
	if Input.is_action_just_pressed(input.shoot):
		shoot(BulletManager.BULLET_TYPE.NORMAL)
	if Input.is_action_just_pressed(input.small_shoot):
		shoot(BulletManager.BULLET_TYPE.SMALL)
	if Input.is_action_just_pressed(input.big_shoot):
		shoot(BulletManager.BULLET_TYPE.BIG)

func shoot(type : BulletManager.BULLET_TYPE) -> void:
	var bullet_pos : Vector2 = bullet_spawn_location.global_position
	# low ammo
	if spawned_bullets >= max_bullet_count:
		ani_manager.low_ammo_ani()
		SFXManager.play_FX_2D(SFXManager.NO_AMMO, bullet_pos, 10)
		return
	
	
	BulletManager.shoot_bullet(self, type)
	spawned_bullets += 1
	
	# Effect
	ani_manager.shoot_ani()
	VFXManager.shoot_vfx(bullet_pos)
	SFXManager.play_FX_2D(SFXManager.SHOOT, bullet_pos, 10)
	
func on_hit(dmg: float) -> void:
	self.health -= dmg
	if health <= 0:
		health = 0
		die()
	ani_manager.hit_ani()
	
func screw_state(duration : float, str: float, time_scale : float = 0.05) -> void:
	# Screw state
	body.rand_str = str # random directional strength of screw
	body.screw_state()
	
	# Slow down speed for some time :C
	if self.speed == 100: # if already in screw state
		return 
		
	var def_speed = self.speed
	self.speed = 100
	await  get_tree().create_timer(duration).timeout
	
	self.speed = def_speed

func die() -> void:
	# hide visuals
	#self.hide()
	for child in get_children():
		if child is Node2D:
			child.hide()
			
	# shatter animation
	body.is_player_dead = true
	body.shatter()
	# disable colllision and hurt box
	self.coll_shape.set_deferred("disabled", true)
	self.hurt_box.coll_shape.set_deferred("disabled", true)
	
	# disable input
	self.is_input_enabled = false
	
	body.shatter()
	
func bullets_refilled() -> void:
	ani_manager.ammo_refilled_ani()
	SFXManager.play_FX_2D(
		SFXManager.BULLET_REFILLED,
		self.global_position,
		20
	)

func skew_char() -> void:
	if is_equal_approx(self.rotation_degrees, -90):
		body.skew = wish_dir.y / 8
		body.skew = -body.skew 
		return
	body.skew = wish_dir.y / 8
