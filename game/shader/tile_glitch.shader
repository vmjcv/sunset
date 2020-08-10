shader_type canvas_item;
render_mode blend_mix;
uniform sampler2D my_texture : hint_albedo;
void fragment()
{
	vec2 block = floor(FRAGCOORD.xy /vec2(16));
	vec2 uv_noise = block / vec2(64);
	float time = TIME*abs(sin(TIME));
	uv_noise += floor(vec2(time) * vec2(1234.0, 3543.0)) / vec2(64) ;
	float block_thresh = pow(fract(time * 1236.0453), 2.0) * 0.2;
	float line_thresh = pow(fract(time * 2236.0453), 3.0) * 0.8;
	
	vec2 uv_r = UV, uv_g = UV, uv_b = UV;

	// glitch some blocks and lines
	if (texture(my_texture, uv_noise).r < block_thresh ||
		texture(my_texture, vec2(uv_noise.y, 0.0)).g < line_thresh) {

		vec2 dist = (fract(uv_noise) - 0.5) * 0.3;
		uv_r += dist * 0.1;
		uv_g += dist * 0.2;
		uv_b += dist * 0.125;
	}
	COLOR.r = texture(TEXTURE, uv_r).r;
	COLOR.g = texture(TEXTURE, uv_g).g;
	COLOR.b = texture(TEXTURE, uv_b).b;
	COLOR.a = (texture(TEXTURE, uv_r).a+texture(TEXTURE, uv_g).a+texture(TEXTURE, uv_b).a)/3.0;

	// loose luma for some blocks
	if (texture(my_texture, uv_noise).g < block_thresh)
		COLOR.rgb = COLOR.ggg;

	// discolor block lines
	if (texture(my_texture, vec2(uv_noise.y,0.0)).b * 3.5 < line_thresh)
		COLOR.rgb = vec3(0.0, dot(COLOR.rgb, vec3(1.0)), 0.0);

	// interleave lines in some blocks
	if (texture(my_texture, uv_noise).g * 1.5 < block_thresh ||
		texture(my_texture, vec2(uv_noise.y,0.0)).g * 2.5 < line_thresh) {
		float line = fract(FRAGCOORD.y/3.0);
		vec3 mask = vec3(3.0, 0.0, 0.0);
		if (line < 0.333){
			mask = vec3(0.0, 3.0, 0.0);
		}
		if (line > 0.666){
			mask = vec3(0.0, 0.0, 3.0);
		}
		
		COLOR.xyz *= mask;
	}

}