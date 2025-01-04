extends Resource
class_name User_Preferences


# Variables <===========================================================================================>
## Stored keys and events of both players. Saves controls of p1 and p2.
@export var action_events: Dictionary = {
}
# Levels

## Last loaded level.
@export var saved_level:String

## Points
@export var points:int

# Sounds

## Master volume.
@export var master_value:float

## Music volume.
@export var music_value:float

## Sound effects volume.
@export var sfx_value:float


# Resolution stuff 
## Resolution in (x, y).
@export var resolution:Vector2i

## Window mode "1" is WINDOWED and "3" is FULLSCREEN.
@export var window_mode:int
## Is borderless.
@export var is_borderless:bool

# Actual Code <===========================================================================================>

# Saves as file
func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
# Loads or creates
static func load_or_create() -> User_Preferences:
	var res: User_Preferences = load("user://user_prefs.tres") as User_Preferences
	if !res:
		res = User_Preferences.new()
	return res
