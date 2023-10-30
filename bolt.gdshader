shader_type spatial;

uniform sampler2D noise;
instance uniform bool reverse;
instance uniform float fill;
instance uniform float alpha;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 col = vec3(.3, .5, .9);
	vec2 uv = UV;
	float n = texture(noise, UV + vec2(0., TIME/2.)).r;
	//if (reverse) {
		//uv.x = 1.-uv.x;
	//}
	float d = uv.x - (uv.y - (n*.1-.05));

	ALBEDO = step(abs(d), .01) * col;
	ALBEDO = (.02*alpha)/pow(abs(d), 1.) * col;
	if (reverse) {
		ALPHA = smoothstep(.0, 1., ALBEDO.r)*(1. - smoothstep(0.+fill*2., .3+fill*2., uv.x+uv.y));	
	} else {
		ALPHA = smoothstep(.0, 1., ALBEDO.r)*smoothstep(0.+fill*2., .3+fill*2., uv.x+uv.y);
	}
	
}

void light() {
	// Called for every pixel for every light affecting the material.
}
