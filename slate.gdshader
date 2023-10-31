shader_type spatial;

instance uniform vec3 color;

void fragment() {
	vec2 uv = UV;
	vec3 borderColor = vec3(.9, .3, .1);
	//float rd = .5;
	float p1 = .05;
	float p2 = 1.3;

	vec3 col = pow(p1/abs(uv.x - 1.), p2) * borderColor;
	col += pow(p1/abs(uv.x), p2) * borderColor;

	col += pow(p1/abs(uv.y - 1.), p2) * borderColor;
	col += pow(p1/abs(uv.y), p2) * borderColor;
	
	//if (rd > 0.) {
		//col += step(length(uv - .5), rd*.2) * col;
	//}
	//
	
	ALPHA = min(1., col.r + .3);
	col = max(color, col);
	ALBEDO = col;
}

