shader_type canvas_item;

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float time = cos(TIME);
	COLOR.rgb = mix(c, vec3(time, time * 0.2, time * 0.1), 0.4);
}