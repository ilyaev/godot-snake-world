shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float n = step(.2*cos(1.3),abs(sin(cos(1.9)+pow(abs(UV.x-.5)*UV.y-0.07,.4))));
	COLOR = vec4(.9/n,.3*n,.1,.4);
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
