shader_type canvas_item;

uniform vec4 top_left : source_color;
uniform vec4 top_right : source_color;
uniform vec4 bottom_left : source_color;
uniform vec4 bottom_right : source_color;

uniform float border_hori_threshold = 0.01;
uniform float border_vert_threshold = 0.02;

void fragment() {
	// Figure out our relation to the border
	float left_border = UV.x;
	float right_border = 1.0 - UV.x;
	float bottom_border = UV.y;
	float top_border = 1.0 - UV.y;
	
	// Let's check if the current position is on a border
	bool is_left_border = left_border < border_hori_threshold;
	bool is_right_border = right_border < border_hori_threshold;
	bool is_bottom_border = bottom_border < border_vert_threshold;
	bool is_top_border = top_border < border_vert_threshold;
	
	// Default colour
	vec4 border_colour = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 colour;
	
	// Check for borders
	if (is_left_border || is_right_border || is_bottom_border || is_top_border) {
		// Fill in borders
		colour = border_colour;
		
	} else {
		// Regular gradient blending
		vec4 top = mix(top_left, top_right, UV.x);
		vec4 bottom = mix(bottom_left, bottom_right, UV.x);
		colour = mix(top, bottom, UV.y);
		
	}
	COLOR = colour;
	
}