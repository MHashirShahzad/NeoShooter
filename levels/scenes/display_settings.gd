extends Control

@onready var full_screen_btn: TweenedButton = %FullScreenBtn
@onready var vsync_btn: TweenedButton = $Controls/Vsync/VsyncBtn


func _ready():
	match_display_settings()

func match_display_settings():
	
	# window mode
	match GameManager.user_prefs.window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			full_screen_btn.button_pressed = true
		_:
			full_screen_btn.button_pressed = false

	# vsync
	match GameManager.user_prefs.vsync_mode:
		DisplayServer.VSYNC_ENABLED:
			vsync_btn.button_pressed = true
		_:
			vsync_btn.button_pressed = false
	
	
	
#func add_option_items() -> void:
	#add_window_mode_items()
	#add_resolution_mode_items()
	#
#
#func add_window_mode_items() ->  void:
	#for window_mode in WINDOW_MODES:
		#window_mode_option_button.add_item(window_mode)
		#
#func add_resolution_mode_items() ->  void:
	#for resolution_mode in RESOLUTION_MODES:
		#resolution_option_button.add_item(resolution_mode)
	#resolution_option_button.selected = 3
#
#func _on_window_mode_selected(index : int):
	#match index:
		#0:#Windowed
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#resolution_option_button.disabled = false
			##DisplayServer.window_set_size(stored_res)
		#1:#Full screen
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			#resolution_option_button.disabled = true
	#
	#save()
#
#func _on_resolution_selected(index : int):
	##if DisplayServer.window_get_mode() == 3: # 3 is fullscreen while 1 is windowed
		##stored_res = RESOLUTION_MODES.values()[index]
	#DisplayServer.window_set_size(RESOLUTION_MODES.values()[index])
	#save()
#
#func save() -> void:
	#GameManager.user_prefs.resolution = DisplayServer.window_get_size()
	#GameManager.user_prefs.window_mode = DisplayServer.window_get_mode()
	#GameManager.user_prefs.is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	#GameManager.user_prefs.save()
#
#func get_current_res_and_apply() -> void:
	#if !GameManager.user_prefs:
		#return
		#
	#var res = GameManager.user_prefs.resolution
	#var win_mode = DisplayServer.window_get_mode()
	#var res_index = RESOLUTION_MODES.values().find(res)
	#var win_mode_index = win_mode
	#
	#if res_index == -1:
		#res_index = 0
		#stored_res = RESOLUTION_MODES.values()[res_index]
		#DisplayServer.window_set_size(stored_res)
		#
	#resolution_option_button.selected = res_index
	#borderless_button.button_pressed = GameManager.user_prefs.is_borderless
	#
	#if win_mode_index == 1:# Windowed
		#window_mode_option_button.selected = 0
		#resolution_option_button.disabled = false
	#elif win_mode_index == 3:# Full screen
		#window_mode_option_button.selected = 1
		#resolution_option_button.disabled = true
		#
	#
#
#
#func _on_check_button_toggled(toggled_on):
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	#save()


func _on_full_screen_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		full_screen_btn.text = "Enabled"
		GameManager.user_prefs.window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	else:
		# already windowed
		if GameManager.user_prefs.window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			return
		full_screen_btn.text = "Disabled"
		GameManager.user_prefs.window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	GameManager.user_prefs.save()
	DisplayServer.window_set_mode(GameManager.user_prefs.window_mode)

func _on_vsync_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		vsync_btn.text = "Enabled"
		GameManager.user_prefs.vsync_mode = DisplayServer.VSYNC_ENABLED
	else:
		vsync_btn.text = "Disabled"
		GameManager.user_prefs.vsync_mode = DisplayServer.VSYNC_DISABLED
		
	GameManager.user_prefs.save()
	DisplayServer.window_set_vsync_mode(GameManager.user_prefs.vsync_mode)
