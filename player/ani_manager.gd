extends Node
class_name PlayerAnimationManager

func shoot_ani() -> void:
	$Shoot.play("shoot")
	
func low_ammo_ani() -> void:
	$AmmoFlash.play("ammo_flash")
	
func ammo_refilled_ani() -> void:
	$AmmoRefill.play("ammo_refill")
	
func hit_ani() -> void:
	$Hit.play("hit_flash")
