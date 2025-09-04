shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float inner_radius : hint_range(0.0, 2.0) = 0.0;
uniform float outer_radius : hint_range(0.1, 3.0) = 1.0;
uniform vec3 vignette_color : source_color = vec3(0.0, 0.0, 0.0);
uniform float smoothness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    float x = abs(UV.r - 0.5) * 2.0;
    float y = abs(UV.g - 0.5) * 2.0;
    float distance = sqrt(x * x + y * y);

    float vignette = smoothstep(inner_radius, outer_radius, distance);
    vignette = mix(vignette, pow(vignette, 2.0 - smoothness), smoothness);

    COLOR = vec4(vignette_color, vignette * alpha);
}