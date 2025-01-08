extends CanvasLayer

const  LEVEL_SELECT :  PackedScene = preload("res://levels/level_select.tscn")
const MAIN_MENU :  PackedScene = preload("res://levels/main_menu.tscn")

const MAIN_MENU_MUSIC : AudioStream = preload("res://assets/audio/music/hashir/neon-gaming-128925.mp3")

func _on_restart_pressed() -> void:
	var current_level : String = get_tree().current_scene.scene_file_path
	TransitionManager.transition_scene_file(current_level)
	
	# faded in
	await  TransitionManager.transiton_finsihed
	self.hide()
	
	# faded out
	await TransitionManager.transition_fully_finished
	UIManager.is_pause_disabled = false


func _on_back_to_level_select_pressed() -> void:
	# delete references to p1 & p2
	GameManager.p1 = null
	GameManager.p2 = null
	TransitionManager.transition_scene_packed(LEVEL_SELECT)
	SFXManager.play_music(MAIN_MENU_MUSIC, -20)
	await TransitionManager.transiton_finsihed
	self.hide()

func _on_back_to_main_menu_pressed() -> void:
	# delete references to p1 & p2
	GameManager.p1 = null
	GameManager.p2 = null
	TransitionManager.transition_scene_packed(MAIN_MENU)
	SFXManager.play_music(MAIN_MENU_MUSIC, -20)
	await TransitionManager.transiton_finsihed
	self.hide()

## also deletes player references
func delete_all_bullets():
	GameManager.match_end()
