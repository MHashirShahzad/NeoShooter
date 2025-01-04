extends Node2D


@onready var ani_player: AnimationPlayer = $AnimationPlayer
const MAIN_MENU = preload("res://levels/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ani_player.animation_finished
	TransitionManager.transition_scene_packed(MAIN_MENU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
