extends Node2D

func _ready() -> void:
	# GameManager References
	GameManager.p2 = $Player2
	GameManager.p1 = $Player1
	
	# Ui manager stuff :C
	UIManager.can_update_health = true
	UIManager.can_pause = true
	UIManager.ui_layer.show()
	UIManager.update_health()
	
	# loads the bullets from file and assigns them to players 
	GameManager.assign_bullets_to_players()
