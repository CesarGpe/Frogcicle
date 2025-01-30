extern vec2 screen_size;
extern vec4 border_color; // The border color with alpha (RGBA)

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords)
{
    // Normalize screen coordinates
    vec2 sc = screen_coords / screen_size;

    // Define border width as a fraction of screen size
    float border_width = 0.05;

    // Calculate how far the current pixel is from the screen edge
    float distance_from_edge = min(sc.x, 1.0 - sc.x);
    distance_from_edge = min(distance_from_edge, min(sc.y, 1.0 - sc.y));

    // Normalize distance from edge (0.0 at the edge, 1.0 at the center)
    distance_from_edge = distance_from_edge / border_width;

    // Clamp distance from edge between 0.0 and 1.0
    distance_from_edge = clamp(distance_from_edge, 0.0, 1.0);

    // Calculate fading alpha based on distance from the edge
    float fade_factor = 1.0 - distance_from_edge;

    // Apply the fade factor to the border color alpha channel
    vec4 faded_border_color = border_color;
    faded_border_color.a *= fade_factor;

    // Check if the pixel is within the border area
    bool is_border = (sc.x < border_width || sc.x > 1.0 - border_width || sc.y < border_width || sc.y > 1.0 - border_width);

    // If it's a border pixel, apply the faded border color; otherwise, apply the image color
    if (is_border) {
        return faded_border_color;
    } else {
        vec4 pixel = Texel(image, uvs);
        return pixel * color;
    }
}
