shader_type canvas_item;

uniform bool white_flash = false;
uniform bool red_flash = false;
uniform vec4 white_color : source_color;
uniform vec4 red_color : source_color;
void fragment() {
	vec4 previous_color = COLOR; // texture(TEXTURE, UV) for sprite

	vec4 new_color = previous_color;
	if (red_flash == true){
		new_color = red_color;
	}
	if (white_flash == true)
	{
		new_color = white_color;
	}
	COLOR = new_color;
}