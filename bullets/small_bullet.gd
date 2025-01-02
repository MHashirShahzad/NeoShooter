extends Bullet2D
class_name SmallBullet2D

var time : float = 0

func _process(delta: float) -> void:
	time += delta
	direction.y = get_cosine()
	
## frequency and amplitude
func get_cosine(freq: float = 10, amp : float = 1) -> float:
	return cos(time * freq) * amp 

# for time = 0 sine starts at highest point while cosine starts at center so gives us
# an overall better thing
#func get_esine(freq : float = 10, amp : float = 1) -> float:
	#return sin(time * freq) * amp 
