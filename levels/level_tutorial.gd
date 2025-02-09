extends Node2D



func _ready() -> void:
	assign_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func assign_player() -> void:
	# GameManager References
	GameManager.p1 = $Player1
	
	GameManager.p1.hud = UIManager.player1_hud
	
	# set health to 100 to initiate the set function
	# which updatees the UI
	GameManager.p1.health = 100
	# Ui manager stuff :C
	UIManager.can_pause = true
	UIManager.ui_layer.show()
	UIManager.player2_hud.hide()
	# UIManager.set_hud_positions()
	
	# loads the bullets from file and assigns them to players 
	GameManager.assign_bullets_to_players()
