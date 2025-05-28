# Geometry nodes .JSON data exporter tool
# By: munjidev
# Last edit: 2025-05-27 (add user prompt pop-up for file name & path)

import bpy
import re
import json
from mathutils import Matrix

class ExportGeoNodesToJson(bpy.types.Operator):
    bl_idname = "export.geonodes_json"
    bl_label = "Export GeoNodes to .JSON"
    filename_ext = ".json"
    filter_glob: bpy.props.StringProperty(default="*.json", options={'HIDDEN'})
    filepath: bpy.props.StringProperty(subtype="FILE_PATH")
    filename: bpy.props.StringProperty(subtype="FILE_NAME")

    def execute(self, context):
        if not self.filepath.lower().endswith('.json'):
            self.report({'ERROR'}, "The path must contain .json")
            return {'CANCELLED'}

        dg = context.evaluated_depsgraph_get()
        eval_ob = context.object.evaluated_get(dg)

        # Gather selected node instances and map with corresponding indices
        instances_data = []
        source_names = set()
        for inst in dg.object_instances:
            if inst.is_instance and inst.parent == eval_ob:
                processed_name = re.sub(r'-[^-]+$', '', inst.instance_object.name) # Remove suffix specifiers (i.e. -col -noimp, etc.)
                source_names.add(processed_name)
        sorted_names = sorted(source_names)
        source_map = {name: i for i, name in enumerate(sorted_names)}

        # Gather instance data
        for instance in dg.object_instances:
            if instance.is_instance and instance.parent == eval_ob:
                matrix = instance.matrix_world
                position = [round(v, 4) for v in matrix.translation]
                rotation = [round(v, 4) for v in matrix.to_euler()]
                scale = [round(v, 4) for v in matrix.to_scale()]
                source_name = re.sub(r'-[^-]+$', '', instance.instance_object.name) # Add without suffix
                source_id = source_map[source_name]
                instances_data.append({
                    "source_id": source_id,
                    "source_name": source_name,
                    "position": position,
                    "rotation": rotation,
                    "scale": scale
                })

        with open(self.filepath, 'w') as f:
            json.dump(instances_data, f, indent=4)

        self.report({'INFO'}, f"Instance data saved to {self.filepath}")
        return {'FINISHED'}

    def invoke(self, context, event):
        scene_name = bpy.context.scene.name
        self.filename = f"{scene_name}.json"
        context.window_manager.fileselect_add(self)
        return {'RUNNING_MODAL'}

def menu_func_export(self, context):
    self.layout.operator(ExportGeoNodesToJson.bl_idname, text="Export GeoNodes to .JSON")

def unregister():
    try:
        bpy.utils.unregister_class(ExportGeoNodesToJson)
    except Exception:
        pass
    try:
        bpy.types.TOPBAR_MT_file_export.remove(menu_func_export)
    except Exception:
        pass

def register():
    bpy.utils.register_class(ExportGeoNodesToJson)
    bpy.types.TOPBAR_MT_file_export.append(menu_func_export)

if __name__ == "__main__":
    unregister()
    register()
