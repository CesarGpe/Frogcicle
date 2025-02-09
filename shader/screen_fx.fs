extern vec4 border_color;
extern float border_size;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
	vec4 pixel = Texel(image, uvs);
    vec2 norm_screen = screen_coords / love_ScreenSize.xy * 2.0 - 1.0;
	
	// screen border
	float to_center = length(norm_screen) - 1.0 + border_size;
	float factor = smoothstep(0.5, 1.0, to_center);
    vec3 new_color = mix(pixel.rgb, border_color.rgb, factor * border_color.a);
	pixel = vec4(new_color, pixel.a);

	return pixel * color;
}