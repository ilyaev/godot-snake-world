shader_type spatial;

uniform sampler2D noise;
instance uniform bool reverse;
instance uniform float fill;
instance uniform float alpha;
instance uniform vec3 color;

void fragment() {
	//vec3 col = vec3(.3, .5, .9);
	vec3 col = color;
	vec2 uv = UV;
	float n = texture(noise, UV + vec2(0., TIME/2.)).r;
	float d = uv.x - (uv.y - (n*.1-.05));

	ALBEDO = (.02*alpha)/pow(abs(d), 1.) * col;

	ALPHA = smoothstep(.0, 1., max(ALBEDO.b, max(ALBEDO.r, ALBEDO.g)))*smoothstep(0.+fill*2., .3+fill*2., uv.x+uv.y);
}