extends Control

const MAIN_MENU = preload("res://levels/main_menu.tscn")
const LEVEL_A = preload("res://levels/level_a.tscn")
const LEVEL_B = preload("res://levels/level_b.tscn")


func _on_back_level_pressed() -> void:
	print(MAIN_MENU)
	TransitionManager.transition_scene_packed(MAIN_MENU)


func _on_level_a_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_A)


func _on_level_b_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_B)
