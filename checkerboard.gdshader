shader_type spatial;

void fragment() {
	// coordinates of point just in front of face, put "inside" a grid cube to prevent flickering
	vec3 world_coords = (inverse(WORLD_MATRIX) * (CAMERA_MATRIX * vec4(VERTEX + NORMAL * 0.1, 1.0))).xyz;
	
	// alternating odd/even pattern along each axis
	float chessboard = floor(world_coords.x) + floor(world_coords.y) + floor(world_coords.z);
	
	// choose light or dark square depending on whether point is inside or outside odd cube
	if (mod(chessboard, 2.0) < 1.0) {
		ALBEDO = vec3(224, 218, 254) / 255.0;
	} else {
		ALBEDO = vec3(248, 247, 255) / 255.0;
	}
}
