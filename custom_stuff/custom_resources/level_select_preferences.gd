extends Resource
class_name LevelSelectPreferences

@export var level_index : int = 0


# Saves as file
func save() -> void:
	ResourceSaver.save(self, "user://level-select-prefs.tres")
	
# Loads or creates
static func load_or_create() -> LevelSelectPreferences:
	var res: LevelSelectPreferences = load("user://level-select-prefs.tres") as LevelSelectPreferences
	if !res:
		res = LevelSelectPreferences.new()
	return res