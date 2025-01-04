extends Node2D


const MUSIC_1 : AudioStream = preload("res://assets/audio/music/hashir/fast-paced-boss-battle-230222.mp3")

func _ready() -> void:
	SFXManager.play_music(
		MUSIC_1,
		-10
	)
