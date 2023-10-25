shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec3 color = vec3(.9, .3, .2);
	float d = length(abs(uv-.5));
	ALBEDO = 1.4/pow(d,2.2) * color;
	//ALPHA = 1. - step(ALBEDO.r,.00001);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
