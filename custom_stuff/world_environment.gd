extends WorldEnvironment

func _ready() -> void:
	GameManager.world_env = self
	environment.glow_intensity = GameManager.user_prefs.glow_intensity
