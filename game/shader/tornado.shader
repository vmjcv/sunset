shader_type canvas_item;

uniform sampler2D NoiseTex : hint_albedo;//噪声纹理
uniform vec4 tornado_color : hint_color= vec4(0.05,0.05,0.6,1);
const float spin_speed=1.0;

const int number_of_steps=160; // number of isosurface raytracing steps
const float base_step_scaling=0.6; // Larger values allow for faster rendering but cause rendering artifacts. When stepping the isosurface, the value is multiplied by this number to obtain the distance of each step
const float min_step_size=0.4; // Minimal step size, this value is added to the step size, larger values allow to speed up the rendering at expense of artifacts.

const float tornado_bounding_radius=35.0;

const float pi = 3.14159265;

render_mode blend_mul;

void R(inout vec2 p,inout vec2 a)
{
	p=cos(a)*p+sin(a)*vec2(p.y, -p.x);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = textureLod( NoiseTex, (uv+ 0.5)/256.0, 0.0 ).yx;
	return -1.0+2.4*mix( rg.x, rg.y, f.z );
}

mat2 Spin(float angle){
	return mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
}

float ridged(float f){
	return 1.0-2.0*abs(f);
}

// The isosurface shape function, the surface is at o(q)=0
float Shape(vec3 q,float iTime)
{
    q.y += 45.0;
    float h = 90.0;
	float t=spin_speed*iTime;
	//if(q.y<0.0)return length(q);
	vec3 spin_pos=vec3(Spin(t-sqrt(q.y))*q.xz,q.y-t*5.0);
	float zcurve=pow(q.y,1.5)*0.03;
	float v=abs(length(q.xz)-zcurve)-5.5-clamp(zcurve*0.2,0.1,1.0)*noise(spin_pos*vec3(0.1,0.1,0.1))*5.0;
	v=v-ridged(noise(vec3(Spin(t*1.5+0.1*q.y)*q.xz,q.y-t*4.0)*0.3))*1.2;
    v=max(v, q.y - h);
	return min(max(v, -q.y),0.0)+max(v, -q.y);
}

// Calculates fog colour, and the multiplier for the colour of item behind the fog. 
// If you do two intervals consecutively it will calculate the result correctly.
void FogStep(float dist, vec3 fog_absorb, vec3 fog_reemit, inout vec3 colour, inout vec3 multiplier)
{
    vec3 fog=exp(-dist*fog_absorb);
	colour+=multiplier*(vec3(1.0)-fog)*fog_reemit;
	multiplier*=fog;
}

void RaytraceFoggy(vec3 org, vec3 dir, float min_dist, float max_dist, inout vec3 colour, inout vec3 multiplier,float iTime)
{
    // camera
    vec3 q=vec3(0.0);

	float d=0.0;
	float dist=min_dist;

	float step_scaling=base_step_scaling;

	const float extra_step=min_step_size;
	for(int i=0;i<number_of_steps;i++)
	{
        q=org+dist*dir;
		float shape_value=Shape(q,iTime);
		float density=-shape_value;
		d=max(shape_value*step_scaling,0.0);
		float step_dist=d+extra_step;
		if(density>0.0){
			float brightness=exp(-0.6*density);
			FogStep(step_dist*0.2, clamp(density, 0.0, 1.0)*tornado_color.rgb,vec3(1)*brightness, colour, multiplier);
		}

		if(dist>max_dist || multiplier.x<0.01){
			return;
		}
		dist+=step_dist;
	}
	return;
}

// bounding cylinder from Dmytry Lavrov
bool RayCylinderIntersect(vec3 org, vec3 dir, out float min_dist, out float max_dist)
{ 
	vec2 p=org.xz;
	vec2 d=dir.xz;
	float r=tornado_bounding_radius;
	float a=dot(d,d)+1.0*pow(10.,-10.);/// A in quadratic formula , with a small constant to avoid division by zero issue
	float det, b;
	b = -dot(p,d); /// -B/2 in quadratic formula
	/// AC = (p.x*p.x + p.y*p.y + p.z*p.z)*dd + r*r*dd 
	det=(b*b) - dot(p,p)*a + r*r*a;/// B^2/4 - AC = determinant / 4
	if (det<0.0){
		return false;
	}
	det= sqrt(det); /// already divided by 2 here
	min_dist= (b - det)/a; /// still needs to be divided by A
	max_dist= (b + det)/a;	
	
	if(max_dist>0.0){
		return true;
	}else{
		return false;
	}
}

void fragment() {
    vec3 background_color=vec3(1.0, 1.0, 1.0);
    vec3 org = vec3(0., 0., -100.);  
	vec2 uv = UV;
	uv.y = 1. - uv.y;
    vec3 dir = normalize(vec3(((uv-0.5)/TEXTURE_PIXEL_SIZE.xy)*TEXTURE_PIXEL_SIZE.y, 1.));
    //R(dir.yz, -iMouse.y*0.01*pi*2.);
    //R(dir.xz, iMouse.x*0.01*pi*2.);
    //R(org.yz, -iMouse.y*0.01*pi*2.);
    //R(org.xz, iMouse.x*0.01*pi*2.);

    //Raymarching the isosurface:
	float dist=0.0;
	vec3 multiplier=vec3(1.0);
	vec3 color=vec3(0.0);
    float min_dist=0.0;
    float max_dist=200.0;

    if(RayCylinderIntersect(org, dir, min_dist, max_dist))
    {
        min_dist=max(min_dist,0.0);    
        RaytraceFoggy(org, dir, min_dist, max_dist, color, multiplier,TIME);
        vec3 col=color*0.5+multiplier*background_color;    
		COLOR=vec4(col , 1.0);
    }
    else
    {
        COLOR=vec4(background_color, 1.0);
    }
}
