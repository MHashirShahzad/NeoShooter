extends Node2D

const MAIN_MENU_MUSIC : AudioStream = preload("res://assets/audio/music/hashir/neon-gaming-128925.mp3")

@onready var ani_player: AnimationPlayer = $AnimationPlayer
const LEVEL_A = preload("res://levels/level_a.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SFXManager.play_music(MAIN_MENU_MUSIC, -10, 0.5)
	await ani_player.animation_finished
	TransitionManager.transition_scene_packed(LEVEL_A)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
