shader_type canvas_item;

uniform float displacement_strength : hint_range(0.0, 20.0) = 4.0;
uniform float double_vision_strength : hint_range(0.0, 20.0) = 2.0;
uniform float edge_width : hint_range(0.0, 1.0) = 0.15;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0;
uniform float noise_velocity : hint_range(0.0, 5.0) = 0.5;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float edge = 0.5;
    float edge_factor = smoothstep(edge, edge - edge_width, dist);

    // Noise pattern for dynamic effect
    vec2 noise_uv = uv * noise_scale + vec2(TIME * noise_velocity, 0.0);
    float n = noise(noise_uv);

    // Dynamic direction, modulated by noise
    float angle = n * 6.2831853; // 0..2pi
    vec2 dir = vec2(cos(angle), sin(angle));

    float tex_w = float(textureSize(TEXTURE, 0).x);
    float tex_h = float(textureSize(TEXTURE, 0).y);
    float tex_size = max(tex_w, tex_h);

    float disp1_strength = displacement_strength / tex_size;
    float disp2_strength = double_vision_strength / tex_size;

    vec2 disp1 = uv + dir * disp1_strength * edge_factor;
    vec2 disp2 = uv - dir * disp2_strength * edge_factor;

    vec4 col1 = texture(TEXTURE, disp1);
    vec4 col2 = texture(TEXTURE, disp2);

    // Blend the two visions, weighted by edge_factor
    vec4 base = texture(TEXTURE, uv);
    COLOR = mix(base, (col1 + col2) * 0.5, edge_factor);
}
