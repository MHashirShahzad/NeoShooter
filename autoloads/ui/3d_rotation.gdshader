shader_type canvas_item;

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