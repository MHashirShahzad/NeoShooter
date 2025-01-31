extends CharacterBody2D
class_name Player2D
# =============================================================================================
# Exports

@export var is_input_enabled : bool = true

@export_group("Physics")
@export var speed : int = 60000
@export var friction : float = 0.2
@export var acceleration : float = 0.4
@export var tilt_strength_x: float = 0.1  
@export var tilt_strength_y: float = 0.1  
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
var spawned_bullets : int = 0
var tilt_x: float = 0.0
var tilt_y: float = 0.0
var is_dead : bool = false
var equipped_bullets : EquippedBullets = null
# =============================================================================================
# Code



func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()

func move(delta : float) -> void:
	if !is_input_enabled:
		# lerp velocity to 0 still even if input is disabled :C
		velocity = velocity.lerp(Vector2.ZERO, friction)
		wish_dir = Vector2(0, 0)
		skew_char() # skews to default when wish dir is 0 0
		return
	wish_dir = Input.get_vector(input.left, input.right, input.up, input.down)
	
	skew_char()
	# calculate_tilt(delta)
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
	if equipped_bullets == null:
		return
	
	
	if Input.is_action_just_pressed(input.shoot):
		shoot_with_scene(equipped_bullets.normal)
		#shoot(BulletManager.BULLET_TYPE.NORMAL)
	if Input.is_action_just_pressed(input.small_shoot):
		shoot_with_scene(equipped_bullets.small)
		#shoot(BulletManager.BULLET_TYPE.SMALL)
	if Input.is_action_just_pressed(input.big_shoot):
		shoot_with_scene(equipped_bullets.big)
		#shoot(BulletManager.BULLET_TYPE.BIG)

func shoot_with_scene(bullet_scene : PackedScene) -> void:
	var bullet_pos : Vector2 = bullet_spawn_location.global_position
	# low ammo
	if spawned_bullets >= max_bullet_count:
		ani_manager.low_ammo_ani()
		SFXManager.play_FX_2D(SFXManager.NO_AMMO, bullet_pos, 10)
		return
	
	
	BulletManager.shoot_bullet_with_scene(self, bullet_scene)
	spawned_bullets += 1
	
	# Effect
	ani_manager.shoot_ani()
	VFXManager.shoot_vfx(bullet_pos)
	SFXManager.play_FX_2D(SFXManager.SHOOT, bullet_pos, 10)
	

## deprecated dont use
## @deprecated: Use shoot_with_scene instead
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
	
func on_hit(dmg: float, hitbox : HitBox) -> void:
	# rounds of damage
	self.health -= round(dmg)
	# death vfx are handled in die()
	if health <= 0:
		health = 0
		die()
	else: 
		VFXManager.hit_effects(hitbox, dmg)
		# adjust music volume accr. to health
		SFXManager.adjust_music_volume()
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
	is_dead = true
	
	# hide visuals
	#self.hide()
	for child in get_children():
		if child is Node2D:
			child.hide()
			
	# disable pause cuz it would cause issues
	UIManager.can_pause = false
	# set next frame -_-
	UIManager.set_deferred("can_update_health", false)
	
	# shockwave particles cam shake and slow mo
	# also manages the victory screen 
	VFXManager.die_effects(self)
	
	# shatter animation
	body.is_player_dead = true
	body.shatter()
	
	
	# disable colllision and hurt box
	self.coll_shape.set_deferred("disabled", true)
	self.hurt_box.coll_shape.set_deferred("disabled", true)
	
	# disable input
	self.is_input_enabled = false
	

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


### DOESNT SEEM TO WORK SAMEE AS THE FUNC BEELOW IT
func calculate_tilt(delta : float):
	# Smoothly interpolate tilt values
	tilt_x = lerp(tilt_x, -wish_dir.y * tilt_strength_x, tilt_speed * delta)
	tilt_y = lerp(tilt_y, wish_dir.x * tilt_strength_y, tilt_speed * delta)

	# Create a custom Transform2D matrix for tilting
	var base_transform = get_transform()  # Preserve existing rotation/scale/position
	var tilt = Transform2D(
		Vector2(1, tilt_y),  # Modify the X-axis for Y-axis tilt
		Vector2(tilt_x, 1),  # Modify the Y-axis for X-axis tilt
		base_transform.origin  # Preserve the translation (position)
	)

	# Apply the tilt while maintaining base rotation
	set_transform(base_transform * tilt)



### BY GOD I DONT KNOW WHAT THIS DOES, BUT DONT U DARE TOUCH IT
### I AM TELLING U
func compose_transform(translation: Vector2, rot: float, skew_y: float, size: Vector2) -> Transform2D:
	var t := Transform2D()
	t[0][0] = cos(rot + skew_y) * size.x
	t[0][1] = sin(rot + skew_y) * size.x
	t[1][0] = -sin(rot) * size.y
	t[1][1] = cos(rot) * size.y
	t[2] = translation
	return t
