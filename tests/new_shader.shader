shader_type spatial;

uniform bool enable;
uniform vec4 color: hint_color;

float getAmount(float input) {
	float low = 0.25;
	float high = 0.4;
	if (input < low)
		return 0.0;
	else if (input > high)
		return 1.0;
	
	float y = (input - low) / (high - low) * (1.0 - 0.0) + 0.0;
	return y;
}

void fragment() {
	ALBEDO.rgb = color.rgb;
	if (enable)
		ALPHA = (1.0 - getAmount(COLOR.r)) * color.a;
	else
		ALPHA = 0.0;
}
