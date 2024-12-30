extends CharacterBody2D
class_name Player

@export_group("Physics")
@export var speed : int = 30000
@export var friction : float = 0.1
@export var acceleration : float = 0.4

@export_group("Input")
@export var input : CustomInput

var direction : Vector2
var wish_dir : Vector2

@onready var bullet_spawn_location: Marker2D = $BulletSpawnLocation

const BULLET : PackedScene = preload("res://bullets/bullet.tscn")

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()

func move(delta : float) -> void:
	wish_dir = Input.get_vector(input.left, input.right, input.up, input.down)
	direction = (Vector2(wish_dir.x, wish_dir.y)).normalized()
	
	if direction:
		velocity = velocity.lerp(direction * speed * delta, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input.shoot):
		shoot()

func shoot() -> void:
	var bullet = BULLET.instantiate()
	
	self.add_child(bullet)
	bullet.position = bullet_spawn_location.position
	var bullet_dir = self.global_position.direction_to(bullet_spawn_location.global_position)
	print(bullet_dir)
	bullet.direction = bullet_dir
