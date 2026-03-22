shader_type spatial;
render_mode unshaded; 

uniform vec3 grid_color : source_color = vec3(0.0, 1.0, 0.2); // Neon Green
uniform vec3 base_color : source_color = vec3(0.1, 0.1, 0.1); // Dark Gray
uniform float grid_line_thickness : hint_range(0.01, 0.2) = 0.05;
uniform float grid_scale = 1.0;


float grid(vec2 uv) {
    vec2 grid_uv = fract(uv * grid_scale);
    float d = min(grid_uv.x, 1.0 - grid_uv.x);
    d = min(d, grid_uv.y);
    d = min(d, 1.0 - grid_uv.y);
    return smoothstep(0.0, grid_line_thickness, d);
}

void fragment() {
    
    float g = grid(UV);
    
  
    ALBEDO = mix(grid_color, base_color, g);
}