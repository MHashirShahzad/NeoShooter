extends Control
const MAIN_MENU = preload("res://levels/main_menu.tscn")

@export var level_array : Array[LevelStruct] = []
@export var music_array : Array[AudioStream] = [
	preload("res://assets/audio/music/hashir/a-video-game-248444.mp3"),
	preload("res://assets/audio/music/hashir/fast-paced-boss-battle-230222.mp3"),
	preload("res://assets/audio/music/hashir/game-music-teste-1-204326.mp3"),
	preload("res://assets/audio/music/hashir/intense-electro-trailer-music-243987.mp3"),
	preload("res://assets/audio/music/hashir/neon-gaming-128925.mp3"),
	preload("res://assets/audio/music/hashir/space-station-247790.mp3"),
	preload("res://assets/audio/music/hashir/stranger-things-124008.mp3")
]
@onready var level_rect: TextureRect = $CanvasLayer/LevelSelect/BoxContainer/Panel/LevelRect
var level_prefs : LevelSelectPreferences

func _ready() -> void:
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
	level_prefs.save()
	var level : LevelStruct = level_array[level_prefs.level_index]
	TransitionManager.transition_scene_packed(level.path)
	var music : AudioStream = music_array.pick_random()
	SFXManager.play_music(music, -10)


func _on_prev_level_pressed() -> void:
	level_prefs.level_index -= 1
	refresh_image()

func _on_next_level_pressed() -> void:
	level_prefs.level_index += 1
	refresh_image()


func _on_random_level_pressed() -> void:
	level_prefs.save()
	var level : LevelStruct = level_array.pick_random()
	TransitionManager.transition_scene_packed(level.path)
	var music : AudioStream = music_array.pick_random()
	SFXManager.play_music(music, -10)
