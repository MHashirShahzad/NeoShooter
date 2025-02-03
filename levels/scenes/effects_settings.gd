extends Control
class_name EffectsSettings
# EFFECTS -----------------------------------------------------------------------------------------
# spinboxes
@onready var chroma_edit: SpinBox = $Settings/Chroma/Edit
@onready var cam_shake_edit: SpinBox = $Settings/Camera/Edit
@onready var glow_edit: SpinBox = $Settings/Glow/Edit
@onready var label_size_edit: SpinBox = $Settings/HitEffect/Edit

# sliders
@onready var chroma_slider: HTweendSlider = $Settings/Chroma/ChromaticAbberationSlider
@onready var cam_shake_slider: HTweendSlider = $Settings/Camera/CameraShakeSlider
@onready var glow_slider: HTweendSlider = $Settings/Glow/GlowSlider
@onready var label_size_slider: HTweendSlider = $Settings/HitEffect/LabelSlider


@onready var cam_label: Label = $Settings/Camera/Label
@onready var chroma_rect: ColorRect = $Settings/Chroma/ChromaticAbberation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chroma_slider.value_changed.connect(_on_chromatic_abberation_slider_value_changed)
	cam_shake_slider.value_changed.connect(_on_camera_shake_slider_value_changed)
	glow_slider.value_changed.connect(_on_glow_slider_value_changed)
	label_size_slider.value_changed.connect(_on_label_slider_value_changed)
	
	chroma_edit.value_changed.connect(_on_chroma_edit_value_changed)
	cam_shake_edit.value_changed.connect(_on_cam_shake_edit_value_changed)
	glow_edit.value_changed.connect(_on_glow_edit_value_changed)
	label_size_edit.value_changed.connect(_on_label_size_edit_value_changed)
	
	
	set_effects_label_values()


# Effects <===========================================================================================>
func shake_ani() -> void:
	var shake_val : float = 1 * GameManager.user_prefs.screen_shake_multiplier
	cam_label.position.x += shake_val
	await get_tree().create_timer(.05).timeout
	cam_label.position.x -= shake_val

# Custom SET FUNCTIONS
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
	glow_edit.get_line_edit().focus_neighbor_bottom = label_size_edit.get_line_edit().get_path()
	glow_slider.value = glow_edit.value
	
	label_size_edit.value = GameManager.user_prefs.hit_effect_text_size
	label_size_edit.get_line_edit().text = str(label_size_edit.value)
	label_size_edit.get_line_edit().caret_blink = true
	# edits wont be useedeeeeeeeeeeeeeeee
	# label_size_edit.get_line_edit().focus_neighbor_bottom = $Back.get_path()
	label_size_edit.value = label_size_edit.value
	# update_glow_label()
	set_chroma_rect_value(chroma_edit.value)
	set_glow_label_value(glow_edit.value)

func set_chroma_rect_value(value : float):
	chroma_rect.material.set("shader_parameter/chroma_strength", value)
	GameManager.user_prefs.chroma_multiplier = value
	GameManager.user_prefs.save()

func set_glow_label_value(value : float) -> void:
	var glow_label : Label = $Settings/Glow/Label
	glow_label.material.set("shader_parameter/glow_power", value)
	# print(glow_label.get("shader_parameter/glow_power"))

# EDITS SPIN BOXES
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
	
func _on_label_size_edit_value_changed(value: float) -> void:
	GameManager.user_prefs.hit_effect_text_size = value
	label_size_slider.value = value
	GameManager.user_prefs.save()
# SLIDERS
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
	
func _on_label_slider_value_changed(value: float) -> void:
	GameManager.user_prefs.hit_effect_text_size = value
	label_size_edit.value = value
	GameManager.user_prefs.save()
