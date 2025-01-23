extends Node2D


const SHOOT : AudioStream = preload("res://assets/audio/shoot.ogg")
const NO_AMMO : AudioStream = preload("res://assets/audio/no_ammo.ogg")
const BULLET_REFILLED : AudioStream = preload("res://assets/audio/bullet_refilled3.ogg")

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func play_music(stream : AudioStream, volume = 10, fade_dur = 1) -> void:
	# fade previous music
	var tween := get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -70, fade_dur)
	await tween.finished
	tween.kill()
	
	music_player.bus = &"Music"
	music_player.stream = stream
	music_player.pitch_scale = 1.0
	music_player.play()
	# fade in new music
	var tween_2 := get_tree().create_tween()
	tween_2.tween_property(music_player, "volume_db", volume, fade_dur)
	await tween_2.finished
	tween_2.kill()
	

func play_FX(stream: AudioStream, volume = 10, lower_bound: int = 0.8, upper_bound: int = 1.3):
	# Create new stream player
	var fx_player = AudioStreamPlayer.new()
	# Assign its variables
	fx_player.bus = &"SFX"
	fx_player.stream = stream
	fx_player.name = "fx_player"
	fx_player.volume_db = volume
	# Add random pitch
	fx_player.pitch_scale = randf_range(lower_bound, upper_bound)
	add_child(fx_player)
	fx_player.play()
	# Destroy when completed
	await fx_player.finished
	fx_player.queue_free()

func play_FX_2D(stream: AudioStream,pos : Vector2, volume = 10, lower_bound: int = 1, upper_bound: int = 1.5):
	# Create new stream player
	var fx_player = AudioStreamPlayer2D.new()
	# Assign its variables
	fx_player.global_position = pos
	fx_player.bus = &"SFX"
	fx_player.stream = stream
	fx_player.name = "fx_player"
	fx_player.volume_db = volume
	# Add random pitch
	fx_player.pitch_scale = randf_range(lower_bound, upper_bound)
	add_child(fx_player)
	fx_player.play()
	# Destroy when completed
	await fx_player.finished
	fx_player.queue_free()

func adjust_music_volume():
	# if any player is invalid
	if !(GameManager.p1 or GameManager.p2):
		return
	
	var lowest_health : float
	if GameManager.p1.health < GameManager.p2.health:
		lowest_health = GameManager.p1.health
	else:
		lowest_health = GameManager.p2.health
	
	if lowest_health > 50:
		return
	
	print_debug("---- Music Speed Increased ----")
	var music_speed : int = 1.2
	
	var tween := get_tree().create_tween()
	tween.tween_property(music_player, "pitch_scale", music_speed, 1)
	await tween.finished
	tween.kill()
