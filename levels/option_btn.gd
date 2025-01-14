extends Panel

# Variables <===========================================================================================>

# EFFECTS
@onready var cam_label: Label = $TabContainer/Effects/Settings/Camera/Label
@onready var chroma_edit: SpinBox = $TabContainer/Effects/Settings/Chroma/Edit
@onready var cam_shake_edit: SpinBox = $TabContainer/Effects/Settings/Camera/Edit
@onready var glow_edit: SpinBox = $TabContainer/Effects/Settings/Glow/Edit
@onready var chroma_rect: ColorRect = $TabContainer/Effects/Settings/Chroma/ChromaticAbberation

# SOUNDS
@onready var sfx_edit: SpinBox = $TabContainer/Audio/Controls/SFX/SFXEdit
@onready var music_edit: SpinBox = $TabContainer/Audio/Controls/Music/MusicEdit
@onready var master_edit: SpinBox = $TabContainer/Audio/Controls/Master/MasterEdit


func set_audio_label_values() -> void:
	music_edit.value = GameManager.user_prefs.music_volume
	music_edit.get_line_edit().text = str(music_edit.value)
	music_edit.get_line_edit().caret_blink = true
	
	sfx_edit.value = GameManager.user_prefs.sfx_volume
	sfx_edit.get_line_edit().text = str(sfx_edit.value)
	sfx_edit.get_line_edit().caret_blink = true
	
	master_edit.value = GameManager.user_prefs.master_volume
	master_edit.get_line_edit().text = str(master_edit.value)
	master_edit.get_line_edit().caret_blink = true
	
	print( music_edit.value, sfx_edit.value, master_edit.value)

	
func _ready() -> void:
	set_effects_label_values()
	set_audio_label_values()

func set_effects_label_values() -> void:
	chroma_edit.value = GameManager.user_prefs.chroma_multiplier
	chroma_edit.get_line_edit().text = str(chroma_edit.value)
	chroma_edit.get_line_edit().caret_blink = true
	chroma_edit.get_line_edit().focus_neighbor_bottom = cam_shake_edit.get_line_edit().get_path()
	
	cam_shake_edit.value = GameManager.user_prefs.screen_shake_multiplier
	cam_shake_edit.get_line_edit().text = str(cam_shake_edit.value)
	cam_shake_edit.get_line_edit().caret_blink = true
	cam_shake_edit.get_line_edit().focus_neighbor_bottom = glow_edit.get_line_edit().get_path()
	
	glow_edit.value = GameManager.user_prefs.glow_intensity
	glow_edit.get_line_edit().text = str(glow_edit.value)
	glow_edit.get_line_edit().caret_blink = true
	glow_edit.get_line_edit().focus_neighbor_bottom = $Back.get_path()
	
	update_glow_label()
	set_chroma_rect_value(chroma_edit.value)

func set_chroma_rect_value(value : float):
	chroma_rect.material.set("shader_parameter/chroma_strength", value)
	GameManager.user_prefs.chroma_multiplier = value
	GameManager.user_prefs.save()

func _on_chroma_edit_value_changed(value: float) -> void:
	set_chroma_rect_value(value)

func _on_cam_shake_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.screen_shake_multiplier = value
	GameManager.user_prefs.save()

func _on_glow_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.glow_intensity = value
	# update_glow_label()
	GameManager.user_prefs.save()

func shake_ani() -> void:
	var shake_val : float = 1 * GameManager.user_prefs.screen_shake_multiplier
	cam_label.position.x += shake_val
	await get_tree().create_timer(.05).timeout
	cam_label.position.x -= shake_val

func _on_music_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	GameManager.user_prefs.save()

func _on_sfx_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	GameManager.user_prefs.save()

func _on_master_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	GameManager.user_prefs.save()

# not called
func update_glow_label() -> void:
	var glow_label :Label = $TabContainer/Effects/Settings/Glow/Label
	var weight : float = GameManager.user_prefs.glow_intensity
	glow_label.modulate = lerp(glow_label.modulate
	, Color(0.125, 0.839, 0.78), weight)
