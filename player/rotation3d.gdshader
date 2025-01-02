shader_type canvas_item;

uniform float rotation_angle : hint_range(-180.0, 180.0);

void fragment() {
    float angle = radians(rotation_angle);
    float perspective = abs(cos(angle));
    vec2 new_uv = UV;

    // Skew effect for 3D-like illusion
    new_uv.x += sin(angle) * (UV.y - 0.5);

    // Apply new UV and perspective scaling
    vec4 tex = texture(TEXTURE, new_uv);
    tex.rgb *= perspective; // Dim the color slightly for depth effect
    COLOR = tex;
}
