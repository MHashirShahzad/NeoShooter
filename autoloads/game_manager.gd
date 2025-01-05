extends Node

var camera : SpaceShooterCamera
var p1 : Player2D
var p2 : Player2D

func player_dead(player : Player2D) -> void:
	var nodes = get_tree().get_nodes_in_group("Player")
	for node in nodes:
		if node is Player2D:
			if !node.is_dead:
				print(node.name)
