shader_type spatial;

//render_mode unshaded, cull_disabled;

void fragment() {
	vec3 world_coords = (CAMERA_MATRIX * vec4(VERTEX + NORMAL * 0.001, 1.0)).xyz;
//	world_coords += vec3(0.001, 0.001, 0.001);
//	world_coords += NORMAL * 0.001;

	vec3 vis = vec3(248,247,255);
	vis /= 255.0;
	
	float chessboard = floor(world_coords.x) + floor(world_coords.y) + floor(world_coords.z);
	
	chessboard = mod(chessboard / 2.0, 1.0);
	
	if (chessboard < 0.01) {
		vis = vec3(224,218,254);
		vis /= 255.0;
	}
	
	ALBEDO = vis;
}
