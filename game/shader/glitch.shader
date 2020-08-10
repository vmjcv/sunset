shader_type canvas_item;
render_mode blend_mul;

// 两种特效叠加，毛刺特效和扭曲特效
uniform sampler2D displace : hint_albedo;
uniform sampler2D my_texture : hint_albedo;
uniform float dispAmt: hint_range(0,0.1);//毛刺偏移量
uniform float abberationAmtX: hint_range(0,3.14);//rb色彩偏移初始值
uniform float abberationAmtY: hint_range(0,3.14);//rb色彩偏移初始值
uniform float abberationAmtScaleX: hint_range(0,1);//rb色彩偏移倍数
uniform float abberationAmtScaleY: hint_range(0,1);//rb色彩偏移倍数
uniform float dispSize: hint_range(0.1, 2.0);//取噪点图偏移倍数
uniform float maxAlpha : hint_range(0.1,1.0);//最大透明度

//随机小数
float rand(vec2 co)
{
   return fract(sin(dot(co,vec2(12.9898,78.233))) * 43758.5453);
}

	
vec3 vec3mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 vec2mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return vec3mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

  i = vec2mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


void fragment()
{
  // 毛刺特效

  float time = TIME * 10.0;
  
	
  float disp_amt = mix(0.001,0.003,rand(vec2(cos(time)+2.0*sin(time))));
  float abberation_amtX= sin(abberationAmtX + time)*abberationAmtScaleX;  
  float abberation_amtY= cos(abberationAmtY + time)*abberationAmtScaleY;  
  float max_alpha= sin(maxAlpha + time)*0.45+0.55;  
  float disp_size= mix(1.1,1.9,rand(vec2(sin(time)+2.0*cos(time))));  

  vec4 disp = texture(displace, UV * disp_size);
  vec2 newUV = UV + disp.xy * disp_amt;
  COLOR.r = texture(my_texture, newUV - vec2(abberation_amtX,abberation_amtY)).r; 
  COLOR.g = texture(my_texture, newUV).g; 
  COLOR.b = texture(my_texture, newUV + vec2(abberation_amtX,abberation_amtY)).b;
  COLOR.a = texture(my_texture, newUV).a * maxAlpha;


    // 扭曲特效
    time = TIME * 2.0;
    float noise = max(0.0, snoise(vec2(time, newUV.y * 0.3)) - 0.3) * (1.0 / 0.7);
    noise = noise + (snoise(vec2(time*10.0, newUV.y * 2.4)) - 0.5) * 0.15;
    float xpos = newUV.x - noise * noise * 0.1;
    COLOR.rgb = mix(COLOR.rgb, vec3(rand(vec2(newUV.y * time))), noise * 0.05).rgb;
    if (floor(mod(COLOR.y * 0.25, 2.0)) == 0.0)
    {
        COLOR.rgb *= 1.0 - (0.005 * noise);
    }
    COLOR.g = mix(COLOR.r, texture(my_texture, vec2(xpos + noise * 0.02, newUV.y)).g, 0.25);
    COLOR.b = mix(COLOR.r, texture(my_texture, vec2(xpos - noise * 0.02, newUV.y)).b, 0.25);
  
}