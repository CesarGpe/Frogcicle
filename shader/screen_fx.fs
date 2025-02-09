extern vec4 border_color;
extern float border_size;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
    vec2 sc = screen_coords / love_ScreenSize.xy * 2.0 - 1.0;
	vec4 pixel = Texel(image, uvs);

	float d = length(sc) - 1.0 + border_size;
	float factor = smoothstep(0.5, 1.0, d);
    vec4 border = mix(vec4(1.0), border_color, factor);
    vec3 c = mix(pixel.rgb, border_color.rgb, factor * border_color.a);
	vec4 b = vec4(c, pixel.a);

	return b * color;
}
