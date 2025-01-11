extends Resource
class_name BulletStruct

# var main_bullet = preload("res://bullets/master_class/main_bullet.tscn")

@export var normal : PackedScene = load("res://bullets/normal_bullet.tscn")
@export var small : PackedScene = load("res://bullets/small_bullet.tscn")
@export var big : PackedScene = load("res://bullets/big_bullet.tscn")
