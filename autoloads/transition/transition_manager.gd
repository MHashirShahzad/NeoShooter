extends CanvasLayer

signal transiton_finsihed
signal transition_fully_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_transition():
	if animation_player.is_playing():
		if animation_player.current_animation.contains("fade_out"):
			return
		else:
			await animation_player.animation_finished
			
	color_rect.show()
	animation_player.play(["fade_out1", "fade_out2"].pick_random())

func start_half_transition():
	animation_player.play("fade_in1")

func _on_animation_player_animation_finished(anim_name):
	if anim_name.contains("fade_out"):
		transiton_finsihed.emit()
		
		if anim_name.contains("1"):
			animation_player.play("fade_in1")
		else:
			animation_player.play("fade_in2")
			
	elif anim_name.contains("fade_in"):
		color_rect.hide()
		transition_fully_finished.emit()
		
func transition_scene_packed(scene : PackedScene) -> void:
	start_transition()
	await transiton_finsihed
	get_tree().change_scene_to_packed(scene)

func transition_scene_file(scene_path : String) -> void:
	start_transition()
	await transiton_finsihed
	get_tree().change_scene_to_file(scene_path)
