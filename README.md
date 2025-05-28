# Munji's collection of Blender & Godot addons
This is a collection of custom tools I use for my projects in Blender and Godot. A bit of documentation for each can be found below, but do note that I do not plan to actively maintain these tools, and will probably perform changes based on my projects' needs. Eitherways, feel free to use them for your own under MIT license.

### Contributing

Feel free to submit a Pull Request! I'll do my best to give it attention. I will review requests thoroughly given I use these tools constantly, so that they don't disrupt my own workflow.

## <img src="GeometryNodeExporter/GeometryTool/ico_geometry_tool.svg" alt="icon" width="33" style="vertical-align: bottom;"/><span style="color: #00d6a3ff;"></span> Geometry Tool

### Features
- Export Blender geometry node transform data to .JSON.
- Custom <img src="GeometryNodeExporter/GeometryTool/ico_geometry_tool.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #00d6a3ff;"> GeometryTool</span> node to instance geometry node data in meshinstances.
- Basic control over visible instance count.

### Installation
- Download the python script `export_geonodes_to_json.py` and drag it onto your Blender scene, or open it via the Text Editor menu and press the run button. The export option `File > Export > Export GeoNodes to .JSON` should appear.
- Select your geometry node object and export it by selecting `Export GeoNodes to .JSON`. A pop-up will ask for the file name and save location.
- Export the instanced objects into Godot and save their <img src="imgs/MeshItem.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #e0e0e0ff;"> mesh</span> individually during the import process. 
- If already exported, just save the <img src="imgs/ArrayMesh.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #ffca5fff;"> ArrayMesh</span> by right clicking it, just make sure to name it the same way as the Blender object. Alternatively, save the meshes by specifying their save locations via the `Advanced` import settings of the exported file (gLTF, GLB, etc.)
- Now, copy the `/GeometryTool` folder to `res://addons` and reload the project.
  
### Usage
- Add the <img src="GeometryNodeExporter/GeometryTool/ico_geometry_tool.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #00d6a3ff;"> GeometryTool</span> node to the scene hierarchy via the add <img src="imgs/Add.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #e0e0e0ff;"></span> menu, listed under <img src="imgs/Node3D.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #fc7f7fff;"> Node3D</span>.
- Load the saved .JSON file in the `Json File` field. 
- By pressing <img src="imgs/Add.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #e0e0e0ff;"> create geometry</span>, the tool will recursively search for the saved mesh objects in the project files and set them as the <img src="imgs/ArrayMesh.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #ffca5fff;"> ArrayMesh</span> for <img src="imgs/MultiMeshInstance3D.svg" alt="icon" width="15" style="vertical-align: text-bottom;"/><span style="color: #fc7f7fff;"> MultiMeshInstance3D</span> instances.
- Adjust the visible instance count, or leave it with a default value of -1 to draw all instances.
- Remove the geometry nodes.

### Stretch goals
- [ ] Selectively add or remove instance obejcts.
- [ ] Ability to control visible instance count per multimeshinstance.
- [ ] Automatic or custom collision shape instancing per multimeshinstance.
- [ ] Custom material override per multimesh instance mesh.
- [ ] Exclude geometry objects by name.

## <img src="imgs/Progress2.svg" alt="icon" width="33" style="vertical-align: bottom;"/><span style="color: #e0e0e0ff;"></span> Blender Curve wrangler

(coming soon...)