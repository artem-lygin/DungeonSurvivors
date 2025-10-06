shader_type canvas_item;
render_mode unshaded, blend_add;

uniform float cell_size : hint_range(2.0, 64.0) = 8.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float dark_bias : hint_range(0.0, 2.0) = 1.0;

float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
    vec4 grad = texture(TEXTURE, UV);
    float lum = dot(grad.rgb, vec3(0.2126, 0.7152, 0.0722));

    // Dither cells in texture space
    vec2 cell_coord = floor(UV * cell_size * 256.0); // 256 is a fudge factor, tweak
    float threshold = hash12(cell_coord);

    float dark_strength = clamp(pow(1.0 - lum, dark_bias), 0.0, 1.0);
    float keep = step(threshold, lum);
    float factor = mix(lum, keep, dark_strength);

    COLOR = vec4(grad.rgb, grad.a * alpha) * factor;
}