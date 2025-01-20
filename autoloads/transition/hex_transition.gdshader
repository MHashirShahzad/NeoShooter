/*
	六角形トランジション by あるる（きのもと 結衣）
	Hex Transition by Yui Kinomoto @arlez80

	MIT License
*/
shader_type canvas_item;

uniform sampler2D albedo_tex : hint_default_black;
uniform vec2 size = vec2( 64.0, 48.0 );
uniform float value : hint_range( 0.0, 1.0 ) = 1.0;

void fragment(){
	vec2 norm_size = size * SCREEN_PIXEL_SIZE;
	bool half = mod( SCREEN_UV.y / 2.0, norm_size.y ) / norm_size.y < 0.5;
	vec2 uv = SCREEN_UV + vec2( norm_size.x * 0.5 * float( half ), 0.0 );
	vec2 center_uv = floor( uv / norm_size ) * norm_size;
	vec2 norm_uv = mod( uv, norm_size ) / norm_size;
	center_uv += mix(
		vec2( 0.0, 0.0 )
	,	mix(
			mix(
				vec2( norm_size.x, -norm_size.y )
			,	vec2( 0.0, -norm_size.y )
			,	float( norm_uv.x < 0.5 )
			)
		,	mix(
				vec2( 0.0, -norm_size.y )
			,	vec2( -norm_size.x, -norm_size.y )
			,	float( norm_uv.x < 0.5 )
			)
		,	float( half )
		)
	,	float( norm_uv.y < 0.3333333 ) * float( norm_uv.y / 0.3333333 < ( abs( norm_uv.x - 0.5 ) * 2.0 ) )
	);

	float random_cell = abs( sin( length( center_uv ) * 153.4156 ) );
	COLOR = vec4( texture( albedo_tex, SCREEN_UV ).rgb, float( random_cell < value ) );
}
