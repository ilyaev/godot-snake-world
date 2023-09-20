shader_type spatial;

void fragment() {
	vec2 uv = UV-vec2(cos(TIME*2.)*.02,sin(TIME*2.)*.08);
	uv.y /= 2.;
//eyes	
	float d = abs(length(uv-.15) - .03);
	float d1 = abs(length(uv-vec2(.15, .35)) - .03);

	ALBEDO = max(vec3(.9, .3, .1)*1.7, .01/pow(d, 1.2)*vec3(.1,.9,.3));
	ALBEDO = max(ALBEDO,  .01/pow(d1, 1.2) * vec3(.1, .9, .9));
	
	ROUGHNESS = 0.;

//nose
//	float d3 = abs(length(uv-.22));
//	float d4 = abs(length(uv-vec2(.22, .274)));	
//	ALBEDO = max(ALBEDO, step(d3, .02));
//	ALBEDO = max(ALBEDO, step(d4, .02));
}
