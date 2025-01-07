extends Resource
class_name UserPreferences


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
static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
