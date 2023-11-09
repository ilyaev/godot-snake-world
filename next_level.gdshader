shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	float d = pow(.05/(uv.x), .9);
	d = max(d, pow(.06/(1.-uv.x), .9));
	d = max(d, pow(.1/uv.y, .9));
	d = max(d, pow(.1/(1.-uv.y), .9));
	vec3 col = d/2.*vec3(.9, .3, .1);
	COLOR = vec4(col, max(.6, d));
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
