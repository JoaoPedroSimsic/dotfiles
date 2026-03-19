#version 300 es

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec2 uv = v_texcoord;
    
    vec2 curved_uv = uv * 2.0 - 1.0;
    vec2 offset = abs(curved_uv.yx) / vec2(6.0, 4.0);
    curved_uv = curved_uv + curved_uv * offset * offset * 0.03;
    curved_uv = curved_uv * 0.5 + 0.5;
    
    if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    
    vec2 texSize = vec2(1920.0, 1080.0);
    float pixelSize = 3.0;
    vec2 pixelUV = floor(curved_uv * texSize / pixelSize) * pixelSize / texSize;
    
    vec4 color = texture(tex, pixelUV);
    float luma = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    float scanline = sin(curved_uv.y * 480.0 * 3.14159) * 0.5 + 0.5;
    luma *= 1.0 - scanline * 0.15;
    
    vec2 vig = curved_uv * (1.0 - curved_uv.yx);
    luma *= pow(vig.x * vig.y * 15.0, 0.25);
    
    vec3 amber = vec3(1.0, 0.4, 0.0);
    vec3 dark = vec3(0.05, 0.02, 0.0);
    vec3 final_color = mix(dark, amber, luma);
    
    fragColor = vec4(final_color, 1.0);
}
