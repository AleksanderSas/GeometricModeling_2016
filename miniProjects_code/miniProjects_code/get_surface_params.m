function surface = get_surface_params(v1, v2, v3)
    surface = cross(v1-v2, v2-v3);
    surface = [surface, -surface*v1'];
    surface = surface / norm(surface);