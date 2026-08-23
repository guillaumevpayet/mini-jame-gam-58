shader_type canvas_item;

uniform int heat_level : hint_range(0, 12) = 0;
uniform float time = 0.0;

void fragment() {
    // Level 0 → t=0 → strength=0 → offset is vec2(0,0) → identity sample.
    float t = float(heat_level) / 12.0;
    float power = t * t;

    float strength = power * 0.0025;
    float speed    = 1.0 + float(heat_level) * 0.55;
    float waves    = 12.0 + float(heat_level) * 2.5;

    float wave = sin(UV.x * waves + time * speed);

    if (heat_level >= 5) {
        float chop_t = float(heat_level - 4) / 8.0;
        wave += chop_t * sin(UV.x * waves * 2.7
                           + UV.y * waves * 1.4
                           + time * speed * 1.7);
    }

    if (heat_level >= 9) {
        float violent = float(heat_level - 8) / 4.0;
        wave += violent * sin(UV.x * waves * 5.1
                            + time * speed * 3.1);
    }

    float y_weight = 1.0 - UV.y;
    vec2 offset = vec2(wave, wave * 0.4) * strength * y_weight;
    COLOR = texture(TEXTURE, clamp(UV + offset, 0.0, 1.0));

    if (heat_level >= 7) {
        float tint_amount = float(heat_level - 6) / 6.0;
        vec3 warm = vec3(1.0, 0.82, 0.55);
        COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * warm, tint_amount * 0.35);
    }
}