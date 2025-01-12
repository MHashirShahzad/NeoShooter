extends Resource
class_name PlayerBullets

@export var p1_bullets := EquippedBullets.new()
@export var p2_bullets := EquippedBullets.new()


# Saves as file
func save() -> void:
	ResourceSaver.save(self, "user://player-bullets.tres")
	
# Loads or creates
static func load_or_create() -> PlayerBullets:
	var res: PlayerBullets = load("user://player-bullets.tres") as PlayerBullets
	if !res:
		res = PlayerBullets.new()
	return res
