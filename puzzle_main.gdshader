shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert;
// NOTE: We REMOVED "unshaded;" so lighting works!

// --- UNIFORMS (Change these in the Inspector!) ---
uniform vec3 grid_color : source_color = vec3(0.0, 0.5, 1.0); // Neon Blue
uniform vec3 base_color : source_color = vec3(0.2, 0.2, 0.3); // Gray-Blue
uniform float grid_line_thickness : hint_range(0.01, 0.2) = 0.05;
uniform float grid_scale = 1.0;

// This calculates the smooth grid lines
float grid(vec2 uv) {
    vec2 grid_uv = fract(uv * grid_scale);
    float d = min(grid_uv.x, 1.0 - grid_uv.x);
    d = min(d, grid_uv.y);
    d = min(d, 1.0 - grid_uv.y);
    return smoothstep(0.0, grid_line_thickness, d);
}

void fragment() {
    // --- The "World Space" Math Trick ---
    // Instead of using UV (which is unique to each mesh), 
    // we use the object's World Position. 
    // This makes the grid seamlessly connect between blocks!
    
    vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // We combine the XZ coordinates for the floor/ceiling 
    // and XY for the walls to make the grid wrap properly.
    vec2 pos_2d = world_pos.xz + world_pos.xy + world_pos.yz;
    
    // Calculate the main grid color
    float g = grid(pos_2d);
    vec3 final_albedo = mix(grid_color, base_color, g);
    
    // Assign the albedo (the color before lighting is applied)
    ALBEDO = final_albedo;
    
    // A little bit of roughness so the lights don't look too shiny
    ROUGHNESS = 0.8;
}


