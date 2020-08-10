shader_type canvas_item;
render_mode blend_mix;
void fragment()
{
	vec2 uv = UV - 0.5;
	COLOR=texture(TEXTURE,vec2(uv.x,uv.y/clamp(abs(sin(TIME)), 0.3, 1))+0.5);
	COLOR.a*=clamp(abs(sin(TIME)), 0.1, 1);
}