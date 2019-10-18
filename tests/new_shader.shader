shader_type spatial;

uniform bool enable;
uniform bool enable_fog;
uniform vec4 color: hint_color;
uniform vec4 color_fog: hint_color;
uniform float base_fog_alpha: hint_range(0.0, 1.0) = 0.75;

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
		if (COLOR.a > 0.0 && enable_fog) {
				float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	
				depth = depth * 2.0 - 1.0;
				depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
				depth = depth + VERTEX.z;
				depth *= 0.1;
				
				vec3 fog = color_fog.rgb * depth;
				
				ALBEDO = (1.0 - amt) * color.rgb + (amt) * fog;
				if (base_fog_alpha * COLOR.a > (1.0 - amt) * color.a) {
					ALPHA = base_fog_alpha * COLOR.a * color_fog.a;
				}
			
			/*
				if (SCREEN_UV.x > 0.2 && SCREEN_UV.x < 0.5) {
					if (SCREEN_UV.y > 0.2 && SCREEN_UV.y < 0.25) {
						//ALPHA = 0.0;
						//ALBEDO = vec3(.1,.1,.1);
					}
				}*/
		}
	}
	else {
		ALPHA = 0.0;
	}
}

