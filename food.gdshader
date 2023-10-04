shader_type spatial;

void fragment() {
	vec2 uv = fract(UV * vec2(3.,2.));

	vec3 borderColor = vec3(.9, .3, .1);
	vec3 borderColorBlue = vec3(.1, .3, .9);
	
	float p1 = .05;
	float p2 = 1.3;

	vec3 col = pow(p1/abs(uv.x - .99), p2) * borderColor;
	col += pow(p1/abs(uv.x - .01), p2) * borderColor;

	col += pow(p1/abs(uv.y - .99), p2) * borderColor;
	col += pow(p1/abs(uv.y - .01), p2) * borderColor;
	
	ALBEDO = col;
	ALPHA = min(1., col.r + .1);
}
