shader_type spatial;

uniform sampler2D tex;

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
	vec3 texColor = texture(tex, UV).rgb;
	vec3 texColor2 = vec3(0.0);
	
	vec3 finalColor = ((texColor * getAmount(COLOR.r) + texColor2 * (1.0 - getAmount(COLOR.r)))) / 2.0;
	
	ALBEDO.rgb = finalColor;
}
