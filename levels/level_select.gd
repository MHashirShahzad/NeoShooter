extends Node2D
class_name LevelSelect

const MAIN_MENU = preload("res://levels/scenes/main_menu.tscn")

@export var level_array : Array[LevelStruct] = []


@onready var level_rect: TextureRectRounded = $CanvasLayer/LevelSelect/LevelContainer/Panel/LevelRect
@onready var tooltip_label: Label = $CanvasLayer/ToolTipLabel




func _ready() -> void:
	# whenever gui focus changes refresh tool tip text
	get_viewport().gui_focus_changed.connect(update_tooltip_text)
	$CanvasLayer/LevelSelect/LevelContainer/HBoxContainer/RandomLevel.grab_focus()
	refresh_image()
	
	## (disables input) dont use :C
	## cuz i buffer the input when transition is being played
	## this straight up disables it [Skill Issue]
	#self.process_mode = Node.PROCESS_MODE_DISABLED
	#await TransitionManager.transition_fully_finished
	#self.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	
	if !event is InputEventMouseMotion:
		return
		
	var hovered_btn = get_viewport().gui_get_hovered_control()
	
	if hovered_btn is TweenedButton:
		hovered_btn.grab_focus()


func refresh_image() -> void:
	# GameManager.level_prefs.level_index = abs(GameManager.level_prefs.level_index)
	
	# dont let it exceed the size set to first
	if GameManager.level_prefs.level_index >= level_array.size():
		GameManager.level_prefs.level_index = 0
	
	# going below 0 set to max
	if GameManager.level_prefs.level_index <= -1:
		GameManager.level_prefs.level_index = level_array.size() - 1
	
	
	level_rect.texture = level_array[GameManager.level_prefs.level_index].image
	
func _on_back_level_pressed() -> void:
	TransitionManager.transition_scene_packed(MAIN_MENU)

func _on_play_level_pressed() -> void:
	var level : LevelStruct = level_array[GameManager.level_prefs.level_index]
	GameManager.level_prefs.prev_level_index = GameManager.level_prefs.level_index
	
	TransitionManager.transition_scene_packed(level.path)
	play_bg_music()
	GameManager.level_prefs.save()

func _on_prev_level_pressed() -> void:
	GameManager.level_prefs.level_index -= 1
	refresh_image()

func _on_next_level_pressed() -> void:
	GameManager.level_prefs.level_index += 1
	refresh_image()

func _on_random_level_pressed() -> void:
	var level : LevelStruct =  level_array.pick_random()
	var index : int = level_array.find(level)
	
	if index == GameManager.level_prefs.prev_level_index:
		level = level_array.pick_random()
		index = level_array.find(level)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_method(random_ani, 0, 0, .3)
	await tween.finished
	tween.kill()
	
	GameManager.level_prefs.prev_level_index = index
	GameManager.level_prefs.level_index = index
	refresh_image()
	# TransitionManager.transition_scene_packed(level.path)
	
	
	# play_bg_music()
	GameManager.level_prefs.save()

func random_ani(value: int):
	GameManager.level_prefs.level_index = randi_range(0, level_array.size() - 1)
	refresh_image()

func play_bg_music() -> void:
	SFXManager.play_random_bg_music()

## updates the tooltip text
func update_tooltip_text(focused_node : Control) -> void:
	
		
	if !focused_node is TweenedButton:
		return
	
	# its here causeit avoids - <empty-space> - 
	# the decorative lines
	if focused_node.description == "":
		tooltip_label.text = ""
		return
	tooltip_label.text = focused_node.description
	tooltip_label.text = "- " + tooltip_label.text + " -"
	
