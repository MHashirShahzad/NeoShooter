shader_type canvas_item;

uniform bool white_flash = false;
uniform bool red_flash = false;
uniform bool gold_flash = false;
uniform vec4 white_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 red_color : source_color = vec4(0.706, 0.125, 0.165, 1.0);
uniform vec4 gold_color : source_color = vec4(0.976, 0.639, 0.106, 1.0);
void fragment() {
	vec4 previous_color = COLOR; // texture(TEXTURE, UV) for sprite

	vec4 new_color = previous_color;

	if (white_flash == true){
		new_color = white_color;
	}

	else if (red_flash == true){
		new_color = red_color;
	}

	else if (gold_flash == true){
		new_color = gold_color;
	}
	COLOR = new_color;
}