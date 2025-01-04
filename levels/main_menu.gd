extends Control

@onready var ani_player: AnimationPlayer = $AniPlayer
const LEVEL_A = preload("res://levels/level_a.tscn")
const LEVEL_B = preload("res://levels/level_b.tscn")
func _on_play_button_pressed() -> void:
	ani_player.play("main_to_level")



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	ani_player.play("main_to_option")


func _on_back_pressed() -> void:
	ani_player.play("option_to_main")


func _on_back_level_pressed() -> void:
	ani_player.play("level_to_main")


func _on_level_a_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_A)


func _on_level_b_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_B)
