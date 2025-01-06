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
	color_rect.show()
	animation_player.play("fade_out1")

func start_half_transition():
	animation_player.play("fade_in1")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out1":
		transiton_finsihed.emit()
		animation_player.play("fade_in1")
	elif anim_name == "fade_in1":
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
