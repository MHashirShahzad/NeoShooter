extends Node2D




func _ready() -> void:
	# GameManager References
	GameManager.p2 = $Player2
	GameManager.p1 = $Player1
	UIManager.can_update_health = true
	UIManager.can_pause = true
	GameManager.assign_bullets_to_players()
