extends Control
class_name MainMenu




@onready var main: Panel = $CanvasLayer/MainBtn
@onready var option: Panel = $CanvasLayer/OptionBtn

@onready var game_name: Label = $CanvasLayer/Logo/HBOX/GameName
@onready var ani_player: AnimationPlayer = $AniPlayer


var LEVEL_SELECT = load("res://levels/level_select.tscn")


func _ready() -> void:
	main_menu_grab_focus()
	var rand_no = randi_range(0,10000)
	if rand_no == 9999:
		game_name.text = "☭NeoShooter"
		# add soviet union music



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		if option.visible:
			_on_back_pressed()

func _on_play_button_pressed() -> void:
	TransitionManager.transition_scene_packed(LEVEL_SELECT)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	ani_player.play("main_to_option")
	option_menu_grab_focus()



func _on_back_pressed() -> void:
	ani_player.play_backwards("main_to_option")
	main_menu_grab_focus(true) # pick option btn

func main_menu_grab_focus(option_btn : bool = false) -> void:
	if option_btn:
		$CanvasLayer/MainBtn/VBOX/OptionsButton.grab_focus()
	else:
		$CanvasLayer/MainBtn/VBOX/PlayButton.grab_focus()


func option_menu_grab_focus() -> void:
	$CanvasLayer/OptionBtn/TabContainer/Controls/Controls/HBoxContainer3/Remap_Button.grab_focus()
