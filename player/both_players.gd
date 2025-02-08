extends Node2D

func _ready() -> void:
	# GameManager References
	GameManager.p2 = $Player2
	GameManager.p1 = $Player1
	
	GameManager.p1.hud = UIManager.player1_hud
	GameManager.p2.hud = UIManager.player2_hud
	
	# set health to 100 to initiate the set function
	# which updatees the UI
	GameManager.p1.health = 100
	GameManager.p2.health = 100
	# Ui manager stuff :C
	UIManager.can_pause = true
	UIManager.ui_layer.show()
	# UIManager.set_hud_positions()
	
	# loads the bullets from file and assigns them to players 
	GameManager.assign_bullets_to_players()
