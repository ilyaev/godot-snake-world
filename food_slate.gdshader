shader_type spatial;

instance uniform vec3 color;

void fragment() {
	ALBEDO = color;
}
