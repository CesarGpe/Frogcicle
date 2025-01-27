extern vec2 screen_size;
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
    vec4 pixel = Texel(image, uvs);
    vec2 sc = vec2(screen_coords.x / screen_size.x, screen_coords.y / screen_size.y);

    float blendFactor = smoothstep(0.0, 1.5, 1.0 - sc.y);
    vec3 redColor = vec3(1.0, 0.1, 0.1);
    vec3 finalColor = mix(pixel.rgb, redColor, blendFactor);

    return vec4(finalColor, pixel.a) * color;
}