shader_type spatial;

uniform float amount = .025;
uniform float speed = 5.0;

void vertex() {
	float x = VERTEX.x + amount * sin(VERTEX.z * (UV.x + 1.0) * TIME * speed);
	float z = VERTEX.z + amount * cos(VERTEX.x * (UV.y + 1.0) * TIME * speed);
	VERTEX = vec3(x, VERTEX.y, z);
}

void fragment() {
	ALBEDO = vec3(0.0, .5, 0.0);
	ALPHA = 0.5;
}