shader_type canvas_item;
render_mode unshaded, blend_add; // nice for light overlays

// Reuse your light’s ramp here (assign GradientTexture2D or PNG)
uniform sampler2D gradient_ramp;

// Light shape/size (keeps pixel art crisp if you size the node in whole pixels)
uniform float radius_uv = 0.45;     // radius in the node's UV space (0..1), 0.5 touches edges
uniform vec2 iso_scale = vec2(1.0); // keep (1,1) for pixel art; non-1 will stretch

// Noise controls
uniform float noise_scale = 50.0;   // bigger = coarser noise
uniform float noise_speed = 0.6;    // animation speed
uniform float noise_strength = 0.25;// 0..1, how much noise modulates brightness

// Pixel snapping for noise sampling (keeps noise from "swimming" between pixels)
uniform int noise_pixel_step = 1;   // 1 = per pixel, 2 = per 2x2 block, etc.

// --- lightweight value-noise (no external texture needed) ---
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}
float value_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
    // radial falloff from center
    vec2 p = (UV - 0.5) * iso_scale;
    float dist = length(p);
    float t = clamp(dist / max(radius_uv, 1e-5), 0.0, 1.0); // 0 center -> 1 edge

    // sample your 1D ramp horizontally; put the gradient content along X (Y=0.5)
    vec4 base = texture(gradient_ramp, vec2(t, 0.5));

    // pixel-snapped screen UV for stable noise in pixel art
    float step_px = max(float(noise_pixel_step), 1.0);
    vec2 snapped = floor(SCREEN_UV / (SCREEN_PIXEL_SIZE * step_px)) * (SCREEN_PIXEL_SIZE * step_px);

    // animated value noise
    float n = value_noise(snapped * noise_scale + vec2(0.0, TIME * noise_speed));
    float flicker = 1.0 + (n - 0.5) * 2.0 * noise_strength; // ~[1 - strength, 1 + strength]

    COLOR = base * flicker;
}