shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

vec3 draw_background(vec2 cuv, float T, float cells) {
	vec2 speed = vec2(T*.05, T*.001) * -1.;
	speed /= cells / 80.;
	vec2 uv = fract((cuv - speed) * cells);
	vec2 id = floor((cuv - speed) * cells);
	
	float n = n21(id + cells);
	
	float d = length(uv - .5 + vec2(fract(n*12.22)*.8 - .4, fract(n*1222.3322)*.8 - .4));
	
	if (n < .97) {
		return vec3(0.);
	}
	
	float size = .05 + 0.05*fract(n*32.332) - .0025;
	
	return vec3(1.) * smoothstep(.1, 1., (size/2.)/pow(d, 1.2));
}

void fragment() {
	ROUGHNESS = 0.;
	ALBEDO = draw_background(UV, TIME, 80.*2.) + draw_background(UV, TIME, 160.*2.) + draw_background(UV, TIME, 180.*2.);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
