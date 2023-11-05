shader_type spatial;

uniform sampler2D level : filter_nearest;
uniform sampler2D noise;
uniform float disolve;
instance uniform vec2 dimensions;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

vec3 draw_background(vec2 cuv, float T, float cells) {
	vec2 speed = vec2(T*.05, T*.001) * -1.;
	speed /= cells / 80.;
	vec2 uv = fract((cuv - speed) * cells);
	vec2 id = floor((cuv - speed) * cells);
	
	float n = n21(id + cells);
	
	float d = length(uv - .5 + vec2(fract(n*12.22)*.4 - .2, fract(n*1222.3322)*.4 - .2));
	
	if (n < .97) {
		return vec3(0.);
	}
	
	float size = .05 + 0.05*fract(n*32.332) - .0025;
	
	return vec3(1.) * smoothstep(.1, 1., (size/2.)/pow(d, 1.2));
}

void fragment() {
	vec2 size = dimensions;
	
	vec2 uv = fract(UV*size);
	vec2 id = floor(UV*size);
	
	float n = texture(level, UV).r;
	
	float line = .07;
	
//	float border = max(.05/pow(abs(uv.x-.5), 1.2), .05/pow(abs(uv.y-.5), 1.2));
//	border = step(border, 4.);

	float border = 1. - max(step(uv.x, line), step(uv.y, line));
	

	
	if (n > 0.1) {
		border = 0.;	
	}
	
	ALBEDO = vec3(.9, .3, .1)*border*.2;
	
	float plasma_scale = TIME * .3;
	
	vec2 duv = UV;
	if (dimensions.x > dimensions.y) {
		duv.y /= dimensions.x / dimensions.y;
	} else {
		duv.x /= dimensions.y / dimensions.x;
	}
	
	vec3 t = texture(noise, duv/2. + vec2(TIME * -0.01, sin(TIME)*.01)).rgb;
	vec3 p = max(step(.4+sin(plasma_scale)*.1, t)*.1, step(.6+cos(plasma_scale)*.1, t)*.2);
	p = max(p, step(8.+cos(plasma_scale+sin(plasma_scale))*.1, t)*.3);
	ALBEDO -= mix(vec3(0.), ALBEDO, p.r)*3.;
	ALBEDO -= t*.025;
	
	if (disolve > 0.) {
		ALBEDO = step(disolve,texture(noise, duv*2.).rgb) * ALBEDO;
	}

	if (ALBEDO.r == 0. || border == 0.) {
		ALBEDO = draw_background(duv, TIME, 80) + draw_background(duv, TIME, 160) + draw_background(duv, TIME, 180);
	} else {
		ROUGHNESS = ALBEDO.r;
	}
	
}
