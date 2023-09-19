shader_type spatial;

void fragment() {
	// Place fragment code here.
	vec2 uv = fract(UV*7.1);
	
	float line = .05;
	
	float border = max(.05/pow(abs(uv.x-.5), 1.2), .05/pow(abs(uv.y-.5), 1.2));
	border = step(border, 4.);
	ALBEDO = vec3(.9, .3, .1)*border*.2;
}
