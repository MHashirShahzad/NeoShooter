shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec4 col0 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-ps.x, 0));
	vec4 col1 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(ps.x, 0));
	vec4 col2 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0, -ps.y));
	vec4 col3 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0, ps.y));
	COLOR = 0.25 * (col0 + col1 + col2 + col3);
}