extends TweenedButton
class_name Remap_Button

# Variables <=====================================================================================>
@export var action : String

# should get default event
@onready var default_event : InputEvent = InputMap.action_get_events(action)[0]
# Actual Code <=====================================================================================>

# When created
func _init():
	toggle_mode = true
	theme_type_variation = "Remap_Button"

# On ready
func _ready():
	self.pivot_offset = Vector2(self.size / 2)
	set_process_unhandled_input(false)
	load_user_input()
	update_key_text()
	# default_event = InputMap.action_get_events(action)[0]
	
	self.pressed.connect(_on_pressed)
	
	self.mouse_entered.connect(_on_hovered)
	self.focus_entered.connect(_on_hovered)
	
	self.mouse_exited.connect(_on_unhovered)
	self.focus_exited.connect(_on_unhovered)
	
## Returns to default settings
func reset_to_default() -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, default_event)
	update_key_text()

# On clicked
func _toggled(button_pressed):
	SFXManager.play_FX(press, -8)
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()

# Input
func _unhandled_input(event):
	
	# pressable both keyboard and controller OWO
	if "pressed" in event:
		if event.pressed: 
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			button_pressed = false
			action_remapped(action, event)
			
	if event is InputEventJoypadMotion:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		action_remapped(action, event)
	
	if event is InputEventMouseButton:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		action_remapped(action, event)
		
	# doesnt let others use the input :P
	get_viewport().set_input_as_handled()

# Set text of button
func update_key_text():
	var event : InputEvent = InputMap.action_get_events(action)[0]
	text = "%s" % event.as_text()
	
	if event is InputEventJoypadButton:
		controller_btn_name(event)
	
	if event is InputEventJoypadMotion:
		controller_joy_name(event)
	
func action_remapped(action:String , event: InputEvent) -> void:
	if GameManager.user_prefs:
		GameManager.user_prefs.action_events[action] = event
		GameManager.user_prefs.save()

func load_user_input():
	if GameManager.user_prefs:
		if GameManager.user_prefs.action_events.has(action):
			var event = GameManager.user_prefs.action_events[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)

## sets text based on controller button name
func controller_btn_name(event : InputEventJoypadButton):
	# gets btn name based on index
	match event.button_index:
		0:
			text = "[A]" # Bottom Action
		1:
			text = "[B]" # Right Action
		2:
			text = "[X]" # Left Action
		3:
			text = "[Y]" # Top Action
		4:
			text = "[Back]" # Back button
		5:
			text = "[Guide]" # Guide button
		6:
			text = "[Start]" # Start button
		7:
			text = "[LS]" # Left Stick (Press)
		8:
			text = "[RS]" # Right Stick (Press)
		9:
			text = "[LB]" # Left Shoulder
		10:
			text = "[RB]" # Right Shoulder
		11:
			text = "[D-pad Up]" # D-pad Up
		12:
			text = "[D-pad Down]" # D-pad Down
		13:
			text = "[D-pad Left]" # D-pad Left
		14:
			text = "[D-pad Right]" # D-pad Right
		15:
			text = "[Share]" # Xbox Share
		16:
			text = "[Paddle 1]" # Xbox Paddle 1
		17:
			text = "[Paddle 2]" # Xbox Paddle 2
		18:
			text = "[Paddle 3]" # Xbox Paddle 3
		19:
			text = "[Paddle 4]" # Xbox Paddle 4
		20:
			text = "[Touchpad]" # PS4/PS5 Touchpad
	# add device id
	# Gamepad<id> [key]
	text = "Gampad" + str(event.device) + " " + text

## sets text based on controller axis name and value
func controller_joy_name(event : InputEventJoypadMotion):
	# match based on AXIS
	match event.axis:
		0: # X axis left stick
			if event.axis_value > 0:
				text = "[LJoy-Right]"
			else:
				text = "[LJoy-Left]"
		1: # Y axis left stick
			if event.axis_value < 0:
				text = "[LJoy-Up]"
			else:
				text = "[LJoy-Down]"
		
		2: # X Axis right stick
			if event.axis_value > 0:
				text = "[RJoy-Right]"
			else:
				text = "[RJoy-Left]"
		3: # Y axis right stick
			if event.axis_value < 0:
				text = "[RJoy-Up]"
			else:
				text = "[RJoy-Down]"
		
		4: # LT & LEFT
			if event.axis_value > 0:
				text = "[LT]"
			else:
				text = "[J2_Left]"
		5: # RT AND UP
			if event.axis_value > 0:
				text = "[RT]"
			else:
				text = "[J2_Up]"
		
		# serioulsy idk
		# but might come in handy
		6:
			if event.axis_value > 0:
				text = "[J3_Right]"
			else:
				text = "[J3_Left]"
		7:
			if event.axis_value > 0:
				text = "[J3_Down]"
			else:
				text = "[J3_Up]"
		8:
			if event.axis_value > 0:
				text = "[J4_Right]"
			else:
				text = "[J4_Left]"
		9:
			if event.axis_value > 0:
				text = "[J4_Down]"
			else:
				text = "[J4_Up]"
	
	# add device id
	# Gamepad<id> [key]
	text = "Gampad" + str(event.device) + " " + text
