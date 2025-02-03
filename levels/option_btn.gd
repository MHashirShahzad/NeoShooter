extends Panel
class_name OptionMenu

@onready var reset_btn: TweenedButton = $Reset


@onready var display_settings: DisplaySettings = $TabContainer/Display
@onready var audio_settings: AudioSettings = $TabContainer/Audio
@onready var effects_settings: EffectsSettings = $TabContainer/Effects



var remap_btns : Array[Remap_Button] = []

func _ready() -> void:
	set_correct_neighbors_remappable_buttons()
	

## I KNOW ITS BAD but i dont want to set focus mannually :C
func set_correct_neighbors_remappable_buttons():
	var controls : VBoxContainer = $TabContainer/Controls/Controls
	var prev_button : Remap_Button
	print("---------- Remappable Buttons ----------")
	
	for i in controls.get_children():
		for j in i.get_children():
			
			if j is Remap_Button:
				remap_btns.append(j)
				# set custom size cuz it would look wierd without this
				j.custom_minimum_size = Vector2(500, 41)
				
				if prev_button:
					j.focus_neighbor_top = prev_button.get_path()
					prev_button.focus_neighbor_bottom = j.get_path()
					print("	- SELF: ",j.action, " Neighbor TOP : ", prev_button.action)
				
				prev_button = j
	print("----------------------------------------")
				
func _unhandled_input(event: InputEvent) -> void:
	if !self.visible:
		return
	
	var tab_bar : TabBar = $TabContainer.get_tab_bar()
	if Input.is_action_just_pressed("ui_tab_left"):
		tab_bar.grab_focus()
		# if the player decides to go behind tab#0 he will be redirected to the last tab
		if tab_bar.current_tab == 0:
			tab_bar.current_tab = tab_bar.tab_count - 1
			return
		# or else minus one
		tab_bar.current_tab -= 1
		
	if Input.is_action_just_pressed("ui_tab_right"):
		tab_bar.grab_focus()
		# if tab count is greater than or equal to the total tabs + 1
		# as total tabs are 4 when the player reaches tab#5 he should 
		# be redirected to tab#0
		if tab_bar.current_tab == tab_bar.tab_count - 1:
			tab_bar.current_tab = 0
			return
		
		tab_bar.current_tab += 1
	


func _on_reset_pressed() -> void:
	GameManager.user_prefs = UserPreferences.create_new_save()
	GameManager.user_prefs.save()
	
	# matches display settings with file
	display_settings.match_display_settings()
	
	# works like the previous ones and gets value from GameManager
	effects_settings.set_effects_label_values()
	audio_settings.set_audio_label_values()
	
	for remap_btn in remap_btns:
		remap_btn.reset_to_default()
	
