// A Gaussian blur shader for Godot 4.3
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
// The radius of the blur effect (number of pixels to blur).
uniform int blur_radius : hint_range(1, 32) = 8;
// Controls the intensity of the blur.
uniform float blur_strength : hint_range(0.1, 10.0) = 1.0;

// Precomputed weights for the Gaussian kernel.
float gaussian_weight(float i, float sigma) {
    return exp(-0.5 * (i * i) / (sigma * sigma));
}

// Precomputes the weights for the Gaussian kernel.
void calculate_kernel(out float kernel[32], int radius, float sigma) {
    float sum = 0.0;
    for (int i = 0; i <= radius; i++) {
        kernel[i] = gaussian_weight(float(i), sigma);
        sum += i == 0 ? kernel[i] : 2.0 * kernel[i];
    }
    for (int i = 0; i <= radius; i++) {
        kernel[i] /= sum;
    }
}

void fragment() {
    vec2 resolution = SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV;

    // Gaussian kernel weights.
    float kernel[32];
    calculate_kernel(kernel, blur_radius, blur_strength);

    // Apply Gaussian blur in both directions (radial blur).
    vec3 final_color = vec3(0.0);
    float total_weight = 0.0;

    for (int x = -blur_radius; x <= blur_radius; x++) {
        for (int y = -blur_radius; y <= blur_radius; y++) {
            float weight = kernel[abs(x)] * kernel[abs(y)];
            vec2 offset = vec2(float(x), float(y)) * resolution;
            final_color += texture(SCREEN_TEXTURE, uv + offset).rgb * weight;
            total_weight += weight;
        }
    }

    // Normalize the color.
    final_color /= total_weight;

    // Output the blurred color.
    COLOR = vec4(final_color, 1.0);
}
