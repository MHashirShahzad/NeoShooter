extends Node2D
@onready var ani_player: AnimationPlayer = $AnimationPlayer
const TEST = preload("res://levels/test.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ani_player.animation_finished
	get_tree().change_scene_to_packed(TEST) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
