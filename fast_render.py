#!/usr/bin/env python3

import os
from build_system.openscad_render_system import RenderSystem, ScadRender, Camera


def generate_actuator_assembly(rendersystem):
    input_file = "rendering/actuator_assembly.scad"
    cameras = [
        Camera(position=[2, 5, 14], angle=[33, 0, 242], distance=360),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[20, 6, 35], angle=[82, 0, 166], distance=500),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
    ]
    imgsize = [2400, 2000]
    pngs = [
        "actuator_assembly_parts.png",
        "actuator_assembly_nut.png",
        "actuator_assembly_gear.png",
        "actuator_assembly_gear2.png",
        "actuator_assembly_oil.png",
        "actuator_assembly_x.png",
        "actuators_assembled.png",
    ]
    for i, camera in enumerate(cameras):
        output_file = os.path.join("docs/renders/", pngs[i])
        scad = f"render_actuator_assembly({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def main():
    rendersystem = RenderSystem()
    generate_actuator_assembly(rendersystem)
    rendersystem.render()
    

if __name__ == "__main__":
    main()
