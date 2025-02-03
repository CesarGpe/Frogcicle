extern number time;
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
    vec4 pixel = Texel(image, uvs);
    pixel.b *= sin(uvs.x * 4.5 + time * 2.5) * 0.5 + 1.0;
    pixel.g *= 1.2;
    return pixel * color;
}