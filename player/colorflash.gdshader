shader_type canvas_item;

uniform bool white_flash = false;
uniform bool red_flash = false;
uniform bool gold_flash = false;
group_uniforms ShaderParameters.FlashColors;
uniform vec4 white_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 red_color : source_color = vec4(0.706, 0.125, 0.165, 1.0);
uniform vec4 gold_color : source_color = vec4(0.976, 0.639, 0.106, 1.0);
group_uniforms;


group_uniforms ShaderParameters.DegreesRotation;
uniform float x_degrees: hint_range(-360, 360) = 0; // X IS FIXED
uniform float y_degrees: hint_range(-360, 360) = 0; // Y IS FIXED
uniform float z_degrees: hint_range(-360, 360) = 0; // Z IS FIXED
group_uniforms;

float degToRad(float angle) {
	return angle * PI / 180.0;
}

void vertex() {
	float radX = degToRad(x_degrees);
	float radY = degToRad(y_degrees);
	float radZ = degToRad(z_degrees);

	float cosX = cos(radX);
	float cosY = cos(radY);
	float cosZ = cos(radZ);

	float sinX = sin(radX);
	float sinY = sin(radY);
	float sinZ = sin(radZ);

	mat3 finalRot;
	finalRot[0][0] = cosZ * cosY;
	finalRot[1][0] = cosZ * sinY * sinX - sinZ * cosX;
	finalRot[2][0] = sinZ * sinX + cosZ * sinY * cosX;

	finalRot[0][1] = sinZ * cosY;
	finalRot[1][1] = cosZ * cosX + sinZ * sinY * sinX;
	finalRot[2][1] = sinZ * sinY * cosX - cosZ * sinX;

	finalRot[0][2] = -sinY;
	finalRot[1][2] = cosY * sinX;
	finalRot[2][2] = cosY * cosX;

	vec3 pos = vec3(VERTEX.xy, 0) * finalRot;
	VERTEX = pos.xy;
}
vec4 calculate_color_flash(vec4 prev_color) {
	vec4 new_color = prev_color;

	if (white_flash == true){
		new_color = white_color;
	}
	else if (red_flash == true){
		new_color = red_color;
	}

	else if (gold_flash == true){
		new_color = gold_color;
	}
	return new_color;
}

void fragment() {
	COLOR = calculate_color_flash(COLOR);
}