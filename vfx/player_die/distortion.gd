extends Sprite2D
class_name DistortionSprite


	
func set_shader_value(value: float):
	
	#material.set("shader_parameter/radius", value);
	material.set("shader_parameter/force", value);
	material.set("shader_parameter/size", value);
