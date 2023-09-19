shader_type sky;

void sky() {
	vec2 uv = fract(abs(SCREEN_UV - POSITION.xy/(PI*10.)) * 10.);
	COLOR = max(step(uv.x, .01) * vec3(1.), step(uv.y, .05) * vec3(1.));
	COLOR = vec3(0.2, 0.6, 1.0);

}
