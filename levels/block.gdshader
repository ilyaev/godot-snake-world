shader_type spatial;

instance uniform vec2 dimensions;
instance uniform vec2 pos;
uniform sampler2D noise;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453 + TIME*.02);
}

void fragment() {

	vec2 shift = vec2(0.);
	vec2 auv = fract(UV * vec2(3., 2.));
	vec2 suv = fract((auv + shift) * dimensions);
	vec2 sid = floor((auv + shift) * dimensions);

	vec2 uv = fract(auv * dimensions);
	vec2 id = floor(auv * dimensions);

	vec3 frame_color = vec3(.9, .3, .1);

	vec3 col = .6 * frame_color * (.2 + step(.6,texture(noise, UV*dimensions + pos*.3).r)*.3 + step(.3,texture(noise, UV*dimensions + pos*.3).r)*.2);


	float cell_size = 4.;
	vec2 cuv = fract((suv + vec2(0., 0.))*cell_size);
	vec2 cid = floor((suv + vec2(0., 0.))*cell_size);

	vec3 ccol = vec3(0.);
	vec3 border_color = frame_color*1.1;
	
	if (sid.x == 0.) {
		col = max(col, step(suv.x, .05)*border_color);
	}
	if (sid.y == 0.) {
		col = max(col, step(suv.y, .05)*border_color*1.2);
	}
	if (sid.x == dimensions.x-1.) {
		col = max(col, step(.95, suv.x)*border_color);
	}
	if (sid.y == dimensions.y-1.) {
		col = max(col, step(.95, suv.y)*border_color*1.2);
	}
	
	//float n = n21(cid+(sid*cell_size));
	//if (n > 1.7) {
		//ccol = frame_color*1.5;
		//if (n > .85) {
			//ccol = .5/length(cuv-.5) * ccol;
		//}
		//if (n > .9) {
			//ccol *= step(length(cuv-.5),.4);
		//} else {
			//ccol *= min(step(.1, cuv.x),step(.1, cuv.y));
		//}
	//}

	ALBEDO = max(col, ccol);

}
