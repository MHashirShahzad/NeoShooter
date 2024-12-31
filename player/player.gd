extends CharacterBody2D
class_name Player

@export_group("Physics")
@export var speed : int = 60000
@export var friction : float = 0.1
@export var acceleration : float = 0.4

@export_group("Input")
@export var input : CustomInput

@onready var bullet_spawn_location: Marker2D = $BulletSpawnLocation
@onready var ani_player: AnimationPlayer = $AnimationPlayer
@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var hurt_box: HurtBox = $HurtBox

var direction : Vector2
var wish_dir : Vector2
var health : float = 100
var is_input_enabled : bool = true

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
	direction = (Vector2(wish_dir.x, wish_dir.y)).normalized()
	
	if direction:
		velocity = velocity.lerp(direction * speed * delta, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
func _input(event: InputEvent) -> void:
	if !is_input_enabled:
		return
	if Input.is_action_just_pressed(input.shoot):
		shoot()

func shoot() -> void:
	BulletManager.shoot_bullet(self)
	
func on_hit(dmg: float) -> void:
	self.health -= dmg
	if health <= 0:
		health = 0
		die()
	ani_player.play("hit_flash")

func screw_state(duration : float, time_scale : float = 0.05) -> void:
	if self.speed == 100: # if already in screw state
		return 
		
	var def_speed = self.speed
	self.speed = 100
	await  get_tree().create_timer(duration).timeout
	
	self.speed = def_speed

func die() -> void:
	# hide visuals
	self.hide()
	
	# disable colllision and hurt box
	self.coll_shape.set_deferred("disabled", true)
	self.hurt_box.coll_shape.set_deferred("disabled", true)
	
	# disable input
	self.is_input_enabled = false
