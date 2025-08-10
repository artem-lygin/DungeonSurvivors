shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float glow_radius : hint_range(0.0, 0.1) = 0.02;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform vec3 glow_color : source_color = vec3(1.0, 0.2, 0.2);
uniform float red_threshold : hint_range(0.0, 1.0) = 0.7;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec4 final_color = original_color;
    
    // Check if the pixel is red enough to be considered an "eye"
    bool is_red_eye = original_color.r > red_threshold && 
                      original_color.g < 0.5 && 
                      original_color.b < 0.5 && 
                      original_color.a > 0.5;
    
    if (is_red_eye) {
        // Create pulsing effect
        float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
        float current_intensity = glow_intensity * (0.7 + 0.3 * pulse);
        
        // Enhance the red color and add glow
        final_color.rgb = glow_color * current_intensity;
        final_color.a = original_color.a;
    }
    
    // Add outer glow effect around red pixels
    float glow_amount = 0.0;
    int samples = 8;
    for (int i = 0; i < samples; i++) {
        float angle = float(i) * 6.28318 / float(samples);
        vec2 offset = vec2(cos(angle), sin(angle)) * glow_radius;
        vec4 sample_color = texture(TEXTURE, UV + offset);
        
        if (sample_color.r > red_threshold && 
            sample_color.g < 0.5 && 
            sample_color.b < 0.5 && 
            sample_color.a > 0.5) {
            glow_amount += 1.0;
        }
    }
    
    if (!is_red_eye && glow_amount > 0.0) {
        float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
        float glow_strength = (glow_amount / float(samples)) * glow_intensity * 0.3 * (0.7 + 0.3 * pulse);
        final_color.rgb = mix(original_color.rgb, glow_color, glow_strength * (1.0 - original_color.a));
        final_color.a = max(original_color.a, glow_strength);
    }
    
    COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
