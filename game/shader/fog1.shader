shader_type canvas_item;
render_mode blend_mix;

void fragment() {
	COLOR=texture(TEXTURE,vec2(UV.x+TIME*0.2,UV.y));
	COLOR.a*=3.0;
}
