extends Resource
class_name UserPreferences


# Variables <===========================================================================================>
## Stored keys and events of both players. Saves controls of p1 and p2.
@export var action_events: Dictionary = {
}

# visual effects :Poyo:
@export var chroma_multiplier : float = 1
@export var glow_intensity : float = .8
@export var screen_shake_multiplier : float = 1
@export var hit_effect_text_size : int = 40



# Sounds
## Master volume.
@export var master_volume : float = 1.0

## Music volume.
@export var music_volume : float = 1

## Sound effects volume.
@export var sfx_volume : float = 1


# Resolution stuff 
## Resolution in (x, y).
@export var resolution:Vector2i


@export var window_mode : DisplayServer.WindowMode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

@export var vsync_mode : DisplayServer.VSyncMode = DisplayServer.VSyncMode.VSYNC_ENABLED


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
