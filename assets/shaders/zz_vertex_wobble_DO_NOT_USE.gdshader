shader_type spatial;

global uniform float wobble_resolution;
global uniform float wobble_resolution_inv;
void vertex() {
	vec3 transformed = (MODELVIEW_MATRIX * vec4(VERTEX, 0.0)).xyz;
	transformed *= wobble_resolution;
	transformed = trunc(transformed);
	transformed *= wobble_resolution_inv;
	VERTEX = (vec4(transformed, 0.0) * MODELVIEW_MATRIX).xyz;
}
