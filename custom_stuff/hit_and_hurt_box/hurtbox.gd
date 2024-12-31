class_name HurtBox
extends Area2D

@export var hurtbox_owner : CharacterBody2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 32
	
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.owner = hurtbox_owner
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
		
	if owner == hitbox.to_ignore:
		return
	
	
	if owner.has_method("on_hit"):
		owner.on_hit(hitbox.damage)
		HitEffectManager.hit_stop(hitbox.hit_stop)
		HitEffectManager.camera_shake(hitbox.cam_shake_str)
		 
	if owner.has_method("screw_state"):
		owner.screw_state(hitbox.screw_state)
		
	if owner.has_method("recieve_knockback"):
		
		# only in x direction
		# var kb_dir : Vector3 = hitbox.to_ignore.facing
		
		# gets direction from that
		var kb_dir = hitbox.global_position.direction_to(self.global_position)
		
		# if player is to be launched at a -ve y velocity launch at a slight angle
		if kb_dir.y <= 0:
			kb_dir.y = .1
			
		owner.recieve_knockback(kb_dir, hitbox.kb_strength)
		
	if hitbox.has_method("destroy"):
		print_debug("DESTROY BULLET")
		hitbox.destroy()
		
