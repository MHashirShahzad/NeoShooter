extends CanvasLayer

signal transiton_finsihed
signal transition_fully_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


func _ready():
	color_rect.hide()
	$"BG(test_only)".hide()

func start_transition():
	if animation_player.is_playing():
		# playing any of fade out animations
		if animation_player.current_animation.contains("fade_out"):
			return
		# playing fade in animation
		else:
			await animation_player.animation_finished
			
	color_rect.show()
	animation_player.play(["fade_out1", "fade_out2", "fade_out_saw", "fade_out_diagonal"].pick_random())

func start_half_transition():
	animation_player.play("fade_in1")

func _on_animation_player_animation_finished(anim_name : String):
	# if fade out finished
	if anim_name.contains("fade_out"):
		play_fade_in_animation(anim_name)
			
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

## DONT CALL PLAYS THE FADE IN ANIMATION FOR THE FADE OUT ANIMATION
func play_fade_in_animation(anim_name : String):
	transiton_finsihed.emit()	
	anim_name = anim_name.replace("fade_out", "fade_in")
	print_debug(anim_name)
	
	animation_player.play(anim_name)
	#match anim_name:
		#"1":
			#animation_player.play("fade_in1")
		#"2":
			#animation_player.play("fade_in2")
		#
		## except numbers will have an _ before them
		## i know bad code
		#"_pixel":
			#animation_player.play("fade_in_pixel")
		#"_hex":
			#animation_player.play("fade_in_hex")
		#"_saw":
			#animation_player.play("fade_in_saw")
