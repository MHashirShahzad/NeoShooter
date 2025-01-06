extends Node 

var camera : SpaceShooterCamera
var p1 : Player2D
var p2 : Player2D


func match_end():
	# disable all input 
	p1.is_input_enabled = false
	p2.is_input_enabled = false
	# we need a transition so that player cant see if bullets are dead
	BulletManager.destroy_all_bullets()
