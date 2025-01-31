extends Area2D
class_name HitBox

@export var damage : float = 30
@export var hit_stop : float = .2
## HIT STOP applied on the hit object only
@export var screw_state : float = .1
@export var screw_state_str : float = 30
## Strength of chormatic abberation
@export var chroma_str : float = 1
@export var cam_shake_str : float = 20
@export var to_ignore : CharacterBody2D
@export var vfx = preload("res://vfx/bullet_hit/hit_normal_vfx.tscn")


var collision_shape : CollisionShape2D

func _init() -> void:
	collision_layer = 32
	collision_mask = 0

func _ready() -> void:
	var child = self.get_child(0)
	if child is CollisionShape3D:
		collision_shape = child
