shader_type canvas_item;

void fragment() {
    COLOR = vec4(UV, 0.0, .5); // Display UV as RG, with blue as 0
}
