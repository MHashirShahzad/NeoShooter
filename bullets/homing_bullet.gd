extends Bullet2D
class_name HomingBullet2D

@export var inertia : float = 1
@export var rotation_speed : float = 10
@export var homing_duration : float = .5

# var default_direction : Vector2
var target_player : Player2D

func _ready() -> void:
	if hit_box.to_ignore == GameManager.p1:
		target_player = GameManager.p2
	else:
		target_player = GameManager.p1
		
	#await direction_changed
	#default_direction = direction
	#print(default_direction)
	
	var tween :Tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	# 1 to 0
	tween.tween_property(self, "inertia", 0, 1).set_ease(Tween.EASE_OUT)
	
	# 0 to 1
	tween.tween_property(self, "inertia", 1, homing_duration).set_ease(Tween.EASE_IN).set_delay(1)
	
	# yelow to white
	tween.tween_property($Top, "color", Color(1, 1, 1), homing_duration).set_ease(Tween.EASE_IN).set_delay(1)
	tween.tween_property($Bottom
	, "color", Color(1, 1, 1), homing_duration).set_ease(Tween.EASE_IN).set_delay(1)
	
	await tween.finished
	tween.kill
	
func _process(delta: float) -> void:
	rotation += delta * rotation_speed
	
	if !target_player:
		return
		
	#var dist_to_player : float = self.global_position.distance_to(target_player.global_position)
	#print(dist_to_player)
	
	
	#if dist_to_player > 300:
		#return
	
	# if inertia 0 chases target_pos other wise current dir
	direction = lerp(self.global_position.direction_to(target_player.global_position), direction, inertia)
	# self.look_at(target_player.global_position)

func _on_homing_area_body_entered(body: Node2D) -> void:
	# default_direction = direction
	
	if !body is Player2D:
		return
	
	if body == hit_box.to_ignore:
		return
		
	target_player = body
	direction = lerp(self.global_position.direction_to(body.global_position), direction, inertia)
	
func _on_homing_area_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null
		# direction = default_direction
