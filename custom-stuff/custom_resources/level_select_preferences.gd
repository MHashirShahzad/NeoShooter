extends Resource
class_name LevelSelectPreferences

@export var level_index : int = 0

@export var prev_music_index : int
@export var prev_level_index : int


# Saves as file
func save() -> void:
	ResourceSaver.save(self, "user://level-select-prefs.tres")
	
# Loads or creates
static func load_or_create() -> LevelSelectPreferences:
	var res: LevelSelectPreferences = load("user://level-select-prefs.tres") as LevelSelectPreferences
	if !res:
		res = LevelSelectPreferences.new()
	return res
