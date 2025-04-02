/*

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

*/

/*
This file enables nodes in a GLTF file to be named. Either include
a `gltf_group_info("name")` at the start of a module (i.e. as its first
child), or use the `named_group("name")` module to wrap a block
of commands.

By default, both commands do nothing. They will output text objects
if the `SHOW_GLTF_MARKERS` variable is set to true.

This file is released under the "unlicense", <https://unlicense.org>

*/

SHOW_GLTF_MARKERS = false;

// Mark a group, so that the GLTF node is named meaningfully
// This is output as geommetry if SHOW_GLTF_MARKERS = true.
// It should only be used with scad2gltf which will remove
// this geomtry and interpret the text
module gltf_group_info(name) {
    if(SHOW_GLTF_MARKERS) {
        // Write json with single quotes as escaping is broken in CSG see:
        // https://github.com/openscad/openscad/issues/4556
        text(text=str("{'gltf-group-info-version': 1, 'name': '", name, "'}"));
    }
}

module named_group(name) {
    gltf_group_info(name);
    children();
}
