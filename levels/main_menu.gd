extends Control

@onready var ani_player: AnimationPlayer = $AniPlayer

const TEST = preload("res://levels/test.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	TransitionManager.transition_scene_packed(TEST)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	ani_player.play("main_to_option")


func _on_back_pressed() -> void:
	ani_player.play("option_to_main")
