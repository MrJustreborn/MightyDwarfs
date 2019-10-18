shader_type spatial;

uniform sampler2D tex: hint_albedo;
uniform sampler2D tex2: hint_albedo;
uniform sampler2DArray types: hint_albedo;

void fragment() {/*
	if (COLOR.r <= 0.5) {
		ALBEDO = texture(tex, UV).rgb;
	} else { */
		ALBEDO = texture(tex, UV).gbr * COLOR.r + texture(tex2, UV).rgb * (1.0 - COLOR.r);
	//}
}