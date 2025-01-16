extends Panel

# Variables <===========================================================================================>

# EFFECTS -----------------------------------------------------------------------------------------
# spinboxes
@onready var chroma_edit: SpinBox = $TabContainer/Effects/Settings/Chroma/Edit
@onready var cam_shake_edit: SpinBox = $TabContainer/Effects/Settings/Camera/Edit
@onready var glow_edit: SpinBox = $TabContainer/Effects/Settings/Glow/Edit

# sliders
@onready var chroma_slider: HTweendSlider = $TabContainer/Effects/Settings/Chroma/ChromaticAbberationSlider
@onready var cam_shake_slider: HTweendSlider = $TabContainer/Effects/Settings/Camera/CameraShakeSlider
@onready var glow_slider: HTweendSlider = $TabContainer/Effects/Settings/Glow/GlowSlider


@onready var cam_label: Label = $TabContainer/Effects/Settings/Camera/Label
@onready var chroma_rect: ColorRect = $TabContainer/Effects/Settings/Chroma/ChromaticAbberation

# Sounds -----------------------------------------------------------------------------------------
# spinboxes
@onready var sfx_edit: SpinBox = $TabContainer/Audio/Controls/SFX/SFXEdit
@onready var music_edit: SpinBox = $TabContainer/Audio/Controls/Music/MusicEdit
@onready var master_edit: SpinBox = $TabContainer/Audio/Controls/Master/MasterEdit

# sliders
@onready var music_slider: HTweendSlider = $TabContainer/Audio/Controls/Music/MusicSlider

@onready var sfx_slider: HTweendSlider = $TabContainer/Audio/Controls/SFX/SFXSlider

@onready var master_slider: HTweendSlider = $TabContainer/Audio/Controls/Master/MasterSlider


func _ready() -> void:
	set_effects_label_values()
	set_audio_label_values()
	

# Effects <===========================================================================================>

func set_effects_label_values() -> void:
	
	# i really hate that we have to set spinbox value and then the value inside the line edit i mean WHY BRO
	chroma_edit.value = GameManager.user_prefs.chroma_multiplier
	chroma_edit.get_line_edit().text = str(chroma_edit.value)
	chroma_edit.get_line_edit().caret_blink = true
	chroma_edit.get_line_edit().focus_neighbor_bottom = cam_shake_edit.get_line_edit().get_path()
	chroma_slider.value = chroma_edit.value
	
	
	cam_shake_edit.value = GameManager.user_prefs.screen_shake_multiplier
	cam_shake_edit.get_line_edit().text = str(cam_shake_edit.value)
	cam_shake_edit.get_line_edit().caret_blink = true
	cam_shake_edit.get_line_edit().focus_neighbor_bottom = glow_edit.get_line_edit().get_path()
	cam_shake_slider.value = cam_shake_edit.value
	
	glow_edit.value = GameManager.user_prefs.glow_intensity
	glow_edit.get_line_edit().text = str(glow_edit.value)
	glow_edit.get_line_edit().caret_blink = true
	glow_edit.get_line_edit().focus_neighbor_bottom = $Back.get_path()
	glow_slider.value = glow_edit.value
	
	# update_glow_label()
	set_chroma_rect_value(chroma_edit.value)
	set_glow_label_value(glow_edit.value)

func set_chroma_rect_value(value : float):
	chroma_rect.material.set("shader_parameter/chroma_strength", value)
	GameManager.user_prefs.chroma_multiplier = value
	GameManager.user_prefs.save()

func set_glow_label_value(value : float) -> void:
	var glow_label : Label = $TabContainer/Effects/Settings/Glow/Label
	glow_label.material.set("shader_parameter/glow_power", value)
	# print(glow_label.get("shader_parameter/glow_power"))

func _on_chroma_edit_value_changed(value: float) -> void:
	chroma_slider.value = value
	set_chroma_rect_value(value)

func _on_cam_shake_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.screen_shake_multiplier = value
	cam_shake_slider.value = value
	GameManager.user_prefs.save()

func _on_glow_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.glow_intensity = value
	glow_slider.value = value
	set_glow_label_value(value)
	GameManager.user_prefs.save()

func shake_ani() -> void:
	var shake_val : float = 1 * GameManager.user_prefs.screen_shake_multiplier
	cam_label.position.x += shake_val
	await get_tree().create_timer(.05).timeout
	cam_label.position.x -= shake_val

func _on_chromatic_abberation_slider_value_changed(value: float) -> void:
	set_chroma_rect_value(value)
	chroma_edit.value = GameManager.user_prefs.chroma_multiplier
	chroma_edit.get_line_edit().text = str(chroma_edit.value)

func _on_camera_shake_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.screen_shake_multiplier = value
	cam_shake_edit.value = GameManager.user_prefs.screen_shake_multiplier
	cam_shake_edit.get_line_edit().text = str(cam_shake_edit.value)

func _on_glow_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.glow_intensity = value
	glow_edit.value = GameManager.user_prefs.glow_intensity
	glow_edit.get_line_edit().text = str(glow_edit.value)
	set_glow_label_value(value)
	
# Audio <===========================================================================================>
func set_audio_label_values() -> void:
	
	music_edit.value = GameManager.user_prefs.music_volume
	music_edit.get_line_edit().text = str(music_edit.value)
	music_edit.get_line_edit().caret_blink = true
	music_slider.value = GameManager.user_prefs.music_volume
	
	sfx_edit.value = GameManager.user_prefs.sfx_volume
	sfx_edit.get_line_edit().text = str(sfx_edit.value)
	sfx_edit.get_line_edit().caret_blink = true
	sfx_slider.value = GameManager.user_prefs.sfx_volume
	
	master_edit.value = GameManager.user_prefs.master_volume
	master_edit.get_line_edit().text = str(master_edit.value)
	master_edit.get_line_edit().caret_blink = true
	master_slider.value = GameManager.user_prefs.master_volume
	
	print( music_edit.value, sfx_edit.value, master_edit.value)

func _on_music_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	GameManager.user_prefs.save()
	music_slider.value = value

func _on_sfx_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	GameManager.user_prefs.save()
	
	sfx_slider.value = value

func _on_master_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	GameManager.user_prefs.save()
	
	master_slider.value = value
	

func _on_music_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	GameManager.user_prefs.save()
	
	music_edit.value = GameManager.user_prefs.music_volume
	music_edit.get_line_edit().text = str(music_edit.value)

func _on_sfx_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	GameManager.user_prefs.save()
	
	sfx_edit.value = GameManager.user_prefs.sfx_volume
	sfx_edit.get_line_edit().text = str(sfx_edit.value)


func _on_master_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	GameManager.user_prefs.save()
	
	master_edit.value = GameManager.user_prefs.master_volume
	master_edit.get_line_edit().text = str(master_edit.value)
