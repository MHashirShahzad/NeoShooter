shader_type canvas_item;

uniform bool active = false;
uniform bool near_death = false;

void fragment() {
	vec4 previous_color = COLOR; // texture(TEXTURE, UV) for sprite
	vec4 red_tint = vec4(0.451, 0.09, 0.176, 1);

	// i wanna add bloom here
	vec4 white_color = vec4(1000.0, 1000.0, 1000.0, previous_color.a);
	vec4 new_color = previous_color;
	if (near_death == true){
		new_color = new_color + red_tint;
	}
	
	if (active == true)
	{
		new_color = white_color;
	}
	COLOR = new_color;
}