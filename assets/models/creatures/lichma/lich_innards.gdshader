// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,vertex_lighting,skip_vertex_transform;
uniform int vertex_wobble_scale : hint_range(0, 2, 1) = 0;
uniform vec4 albedo : source_color = vec4(1.0);
uniform float alpha_hash_scale = 0.5;
uniform float fresnel_power = 3.0;
uniform sampler3D noise;

global uniform float wobble_resolution_inv_low;
global uniform float wobble_resolution_low;
global uniform float wobble_resolution_inv;
global uniform float wobble_resolution;
global uniform float wobble_resolution_inv_high;
global uniform float wobble_resolution_high;

varying vec3 _pos;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex() {
	float wobble, awobble;
	switch (vertex_wobble_scale){
		case 0:
			wobble = wobble_resolution_low;
			awobble = wobble_resolution_inv_low;
			break;
		case 1:
			wobble = wobble_resolution;
			awobble = wobble_resolution_inv;
			break;
		default:
			wobble = wobble_resolution_high;
			awobble = wobble_resolution_inv_high;
			break;
	}
	
	_pos = VERTEX;
	
    vec3 transformed = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	// VVVV uncomment this line if you're cool VVVV
    //transformed = ( vec4(transformed, 10.0) * PROJECTION_MATRIX * MODELVIEW_MATRIX).xyz * (vec3(-1.0,1.0,1.0));   
	transformed *= wobble;
	transformed = trunc(transformed);
	transformed *= awobble;
	VERTEX = transformed;
    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
}






void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo.rgb;
	EMISSION = ALBEDO;
	METALLIC = 0.0;
	ROUGHNESS = 0.2;
	SPECULAR = 0.0;
	ALPHA = 0.2;
	ALPHA += texture(noise,(_pos + TIME * 0.1) * 2.0).x;
	ALPHA_HASH_SCALE = alpha_hash_scale;
}
