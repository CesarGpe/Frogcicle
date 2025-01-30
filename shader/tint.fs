extern vec4 new;
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
    vec4 pixel = Texel(image, uvs);
    vec4 recolor = vec4(mix(pixel.rgb, new.rgb, new.a), pixel.a);
    return recolor * color;
}