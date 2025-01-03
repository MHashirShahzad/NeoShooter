extends Sprite2D
class_name DistortionSprite


	
func set_shader_value(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	material.set("shader_parameter/radius", value);
