shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

vec3 RGB_to_HSV(vec3 rgb) {
	float c_max = max(max(rgb.r,rgb.g),rgb.b);
	float c_min = min(min(rgb.r,rgb.g),rgb.b);
	float delta = c_max - c_min;
	float delta_inv = 1.0/delta;
	float h,s,v;
	h = 	mod((rgb.g-rgb.b) * delta_inv, 6.0) * float(c_max==rgb.r) + 
			((rgb.b-rgb.r) * delta_inv + 2.0) * float(c_max==rgb.g) + 
			((rgb.r-rgb.g) * delta_inv + 4.0) * float(c_max==rgb.b);
	h /= 6.0;
	s = 0.0;
	if(bool(c_max)){
		s = delta / c_max;
	}
	v = c_max;
	return vec3(h,s,v);
}

vec3 HSV_to_RGB(vec3 hsv){
	float c = hsv.y * hsv.z;
	float x = c * (1.0 - abs(mod(hsv.x * 6.0, 2.0) - 1.0));
	float m = hsv.z - c;
	vec3 v = vec3(m);
	
	int h_c = int(trunc(mod(hsv.x * 3.0 + 0.5, 3.0)));
	int h_x = int(trunc(mod(-hsv.x * 6.0 - 1.0, 3.0)));
	v[h_c] += c;
	v[h_x] += x;
	return v;
}

float quantize(float input, float steps, float steps_inv){
	input += steps_inv * 0.5;
	input *= steps;
	input = trunc(input);
	input *= steps_inv;
	//input -= steps_inv * 0.5;
	//input = mod(input,1.0);
	return input;
}

void vertex() {
	POSITION = vec4(VERTEX*2.0,1.0);
}

void fragment() {
	float funny_colon_three = abs(SCREEN_UV.x - 0.3) * abs(SCREEN_UV.x - 0.7) * 1.0;
	funny_colon_three -= 1.0;
	if (SCREEN_UV.y + funny_colon_three > 0.0){
		funny_colon_three = -(2.0*SCREEN_UV.y + funny_colon_three) ;
	}
	
	
	
	vec3 col = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x, SCREEN_UV.y + funny_colon_three)).rgb;
	vec3 hsv = RGB_to_HSV(col);
	
	float sat_high_bracket = float(hsv.y>0.9);
	float sat_low_bracket = float(hsv.z<0.05);
	
	float sat_steps = 0.0;
	sat_steps += sat_high_bracket*8.0;
	sat_steps -= sat_low_bracket*3.9;
	sat_steps = trunc(sat_steps);
	sat_steps += 4.0;
	hsv.y *= 1.0-(sat_low_bracket * (0.05 - hsv.z * 2.0) * 10.0);
	//hsv.z *= 1.0-(sat_high_bracket * (0.05 - hsv.z * 2.0) * 10.0);
	
	//hsv.z = min(hsv.z, 1.0);
	
	hsv.x = quantize(hsv.x, 16.0, 1.0/16.0);
	hsv.y = quantize(hsv.y, sat_steps, 1.0/sat_steps);
	hsv.z = quantize(hsv.z, 16.0, 1.0/16.0);
	hsv.z = max(0.01, hsv.z);
	col = HSV_to_RGB(hsv);
	ALBEDO = col;
	//ALBEDO = vec3(float(SCREEN_UV.y + funny_colon_three));
}


