shader_type spatial;

instance uniform vec2 dimensions;
uniform sampler2D noise;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453 + TIME*.1);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 shift = vec2(TIME*.1, 0.);//sin(TIME+cos(TIME*10.)*.1)*.1);
	vec2 auv = fract(UV * vec2(3., 2.));
	vec2 suv = fract((auv + shift) * dimensions);
	vec2 sid = floor((auv + shift) * dimensions);

	vec2 uv = fract(auv * dimensions);
	vec2 id = floor(auv * dimensions);

	vec3 col = vec3(0.);
	vec3 frame_color = vec3(.9, .02, .02);

	float mag = .1;

	if (id.x == 0.) {
		col = max(col, frame_color * mag/abs(uv.x-.1 + sin(TIME+SCREEN_UV.y*10.)*.1));
	}
	if (id.x == (dimensions.x - 1.) || dimensions.x == 1.) {
		col = max(col, frame_color * mag/abs(.9 - uv.x  + cos(TIME+SCREEN_UV.y*10.)*.1));
	}

	if (id.y == 0.) {
		col = max(col, frame_color * mag/abs(uv.y - .1 + sin(TIME+SCREEN_UV.x*10.)*.1));
	}
	if (id.y == (dimensions.y - 1.) || dimensions.y == 1.) {
		col = max(col, frame_color * mag/abs(.9 - uv.y  + sin(TIME+SCREEN_UV.x*10.)*.1));
	}

	float cell_size = 4.;
	vec2 cuv = fract((suv + vec2(0., 0.))*cell_size);
	vec2 cid = floor((suv + vec2(0., 0.))*cell_size);

	vec3 ccol = vec3(0.);
	//ccol = min(step(.1, cuv.x), step(.1, cuv.y)) * frame_color;
	float n = n21(cid+(sid*cell_size));
	if (n > .7) {
		ccol = vec3(.1, .9, .2);
		if (n > .85) {
			ccol = .5/length(cuv-.5) * vec3(.1,.9,.1);
			//ccol = max(ccol, .2/abs(cuv.x-.5)) * vec3(.1, .9, .1);
			//ccol = max(ccol, .2/abs(cuv.y-.5)) * vec3(.1, .9, .1);
		}
		ccol *= step(length(cuv-.5),.4);
	}

	ALBEDO = max(col, ccol);

}

void light() {
	// Called for every pixel for every light affecting the material.
}
