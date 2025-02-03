extends Control
class_name AudioSettings


# Sounds -----------------------------------------------------------------------------------------
# spinboxes

@onready var sfx_edit: SpinBox = $Settings/SFX/SFXEdit
@onready var music_edit: SpinBox = $Settings/Music/MusicEdit
@onready var master_edit: SpinBox = $Settings/Master/MasterEdit

# sliders
@onready var music_slider: HTweendSlider = $Settings/Music/MusicSlider

@onready var sfx_slider: HTweendSlider = $Settings/SFX/SFXSlider

@onready var master_slider: HTweendSlider = $Settings/Master/MasterSlider



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	
	music_edit.value_changed.connect(_on_music_edit_value_changed)
	sfx_edit.value_changed.connect(_on_sfx_edit_value_changed)
	master_edit.value_changed.connect(_on_master_edit_value_changed)
	
	
	set_audio_label_values()

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
