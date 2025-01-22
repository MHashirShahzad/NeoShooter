extends Node 

var camera : SpaceShooterCamera
var p1 : Player2D
var p2 : Player2D
var world_env : WorldEnvironment
var player_bullets : PlayerBullets

var user_prefs : UserPreferences

func _ready() -> void:
	user_prefs = UserPreferences.load_or_create()
	load_settings()
	
func _process(delta: float) -> void:
	var title : String = "%s (%s-fps)" % ["NeoShooter", str(Engine.get_frames_per_second())]
	DisplayServer.window_set_title(title)
	
func assign_bullets_to_players() -> void:
	player_bullets = PlayerBullets.load_or_create()
	p1.equiped_bullets = player_bullets.p1_bullets
	p2.equiped_bullets = player_bullets.p2_bullets

func match_end() -> void:
	if !p1:
		return
	if !p2:
		return
	disable_all_stage_hazards()
	# disable all input 
	p1.is_input_enabled = false
	p2.is_input_enabled = false
	# we need a transition so that player cant see if bullets are dead
	BulletManager.destroy_all_bullets()

func disable_all_stage_hazards() -> void:
	for node in get_tree().get_nodes_in_group("StageHazard"):
		if node.has_method("disable"):
			node.disable()

## called on `_ready()`
func load_settings() -> void:
	# set volumes accordingly
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(user_prefs.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(user_prefs.sfx_volume))
	
	# display
	DisplayServer.window_set_mode(user_prefs.window_mode)
	DisplayServer.window_set_vsync_mode(user_prefs.vsync_mode)
