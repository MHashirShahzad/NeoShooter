extends Control

@onready var label: Label = $CanvasLayer/Label

func _process(delta: float) -> void:
	update_health()
	


func update_health():
	if not (GameManager.p1 or GameManager.p2):
		return
	var p1_health : float =  GameManager.p1.health
	var p2_health : float = GameManager.p2.health
	label.text = "P1: " + str(p1_health) + " P2: " + str(p2_health)
