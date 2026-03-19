precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const vec3 AMBER = vec3(1.0, 0.4, 0.0);
const vec3 AMBER_DARK = vec3(0.05, 0.02, 0.0);

const float PIXEL_SIZE = 3.0;

const float SCANLINE_INTENSITY = 0.15;
const float SCANLINE_COUNT = 240.0;

const float CURVATURE = 0.03;

const float VIGNETTE_INTENSITY = 0.3;

const float BLOOM_INTENSITY = 0.08;

const float FLICKER_INTENSITY = 0.02;

uniform vec2 screenSize;

vec2 curveRemapUV(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(6.0, 4.0);
    uv = uv + uv * offset * offset * CURVATURE;
    uv = uv * 0.5 + 0.5;
    return uv;
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    vec2 uv = v_texcoord;
    
    vec2 curved_uv = curveRemapUV(uv);
    
    if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    
    vec2 pixelated_uv = curved_uv;
    vec2 texSize = vec2(1920.0, 1080.0); 
    vec2 pixelSize = vec2(PIXEL_SIZE) / texSize;
    pixelated_uv = floor(pixelated_uv / pixelSize) * pixelSize;
    
    vec4 color = texture2D(tex, pixelated_uv);
    
    float luma = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    luma = pow(luma, 0.9);
    
    float scanline = sin(curved_uv.y * SCANLINE_COUNT * 3.14159 * 2.0) * 0.5 + 0.5;
    scanline = pow(scanline, 1.5) * SCANLINE_INTENSITY;
    luma *= (1.0 - scanline);
    
    float hgap = sin(curved_uv.x * texSize.x / PIXEL_SIZE * 3.14159) * 0.5 + 0.5;
    hgap = pow(hgap, 4.0) * 0.05;
    luma *= (1.0 - hgap);
    
    vec4 bloom = vec4(0.0);
    for (float i = -2.0; i <= 2.0; i += 1.0) {
        for (float j = -2.0; j <= 2.0; j += 1.0) {
            vec2 offset = vec2(i, j) * pixelSize * 1.5;
            bloom += texture2D(tex, pixelated_uv + offset);
        }
    }
    bloom /= 25.0;
    float bloom_luma = dot(bloom.rgb, vec3(0.299, 0.587, 0.114));
    luma += bloom_luma * BLOOM_INTENSITY;
    
    vec2 vignette_uv = curved_uv * (1.0 - curved_uv.yx);
    float vignette = vignette_uv.x * vignette_uv.y * 15.0;
    vignette = pow(vignette, VIGNETTE_INTENSITY);
    luma *= vignette;
    
    float flicker = 1.0 - FLICKER_INTENSITY * random(vec2(floor(curved_uv.y * 100.0), 0.0));
    luma *= flicker;
    
    vec3 final_color = mix(AMBER_DARK, AMBER, luma);
    
    float noise = (random(curved_uv + vec2(0.1, 0.1)) - 0.5) * 0.02;
    final_color += noise;
    
    gl_FragColor = vec4(final_color, 1.0);
}
