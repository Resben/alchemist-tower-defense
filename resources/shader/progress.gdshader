shader_type canvas_item;

uniform float value : hint_range(0, 100);
uniform float thickness : hint_range(0, 100) = 30;
uniform sampler2D fg : hint_default_white;
uniform sampler2D bg : hint_default_black;
uniform float offset : hint_range(0, 100);
uniform float smoothing : hint_range(0, 100) = 5;

void fragment() {
	vec2 point = UV - vec2(0.5);
	float ang = (1. - atan(point.x, point.y) / PI) * 50. - offset;
	if (ang < 0.)
		ang += 100.;
	
	// Smooth transition region size
	float s = smoothing / 1000.;
	float k = PI / 2. / s;

	// Circle radius definitions
	float r1 = .5 - thickness / 200.;
	float r2 = .5;
	float r = length(point);

	// Determine transparency based on distance from the circle edges
	float alpha = 1.0;
	if (r > r2 || r < r1) {
		alpha = 0.0;
	} else {
		if ((r2 - r) < s)
			alpha = sin((r2 - r) * k);
		if ((r - r1) < s)
			alpha = min(alpha, sin((r - r1) * k));
	}

	// Select texture based on angle and mask accordingly
	// For pixel art
	vec4 fg_color = textureLod(fg, UV, 0.0);
	vec4 bg_color = textureLod(bg, UV, 0.0);
	
	// Non pixel art
	//vec4 fg_color = texture(fg, UV);
	//vec4 bg_color = texture(bg, UV);
	if (ang <= value) 
		COLOR = mix(bg_color, fg_color, alpha);
	else
		COLOR = bg_color * alpha;
}
