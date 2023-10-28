shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV+vec2(sin(TIME*10.)*.2, cos(TIME*10.)*.2);
	vec3 color = vec3(.9, .3, .2);
	float d = length(abs(uv-.5));
	ALBEDO = 1.2/pow(d,1.8) * color;
	ALPHA = step(d, .3);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
