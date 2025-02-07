class_name HoverShake2D
## BELONGS TO https://godotengine.org/asset-library/asset/850
var target

var _dist = Vector2(0, 15)

var starting_pos

var v_dir = 0
var h_dir = 0

var hover_speed = 10

var velocity = Vector2(0,0)
var max_velocity = Vector2(5,5)

func init(_target, starting_direction = "random", vertical_distance = 15, horizontal_distance = 0, speed = 10):
	_dist.x = horizontal_distance
	_dist.y = vertical_distance
	hover_speed = speed
	max_velocity.x = speed
	max_velocity.y = speed
	target = _target
	starting_pos = target.position
	if starting_direction == "random":
		var rand_dir = randf() * 10
		if _dist.x != 0 && _dist.y == 0:
			if rand_dir > 5:
				h_dir = 1
			else:
				h_dir = -1
		elif _dist.x == 0 && _dist.y != 0:
			if rand_dir > 5:
				v_dir = 1
			else:
				v_dir = -1
		elif _dist.x != 0 && _dist.y != 0:
			if rand_dir < 2.5:
				h_dir = 1
			elif rand_dir >= 2.5 && rand_dir < 5:
				v_dir = 1
			elif rand_dir >= 5 && rand_dir < 7.5:
				h_dir = -1
			elif rand_dir >= 7.5 && rand_dir < 10:
				v_dir = -1
	elif starting_direction == "right":
		h_dir = 1
	elif starting_direction == "left":
		h_dir = -1
	elif starting_direction == "up":
		v_dir = -1
	elif starting_direction == "down":
		v_dir = 1

func update(_delta):
	if _dist.y != 0:
		if v_dir == 1:
			velocity.y += (hover_speed * _delta)
			if velocity.y > max_velocity.y:
				velocity.y = max_velocity.y
			target.position.y += velocity.y
			if target.position.y >= starting_pos.y + _dist.y:
				v_dir = -1
				velocity.y *= .5
		elif v_dir == -1:
			velocity.y -= (hover_speed * _delta)
			if velocity.y < -max_velocity.y:
				velocity.y = -max_velocity.y
			target.position.y += velocity.y
			if target.position.y <= starting_pos.y - _dist.y:
				v_dir = 1
				velocity.y *= .5
	if _dist.x != 0:
		if h_dir == 1:
			velocity.x += (hover_speed * _delta)
			if velocity.x > max_velocity.x:
				velocity.x = max_velocity.x
			target.position.x += velocity.x
			if target.position.x >= starting_pos.x + _dist.x:
				h_dir = -1
				velocity.x *= .5
		elif h_dir == -1:
			velocity.x -= (hover_speed * _delta)
			if velocity.x < -max_velocity.x:
				velocity.x = -max_velocity.x
			target.position.x += velocity.x
			if target.position.x <= starting_pos.x - _dist.x:
				h_dir = 1
				velocity.x *= .5
