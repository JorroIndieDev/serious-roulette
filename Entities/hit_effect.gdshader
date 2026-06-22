shader_type canvas_item;
render_mode blend_mix;

uniform float flash : hint_range(0.0, 1.0) = 0.0;
uniform float brightness : hint_range(1.0, 5.0) = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec3 white = vec3(brightness);
    COLOR.rgb = mix(tex.rgb, white, flash);
    COLOR.a = tex.a;   // Keep the texture's original alpha (shape)
}