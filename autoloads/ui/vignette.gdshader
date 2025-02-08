shader_type canvas_item;

uniform float inner_radius : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float outer_radius : hint_range(0.0, 1.0, 0.01) = 1;
uniform float vignette_strength : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float dither_strength : hint_range(0.0, 1.0, 0.01) = 0.03;
uniform vec4 vignette_color: source_color;


void fragment() {
	float dist = distance(UV, vec2(0.5));

	float vignette = smoothstep(inner_radius, outer_radius, dist) * vignette_strength;
	float dither = fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453123) * dither_strength;

	COLOR = vec4(vignette_color.rgb, vignette + dither);
}