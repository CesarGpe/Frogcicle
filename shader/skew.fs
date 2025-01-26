extern number time;
        extern number frequency = 10.0;
        extern number amplitude = 5.0;

        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
        {
            // Calculate the wave offset
            float wave = sin(texture_coords.x * frequency + time) * amplitude;

            // Apply the wave to the Y coordinate
            texture_coords.y += wave;

            // Sample the texture and return the final color
            vec4 texColor = Texel(tex, texture_coords);
            return texColor * color;
        }