shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

void fragment() {
	vec2 uv = fract(UV * vec2(3.,2.) + vec2(TIME*.2, 0.5));
	
	vec3 col = vec3(.9, .3, .1);
	
	ALBEDO = .05/pow(abs(uv.x-.5), 1.3+abs(uv.y-.5)) * col;
	//ALBEDO = max(ALBEDO, .1/pow(abs(uv.y-.0), 1.) * col);
	//ALBEDO = max(vec3(.9,.3,.1), ALBEDO);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
