shader_type spatial;

void fragment() {
	vec2 uv = UV;//-vec2(cos(TIME*2. + index)*.02,sin(TIME*2. + index*3.)*.08);
	uv.y /= 2.;
	float d = abs(length(uv - .25) - .0);

	ALBEDO = max(vec3(.9, .3, .1)*1.7, .01/pow(d, 2.2)*vec3(.1,.9,.3));
	
	ROUGHNESS = 0.;
}
