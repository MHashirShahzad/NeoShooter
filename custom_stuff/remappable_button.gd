extends TweenedButton
class_name Remap_Button

# Variables <=====================================================================================>
@export var action : String
var user_prefs: User_Preferences

# Actual Code <=====================================================================================>

# When created
func _init():
	toggle_mode = true
	theme_type_variation = "Remap_Button"

# On ready
func _ready():
	user_prefs = User_Preferences.load_or_create()
	set_process_unhandled_input(false)
	load_user_input()
	update_key_text()

# On clicked
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		
# Input
func _unhandled_input(event):
	if "pressed" in event:
		if event.pressed: 
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			button_pressed = false
			action_remapped(action, event)
			

# Set text of button
func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
	#if text.length() > 16:
		#text = text.left(text.length() - (text.length() - 16))
		#text = text.right(text.length() - (text.length() - 2))
		#text = "🎮" + text
	#elif text.length() > 5:
		#text = text.left(text.length() - (text.length() - 5))
		#text = "⌨️" + text
	#else:
		#text = "⌨️" + text
	#text = text.replace(" ", "") # Replace space with nothing
	
	
func action_remapped(action:String , event: InputEvent) -> void:
	if user_prefs:
		user_prefs.action_events[action] = event
		user_prefs.save()

func load_user_input():
	if user_prefs:
		if user_prefs.action_events.has(action):
			var event = user_prefs.action_events[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
