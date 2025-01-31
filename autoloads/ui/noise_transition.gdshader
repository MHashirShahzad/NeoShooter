shader_type canvas_item;
// doesntr wrok

uniform sampler2D noiseTexture : source_color;
uniform sampler2D screenFadeTexture : source_color;
uniform float fadeRange : hint_range(0, 1) = 0.5;
uniform vec4 color : source_color;

void fragment(){
	float adjustedFade = (fadeRange * 2.0 - 1.0) * 0.25;

	float noiseValue = (1.0 - (texture(noiseTexture, UV).r * texture(screenFadeTexture, SCREEN_UV).r )) - adjustedFade;
	// ALPHA = round(noiseValue);

	noiseValue = 1.0 - (noiseValue - 0.02);
	// EMISSION = round(noiseValue) * color.rgb;
}