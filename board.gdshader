shader_type spatial;
//render_mode unshaded;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

vec3 draw_background(vec2 cuv, float T, float cells) {
	vec2 speed = vec2(T*.05, T*.001) * -1.;
	speed /= cells / 80.;
	vec2 uv = fract((cuv - speed) * cells);
	vec2 id = floor((cuv - speed) * cells);
	
	float n = n21(id + cells*100.);
	
	float d = length(uv - .5 + vec2(fract(n*12.22)*.8 - .4, fract(n*1222.3322)*.8 - .4));
	
	if (n < .97) {
		return vec3(0.);
	}
	
	float size = .05 + 0.05*fract(n*32.332) - .0025;
	
	return vec3(1.) * smoothstep(.1, 1., (size/2.)/pow(d, 1.2));
}

void fragment() {
	float size = 17.1;
	
	vec2 uv = fract(UV*size);
	vec2 id = floor(UV*size);
	
	float n = n21(id+10.);
	
	float line = .07;
	
//	float border = max(.05/pow(abs(uv.x-.5), 1.2), .05/pow(abs(uv.y-.5), 1.2));
//	border = step(border, 4.);

	float border = 1. - max(step(uv.x-(line - 0.07), line), step(uv.y+(line - 0.07), line));
	

	
	if (n > .8) {
		border = 0.;	
	}
	
	ALBEDO = vec3(.9, .3, .1)*border*.2;
	
	if (border == 0.) {
		ROUGHNESS = 0.;
		ALBEDO = draw_background(UV, TIME, 80) + draw_background(UV, TIME, 160) + draw_background(UV, TIME, 180);
	}
	
//	vec2 suv = fract((UV - vec2(.5,0))*vec2(17.1, 1.));
//	vec2 sid = floor((UV - vec2(.5,0))*vec2(17.1, 1.));
//
//	float tn = n21(vec2(floor(TIME), sid.x));
//
//	float slider = .05/pow(abs(suv.x-.5), .9) * sin(suv.y*9. + TIME*4. + (tn - .5)*20.);
//
//
//
//	if (ALBEDO.r == 0. && tn > .9) {
//		ALBEDO = slider * vec3(.9, .3, .1);
//	}
		
	
}
