shader_type spatial;

//uniform sampler2D image : source_color;

//varying vec3 vertex_position;

instance uniform float index;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

//void vertex() {
	//vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	////VERTEX = VERTEX + NORMAL * (texture(image, vec2(index, VERTEX.x + TIME/12.)).r * .2) - .1;
	////VERTEX. = 0.;
//}

void fragment() {
	vec2 uv = UV;//-vec2(cos(TIME*2. + index)*.02,sin(TIME*2. + index*3.)*.08);
	uv.y /= 2.;
//eyes	
	float d = abs(length(uv - .25) - .0);

	ALBEDO = max(vec3(.9, .3, .1)*1.7, (.001 + sin(index/2. + PI*1.4) * 0.001)/pow(d, 2.2)*vec3(.1,.9,.3));
	
	ROUGHNESS = 1.;
}
