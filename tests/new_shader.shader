shader_type spatial;

uniform bool enable;
uniform bool enable_fog;
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
	if (enable) {
		float amt = getAmount(COLOR.r);
		ALPHA = (1.0 - amt) * color.a;
		if (amt >= 0.4 && COLOR.a < 0.5 && enable_fog) {
				float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	
				depth = depth * 2.0 - 1.0;
				depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
				depth = depth + VERTEX.z;
				depth *= 0.1;
				
				ALBEDO = vec3(depth);
				ALPHA = 0.75;
			
				if (SCREEN_UV.x > 0.2 && SCREEN_UV.x < 0.5) {
					if (SCREEN_UV.y > 0.2 && SCREEN_UV.y < 0.25) {
						//ALPHA = 0.0;
						//ALBEDO = vec3(.1,.1,.1);
					}
				}
		}
	}
	else {
		ALPHA = 0.0;
	}
}

