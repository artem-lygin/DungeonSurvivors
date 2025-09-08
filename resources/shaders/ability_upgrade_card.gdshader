shader_type canvas_item;

uniform float outline_thickness : hint_range(0.0, 20.0) = 3.0;
uniform float outline_gap : hint_range(0.0, 20.0) = 1.0; // Gap in pixels, same units as outline_thickness
uniform vec4 outline_color : source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform float outline_visible : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float alpha = tex.a;

    float tex_w = float(textureSize(TEXTURE, 0).x);
    float tex_h = float(textureSize(TEXTURE, 0).y);
    float tex_size = max(tex_w, tex_h);

    float outline_step = outline_thickness / tex_size;
    float gap_step = outline_gap / tex_size;

    float outline = 0.0;
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            if (x == 0 && y == 0) continue;
            vec2 offset = vec2(float(x), float(y)) * outline_step;
            float sample_alpha = texture(TEXTURE, UV + offset).a;

            // Only outline if the current pixel is outside the gap region
            vec2 gap_offset = vec2(float(x), float(y)) * gap_step;
            float gap_alpha = texture(TEXTURE, UV + gap_offset).a;

            // Outline if neighbor is opaque and current is transparent, but not inside the gap
            outline = max(
                outline,
                step(0.5, vec2(sample_alpha, sample_alpha)).x * (1.0 - step(0.5, vec2(gap_alpha, gap_alpha)).x)
            );
        }
    }

    if (outline_visible > 0.5 && outline > 0.0 && alpha < 0.5) {
        COLOR = outline_color;
    } else {
        COLOR = tex;
    }
}
