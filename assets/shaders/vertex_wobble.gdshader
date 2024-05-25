// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,vertex_lighting,skip_vertex_transform;
uniform sampler2D texture_albedo : source_color,filter_nearest,repeat_enable; 
uniform sampler2D texture_normal : hint_roughness_normal,filter_nearest,repeat_enable;
uniform sampler2D texture_crunch : hint_default_black,filter_nearest,repeat_enable;
uniform vec4 albedo : source_color = vec4(1.0);
uniform float alpha_scissor_threshold = 0.5;
uniform float roughness : hint_range(0,1) = 1.0;
uniform float specular : hint_range(-10.0, 10.0) = 0.5;
uniform float metallic : hint_range(-10.0, 10.0) = 1.0;
uniform float normal_scale : hint_range(-16,16) = 2.0;
uniform float ao_light_affect = 0.5;

global uniform float wobble_resolution_inv;
global uniform float wobble_resolution;

void vertex() {
    vec3 transformed = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	// VVVV uncomment this line if you're cool VVVV
    //transformed = ( vec4(transformed, 10.0) * PROJECTION_MATRIX * MODELVIEW_MATRIX).xyz * (vec3(-1.0,1.0,1.0));   
	transformed *= wobble_resolution;
	transformed = trunc(transformed);
	transformed *= wobble_resolution_inv;
	VERTEX = transformed;
    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
}






void fragment() {
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	vec4 metallic_texture_channel = vec4(0.0,1.0,0.0,0.0);
	vec4 ao_texture_channel = vec4(0.0,0.0,1.0,0.0);
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 crunch_tex = texture(texture_crunch,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(crunch_tex,metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	float roughness_tex = dot(crunch_tex,roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	AO = dot(texture(texture_crunch,base_uv),ao_texture_channel);
	AO_LIGHT_AFFECT = ao_light_affect;
}
