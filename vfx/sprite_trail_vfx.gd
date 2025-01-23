extends Line2D

var queue : Array[Vector2]
@export var max_length : int

func _process(delta: float) -> void:
	queue.push_front(get_parent().position)
	
	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)
