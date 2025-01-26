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


func _on_full_screen_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("Full screen")
		full_screen_btn.text = "Enabled"
		GameManager.user_prefs.window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	else:
		print("not full screen")
		# already windowed
		# re-making it windowed reverts the current win-size to normal which isnt
		# ideal, so we just dont do it again :L:
		if GameManager.user_prefs.window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			full_screen_btn.text = "Disabled"
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
