shader_type spatial;

void fragment() {
	// Place fragment code here.
	vec2 uv = fract(UV * vec2(30., 20.) -.5);
	ALBEDO = vec3(.9, .3, .1) * min(step(.2, uv.x), step(.2, uv.y));
}
