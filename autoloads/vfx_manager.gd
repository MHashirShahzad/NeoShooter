extends Node2D

#const LAND_VFX = preload("res://vfx/land_vfx.tscn")
#const JUMP_VFX = preload("res://vfx/jump_vfx.tscn")

func spawn_vfx( parent : Node, vfx_scene : PackedScene):
	var vfx_inst : GPUParticles3D = vfx_scene.instantiate()
	vfx_inst.scale = Vector3(1,1,1) # set to 1 
	parent.add_child(vfx_inst)
	vfx_inst.emitting = true
	
	await vfx_inst.finished
	
	parent.remove_child(vfx_inst)
	vfx_inst.queue_free()
