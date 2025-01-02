extends Polygon2D
class_name PlayerBody

@export_group("Screw Shake")
@export var rand_str : float = 30
@export var fade_out : float = 5
@export var shard_count : int = 32



var rng = RandomNumberGenerator.new()
var shake_str : float = 0
var shard_velocity_map :={}
var is_player_dead : bool = false
func screw_state():
	shake_str = rand_str

func _physics_process(delta: float) -> void:
	if shake_str > 0:
		shake_str = lerpf(shake_str, 0, fade_out * delta)
		offset = rand_offset()
	
	if !is_player_dead:
		return
		
	for child in shard_velocity_map:
		child.position -= shard_velocity_map[child] * delta * 20
		child.rotation -= shard_velocity_map[child].x * delta * 0.1
		
		shard_velocity_map[child].x -= delta * 35

func rand_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str, shake_str), rng.randf_range(-shake_str, shake_str))

func shatter():
	self.show()
	#this will let us add more points to our polygon later on
	var points = polygon
	for i in range(shard_count):
		points.append(Vector2(randi()%128, randi()%128))
	
	
	var delaunay_points = Geometry2D.triangulate_delaunay(points)
	
	if not delaunay_points:
		print_debug("serious error occurred no delaunay points found")
	
	#loop over each returned triangle
	for index in len(delaunay_points) / 3:
		var shard_pool = PackedVector2Array()
		#find the center of our triangle
		var center = Vector2.ZERO
		
		# loop over the three points in our triangle
		for n in range(3):
			shard_pool.append(points[delaunay_points[(index * 3) + n]])
			center += points[delaunay_points[(index * 3) + n]]
			
		# adding all the points and dividing by the number of points gets the mean position
		center /= 3
		
		#create a new polygon to give these points to
		
		var shard = Polygon2D.new()
		shard.polygon = shard_pool
		
		#if rand_color:
			#shard.color = Color(randf(), randf(), randf(), 1)
		#else:
		shard.color = color
			
		shard_velocity_map[shard] = Vector2(64, 64) - center #position relative to center of sprite
			
			
		add_child(shard)
		
	#this will make our base sprite invisible
	color.a = 0
			
func reset() -> void:
	color.a = 1
	for child in get_children():
		remove_child(child)
