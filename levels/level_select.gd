extends Node2D

const MAIN_MENU = preload("res://levels/main_menu.tscn")

@export var level_array : Array[LevelStruct] = []
@export var music_array : Array[AudioStream] = [
	preload("res://assets/audio/music/hashir/a-video-game-248444.mp3"),
	preload("res://assets/audio/music/hashir/fast-paced-boss-battle-230222.mp3"),
	preload("res://assets/audio/music/hashir/game-music-teste-1-204326.mp3"),
	preload("res://assets/audio/music/hashir/intense-electro-trailer-music-243987.mp3"),
	preload("res://assets/audio/music/hashir/space-station-247790.mp3"),
	preload("res://assets/audio/music/hashir/stranger-things-124008.mp3")
]
@onready var level_rect: TextureRectRounded = $CanvasLayer/LevelSelect/LevelContainer/Panel/LevelRect
@onready var tooltip_label: Label = $CanvasLayer/ToolTipLabel
var level_prefs : LevelSelectPreferences


# i know un optimized but :C
func _process(delta: float) -> void:
	if %PrevLevel.has_focus():
		tooltip_label.text = "Previous level"
	elif %RandomLevel.has_focus():
		tooltip_label.text = "Pick a random level"
	elif %NextLevel.has_focus():
		tooltip_label.text = "Next level"
	elif %BackLevel.has_focus():
		tooltip_label.text = "Back to main-menu"
	elif %PlayLevel.has_focus():
		tooltip_label.text = "Start the match"
	# somewhat nice lookin
	tooltip_label.text = "- " + tooltip_label.text + " -"


func _ready() -> void:
	
	$CanvasLayer/LevelSelect/LevelContainer/HBoxContainer/RandomLevel.grab_focus()
	level_prefs = LevelSelectPreferences.load_or_create()
	refresh_image()

func refresh_image() -> void:
	level_prefs.level_index = abs(level_prefs.level_index)
	
	# dont let it exceed
	if level_prefs.level_index >= level_array.size():
		level_prefs.level_index = 0

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
	
	var tween := get_tree().create_tween()
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
