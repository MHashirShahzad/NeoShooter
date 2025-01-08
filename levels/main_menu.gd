extends Control
class_name MainMenu

@onready var main: Panel = $CanvasLayer/MainBtn
@onready var option: Panel = $CanvasLayer/OptionBtn

@onready var game_name: Label = $CanvasLayer/Logo/HBOX/GameName
@onready var ani_player: AnimationPlayer = $AniPlayer


var LEVEL_SELECT = load("res://levels/level_select.tscn")


func _ready() -> void:
	var rand_no = randi_range(0,10000)
	if rand_no == 9999:
		game_name.text = "☭NeoShooter"
		# add soviet union music



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		if option.visible:
			ani_player.play_backwards("main_to_option")

func _on_play_button_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_SELECT)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	ani_player.play("main_to_option")


func _on_back_pressed() -> void:
		ani_player.play_backwards("main_to_option")
