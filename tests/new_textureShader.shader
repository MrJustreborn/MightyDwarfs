shader_type spatial;

uniform sampler2D tex: hint_albedo;
uniform vec4 shadow_color: hint_color;
uniform sampler2DArray types: hint_albedo;

void fragment() {
	vec3 final_color;
	float type = floor(COLOR.g * 255.0);
	
	final_color = texture(types, vec3(UV, 1.0)).rgb * (COLOR.r + (1.0-shadow_color.a));
	//final_color = texture(tex, UV).rgb * (COLOR.r + (1.0-shadow_color.a));
	
	//Add shadow
	final_color += shadow_color.rgb * (1.0 - COLOR.r) * shadow_color.a;
	
	ALBEDO = final_color;
}