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

	# make it accept keyboard controller and mouse keys
	if ! (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton):
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
	parse_command_line_args()

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

func parse_command_line_args():
	var arguments : Dictionary = {}

	for argument in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			arguments[argument.trim_prefix("--")] = ""

	## PURE BRAIN ROT COLORS
	print_rich("[color=red]C[/color][color=blue]M[/color][color=green]D[/color] [color=yellow]L[/color][color=cyan]I[/color][color=magenta]N[/color][color=orange]E[/color] ARGS EXIST!!!!")
	print_rich("[color=red] SYNTAX: --val1 --val2 [/color]")

	print("==============================================")

	# EN
	if arguments.keys().has("en") or arguments.keys().has("EN"):
		print_rich("[color=green] https://discord.gg/eliteninjas [/color]")

	if arguments.keys().has("clara"):
		print("meow ?")
		Input.set_custom_mouse_cursor(load("res://assets/clara-cursor.png"))

	if arguments.keys().has("royn"):
		print("SKILL ISSUE")

## add rich here @HASHIR
	if arguments.keys().has("loe"):
		print("is earth lost or are we lost on earth")

	if arguments.keys().has("pentagram"):
			print(":skull:💀")


	if arguments.keys().has("yellow"):
		print("Peela Admi fr")

	if arguments.keys().has("1983"):
		print("EVAN WAS INNOCENT!")

	print("==============================================")
