shader_type canvas_item;
render_mode blend_mul;
uniform float LOD = 3.5;//控制背景的模糊程度
uniform sampler2D NoiseTex : hint_albedo;//噪声纹理

const vec2 ShadeDir=vec2(-1.0, 1.0);//阴影方向


// iChannel1 is recommended to use the 'RGBA Noise Small' texture (64x64)

float shading(vec2 dir)
{
    float s = dot(normalize(dir), normalize(ShadeDir));
    s = max(s, 0.0);
    return s;
}

//----------------------------
// Eliemichel's technique
//----------------------------

// uv   - texcoord for looking up the background texture
// p    - a 2d position for noise lookup
// curr - the current output color
// time - scaled time for this layer
vec4 layerEliemichel(vec2 uv, vec2 p, vec4 curr, float time,sampler2D mainTex)
{
    vec2 x = vec2(30); // controls the size vs density
    vec2 xuv = x * p;
    vec4 n = texture(NoiseTex, round(xuv - .3) / x);
    
    vec2 offset = (texture(NoiseTex, p * .1).rg - .5) * 2.; // expands to [-1, 1]
    vec2 z = xuv * 6.3 + offset; // 6.3 is a magic number
    x = sin(z) - fract(time * (n.b + .1) + n.g) * .5;
    
    if (x.x + x.y - n.r * 50. > .7)
    {
        vec2 dir = cos(z);
        curr = textureLod(mainTex, uv + dir * .2, 0.0);
        curr += shading(dir) * curr;
    }
    return curr;
}


vec3 n31(float p)
{
    //  3 out, 1 in... DAVE HOSKINS
   vec3 p3 = fract(vec3(p) * vec3(.1031,.11369,.13787));
   p3 += dot(p3, p3.yzx + 19.19);
   return fract(vec3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}

float sawTooth(float t) {
	
    return cos(t+cos(t))+sin(2.*t)*.2+sin(4.*t)*.02;
}
float deltaSawTooth(float t) {
	
    return 0.4*cos(2.*t)+0.08*cos(4.*t) - (1.-sin(t))*sin(t+cos(t));
}


vec3 getDrops(vec2 uv, float seed, float t)
{
    vec2 o = vec2(0.);
    
    uv.y += t * 0.05;
    
    uv *= vec2(20., 2.5)*2.;
    vec2 id = floor(uv);
    vec3 n = n31(id.x + (id.y+seed)*546.3524);
    vec2 bd = fract(uv);
    
    vec2 uv2 = bd;
    
    bd -= 0.5;
    
    bd.y*=4.;
    
    bd.x += (n.x-.5)*.6;
    
    t += n.z * 6.28;
    float slide = sawTooth(t);
    
    float ts = 1.5;
    vec2 trailPos = vec2(bd.x*ts, (fract(bd.y*ts*2.-t*2.)-.5)*.5);
    
    bd.y += slide*2.;								// make drops slide down
    
    //#ifdef HIGH_QUALITY
    float dropShape = bd.x*bd.x;
    dropShape *= deltaSawTooth(t);
    bd.y += dropShape;								// change shape of drop when it is falling
   	//#endif
    
    float d = length(bd)*1.0;							// distance to main drop
    
    float trailMask = smoothstep(-.2, .2, bd.y);				// mask out drops that are below the main
    trailMask *= bd.y;								// fade dropsize
    float td = length(trailPos*max(.5, trailMask));	// distance to trail drops
    
    float mainDrop = smoothstep(.2, .1, d);
    float dropTrail = 0.0;//smoothstep(.1, .002, td);
    
    dropTrail *= trailMask;
    o = mix(bd*mainDrop, trailPos, dropTrail);		// mix main drop and drop trail
    
    return vec3(o, d);
}

vec4 layerBigWIngs(vec2 uv, vec2 p, vec4 curr, float time,sampler2D mainTex)
{
    vec3 drop = getDrops(p, 1., time);
    
    if (length(drop.xy) > 0.0)
    {
        vec2 offset = -drop.xy * (1.0 - drop.z);
    	curr = texture(mainTex, uv + offset);
        curr += shading(offset) * curr * 0.5;
    }
    
    return curr;
}



void fragment()
{
    // background
    vec4 ret=textureLod(SCREEN_TEXTURE, SCREEN_UV, LOD);
    
    // use BigWIngs layer as base drops
    ret=layerBigWIngs(SCREEN_UV, SCREEN_UV * 2.2, ret, TIME * 3.15,SCREEN_TEXTURE);
    // add Eliemichel layers with fbm (see https://www.shadertoy.com/view/lsl3RH) as detailed drops.
    const mat2 m = mat2(vec2(0.80,  0.60) ,vec2(-0.60,  0.80 ));
    vec2 p = SCREEN_UV;
    
    ret = layerEliemichel(SCREEN_UV, p + vec2(0, TIME * 0.01), ret, TIME * 0.95,SCREEN_TEXTURE);
    p = m * p * 2.02;
    
    ret = layerEliemichel(SCREEN_UV, p, ret, TIME * 1.58,SCREEN_TEXTURE);
    p = m * p * 1.253;
    
	ret= layerEliemichel(SCREEN_UV, p, ret, TIME * 2.21,SCREEN_TEXTURE);
    COLOR = ret;
}