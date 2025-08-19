shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;
uniform float effect_duration : hint_range(0.1, 10.0) = 1.0;
uniform float start_time : hint_range(0.0, 100.0) = 0.0;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float wave_height : hint_range(0.1, 1.0) = 0.2;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // Check if effect should be active based on progress
    bool effect_active = progress > 0.0 && progress <= 1.0;

    if (!effect_active) {
        COLOR = original_color;
    } else {
        // Calculate wave position (bottom to top)
        float wave_center = progress; // 0.0 at bottom, 1.0 at top
        float wave_top = wave_center + wave_height;
        float wave_bottom = wave_center - wave_height;

        // Check if current pixel is within the wave range
        float current_y = 1.0 - UV.y; // Flip Y so 0 is bottom, 1 is top
        bool in_wave = current_y >= wave_bottom && current_y <= wave_top;

        if (!in_wave) {
            COLOR = original_color;
        } else {
            // Sample surrounding pixels to detect edges
            vec2 pixel_size = TEXTURE_PIXEL_SIZE;

            float outline_alpha = 0.0;

            // Sample pixels in a circle around current pixel
            int samples = 8;
            for (int i = 0; i < samples; i++) {
                float angle = float(i) * 6.28318 / float(samples);
                vec2 offset = vec2(cos(angle), sin(angle)) * outline_width * pixel_size;
                vec4 sample_color = texture(TEXTURE, UV + offset);

                // If we're on an opaque pixel but nearby pixel is transparent, we're on the inside outline
                if (original_color.a > 0.1 && sample_color.a < 0.1) {
                    outline_alpha = 1.0;
                    break;
                }
            }

            // Calculate wave fade effect
            float distance_from_center = abs(current_y - wave_center) / wave_height;
            float wave_alpha = 1.0 - smoothstep(0.0, 1.0, distance_from_center);

            // Apply outline with wave and progress-based alpha
            if (outline_alpha > 0.0) {
                vec4 final_outline = outline_color;
                final_outline.a *= wave_alpha; // Fade based on distance from wave center
                COLOR = mix(original_color, final_outline, final_outline.a);
            } else {
                COLOR = original_color;
            }
        }
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
