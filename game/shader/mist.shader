shader_type canvas_item;
render_mode blend_mix;
uniform vec4 color : hint_color= vec4(0.05,0.05,0.6,1);
uniform sampler2D NoiseTex : hint_albedo;//噪声纹理

void fragment() {
	vec2 p = UV*6.-3.;
	vec4 z = vec4(0.);
	vec4 c;
	vec4 d=z;
	float t = TIME*0.5;
    p.x -= (t*.4);
    for(float i=0.;i<8.;i+=.3)
	{
        c = texture(NoiseTex, p.xy*.0029)*11.;
        d.x = cos(c.x+t);
		d.y = sin(c.y+t);
        z += ((2.-abs(p.y))*vec4(color.r, color.g, color.b, 9.));
        //z += (2.-abs(p.y))*vec4(.2,.4,.1*i,1.); // Alt palette
        z *= dot(d,d-d+.03)+.98;
        p -= d.xy*.022;
	}
	
	COLOR = z/50.;
	COLOR.a/=10.;

	if(COLOR.r*COLOR.g*COLOR.b<=0.001){
		COLOR = vec4(1.,1.,1.,0.);//smoothstep(0.9,1.0,1.-COLOR.r*COLOR.g*COLOR.b*12.5));
		COLOR.a=0.;
	}
}
