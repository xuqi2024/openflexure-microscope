SHOW_GLTF_MARKERS = false;

// Mark a group, so that the GLTF node is named meaningfully
module gltf_name(name) {
    if(SHOW_GLTF_MARKERS) {
        text(text=str("[gltf name] ", name));
    }
}