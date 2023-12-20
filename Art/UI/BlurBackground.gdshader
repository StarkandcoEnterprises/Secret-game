shader_type canvas_item;

uniform float blur_size = 1.0;
uniform vec2 viewport_size;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 pixel_size = vec2(1.0) / viewport_size;
    vec4 colour = vec4(0.0);
    int samples = 5;
    for (int x = -samples; x <= samples; x++) {
        for (int y = -samples; y <= samples; y++) {
            colour += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x), float(y)) * pixel_size * blur_size);
        }
    }
    colour /= float((samples * 2 + 1) * (samples * 2 + 1));
    COLOR = colour;
}