extends Panel


@onready var cam_label: Label = $TabContainer/Effects/Settings/Camera/Label
@onready var chroma_edit: SpinBox = $TabContainer/Effects/Settings/Chroma/Edit
@onready var cam_shake_edit: SpinBox = $TabContainer/Effects/Settings/Camera/Edit
@onready var glow_edit: SpinBox = $TabContainer/Effects/Settings/Glow/Edit

@onready var chroma_rect: ColorRect = $TabContainer/Effects/Settings/Chroma/ChromaticAbberation


func _ready() -> void:
	chroma_edit.value = GameManager.user_prefs.chroma_multiplier
	chroma_edit.get_line_edit().text = str(chroma_edit.value)
	
	cam_shake_edit.value = GameManager.user_prefs.screen_shake_multiplier
	cam_shake_edit.get_line_edit().text = str(cam_shake_edit.value)
	
	glow_edit.value = GameManager.user_prefs.glow_intensity
	glow_edit.get_line_edit().text = str(glow_edit.value)
	
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
	GameManager.user_prefs.save()

func shake_ani() -> void:
	var shake_val : float = 1 * GameManager.user_prefs.screen_shake_multiplier
	cam_label.position.x += shake_val
	await get_tree().create_timer(.05).timeout
	cam_label.position.x -= shake_val
