extends Node2D

const MAIN_MENU_MUSIC : AudioStream = preload("res://assets/audio/music/hashir/main_menu.mp3")
const MAIN_MENU : PackedScene = preload("res://levels/scenes/main_menu.tscn")

@onready var homie_label: RichTextLabel = $BootUpScreen/HomieLabel
@onready var yellow_label: RichTextLabel = $"BootUpScreen/Yellow Label"
@onready var ani_player: AnimationPlayer = $AnimationPlayer

enum STATES {
	HOMIE,
	YELLOW,
	NONE
}

var current_state : STATES 

func _input(event: InputEvent) -> void:
	if !event.is_pressed:
		return

	if ! (event is InputEventKey or event is InputEventJoypadButton):
		return
		
	match current_state:
		STATES.HOMIE:
			homie_despawn_ani()
		STATES.YELLOW:
			yellow_despawn_ani()
		_:
			return


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SFXManager.play_music(MAIN_MENU_MUSIC, -20, 0.5)
	homie_spawn_ani()
	# await ani_player.animation_finished
	
func homie_spawn_ani():
	current_state = STATES.HOMIE
	var tween = get_tree().create_tween()
	tween.tween_property(homie_label, "self_modulate", Color.WHITE, .5)
	await  tween.finished
	tween.kill()
	
func homie_despawn_ani():
	var tween = get_tree().create_tween()
	tween.tween_property(homie_label, "self_modulate", Color.TRANSPARENT, .5)
	await tween.finished
	tween.kill()
	yellow_spawn_ani()

func yellow_spawn_ani():
	current_state = STATES.YELLOW
	var tween = get_tree().create_tween()
	tween.tween_property(yellow_label, "self_modulate", Color.WHITE, .5)
	await  tween.finished
	tween.kill()
	
func yellow_despawn_ani():
	current_state = STATES.NONE
	var tween = get_tree().create_tween()
	tween.tween_property(yellow_label, "self_modulate", Color.TRANSPARENT, .5)
	await tween.finished
	tween.kill()
	TransitionManager.transition_scene_packed(MAIN_MENU)
