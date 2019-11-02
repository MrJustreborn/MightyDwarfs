shader_type spatial;

uniform sampler2D tex: hint_albedo;
uniform vec4 shadow_color: hint_color;
uniform sampler2DArray types: hint_albedo;
uniform sampler2DArray destruction: hint_albedo;

uniform sampler2D noise: hint_albedo;

void fragment() {
	vec3 final_color;
	float type = floor(COLOR.g * 255.0);
	
	final_color = texture(types, vec3(UV, type)).rgb * (COLOR.r + (1.0-shadow_color.a));
	//final_color = texture(tex, UV).rgb * (COLOR.r + (1.0-shadow_color.a));
	
	//Add destruction
	float dest = floor(COLOR.b * 255.0);
	float amt = texture(destruction, vec3(UV, dest)).a;
	final_color = texture(destruction, vec3(UV, dest)).rgb * amt + final_color * (1.0 - amt);
	
	//Add shadow
	final_color += shadow_color.rgb * (1.0 - COLOR.r) * shadow_color.a;
	
	ALBEDO = final_color;
	
	//ALBEDO = texture(tex, UV * vec2(5.0) * vec2(sin(TIME), cos(TIME))).rgb;
}