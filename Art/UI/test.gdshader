shader_type canvas_item;

uniform vec4 line_colour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float line_spacing = 64.0;
uniform float line_width = 1.0;

void fragment() {
    vec2 pixel_position = FRAGCOORD.xy;
    vec2 grid_position = mod(pixel_position, line_spacing);
    if (grid_position.x < line_width || grid_position.y < line_width) {
        COLOR = line_colour;
    }
}