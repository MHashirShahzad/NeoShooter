extends Node2D
class_name LevelSelect
const MAIN_MENU = preload("res://levels/main_menu.tscn")

@export var level_array : Array[LevelStruct] = []
@export var music_array : Array[AudioStream] = [
	preload("res://assets/audio/music/hashir/a-video-game-248444.mp3"),
	preload("res://assets/audio/music/hashir/fast-paced-boss-battle-230222.mp3"),
	preload("res://assets/audio/music/hashir/game-music-teste-1-204326.mp3"),
	preload("res://assets/audio/music/hashir/intense-electro-trailer-music-243987.mp3"),
	preload("res://assets/audio/music/hashir/space-station-247790.mp3"),
	preload("res://assets/audio/music/hashir/stranger-things-124008.mp3"),
	preload("res://assets/audio/music/hashir/electric-horizons-239006.mp3"),
	preload("res://assets/audio/music/hashir/galactic-overture-241181.mp3"),
	# didnt like this one :C
	# preload("res://assets/audio/music/hashir/let-the-games-begin-21858.mp3"),
	preload("res://assets/audio/music/hashir/synth-city-80x27s-loop-167222.mp3"),
	preload("res://assets/audio/music/hashir/to-the-death-159171.mp3")
]

@onready var level_rect: TextureRectRounded = $CanvasLayer/LevelSelect/LevelContainer/Panel/LevelRect
@onready var tooltip_label: Label = $CanvasLayer/ToolTipLabel
var level_prefs : LevelSelectPreferences




func _ready() -> void:
	# whenever gui focus changes refresh tool tip text
	get_viewport().gui_focus_changed.connect(update_tooltip_text)
	
	$CanvasLayer/LevelSelect/LevelContainer/HBoxContainer/RandomLevel.grab_focus()
	level_prefs = LevelSelectPreferences.load_or_create()
	refresh_image()
	
	
func refresh_image() -> void:
	# level_prefs.level_index = abs(level_prefs.level_index)
	
	# dont let it exceed the size set to first
	if level_prefs.level_index >= level_array.size():
		level_prefs.level_index = 0
	
	# going below 0 set to max
	if level_prefs.level_index <= -1:
		level_prefs.level_index = level_array.size() - 1
	
	
	level_rect.texture = level_array[level_prefs.level_index].image
	
func _on_back_level_pressed() -> void:
	TransitionManager.transition_scene_packed(MAIN_MENU)

func _on_play_level_pressed() -> void:
	var level : LevelStruct = level_array[level_prefs.level_index]
	level_prefs.prev_level_index = level_prefs.level_index
	
	TransitionManager.transition_scene_packed(level.path)
	play_bg_music()
	level_prefs.save()

func _on_prev_level_pressed() -> void:
	level_prefs.level_index -= 1
	refresh_image()

func _on_next_level_pressed() -> void:
	level_prefs.level_index += 1
	refresh_image()

func _on_random_level_pressed() -> void:
	var level : LevelStruct =  level_array.pick_random()
	var index : int = level_array.find(level)
	
	if index == level_prefs.prev_level_index:
		level = level_array.pick_random()
		index = level_array.find(level)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_method(random_ani, 0, 0, .3)
	await tween.finished
	tween.kill()
	
	level_prefs.prev_level_index = index
	level_prefs.level_index = index
	refresh_image()
	# TransitionManager.transition_scene_packed(level.path)
	
	
	# play_bg_music()
	level_prefs.save()

func random_ani(value: int):
	level_prefs.level_index = randi_range(0, level_array.size() - 1)
	refresh_image()

func play_bg_music() -> void:
	var music : AudioStream = music_array.pick_random()
	var index : int = music_array.find(music)
	
	if index == level_prefs.prev_music_index:
		music = music_array.pick_random()
		index = music_array.find(music)
	
	level_prefs.prev_music_index = index
	
	SFXManager.play_music(music, -10)

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
	
