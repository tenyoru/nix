float hash21(vec2 p) {
    uvec2 n = uvec2(ivec2(p));
    uint h = n.x * 374761393u + n.y * 668265263u;
    h = (h ^ (h >> 13u)) * 1274126177u;
    return float(h) * (1.0 / 4294967295.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 c = texture(iChannel0, fragCoord / iResolution.xy);
    float g = hash21(floor(fragCoord / 2.0)) * 0.6
        + hash21(floor(fragCoord / 5.0) + 19.0) * 0.4;
    c.rgb *= 1.0 - g * 0.09;
    fragColor = c;
}
