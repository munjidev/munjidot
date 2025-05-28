# Geometry node import and setup tool
# By: munji
# Last edit: 2025-05-26 (refactor code; automate multimesh instances)

## [br]Node for isntancing [color=00d6a3ff]geometry node[/color] JSON transform data into multimesh instances.
## [br]
## [br]Made by [color=00d6a3ff]munji[/color]

@tool
@icon("ico_geometry_tool.svg")
extends Node3D

@export var json_file : JSON  ## Input file containing geometry node transform data.
@export var visible_instance_count : int = -1
@export_tool_button("  create geometry       ", "Add") var generate_button = use
@export_tool_button("  delete geometry       ", "Remove") var remove_button = remove_geometry

func use() -> void:
    var json_string := JSON.stringify(json_file.data)
    var instances: Array = JSON.parse_string(json_string)
    if !instances:
        push_warning("No instance data found.")
        return

    var grouped := {}
    for instance in instances:
        var source_name: String = instance.get("source_name", "")
        # if source_name == "msh_terrain": # TODO: exclude objects by name
        #     continue
        if !grouped.has(source_name):
            grouped[source_name] = []
        grouped[source_name].append(instance)

    for source_name in grouped.keys():
		# Skip existing multimeshinstance nodes
        var already_exists := false
        for child in get_children():
            if child is MultiMeshInstance3D && child.name == source_name:
                already_exists = true
                break

        if already_exists:
            continue

		# Seek for mesh objects in the project files (make sure geometry node object names with the mesh asset names)
        var mesh_path = find_mesh_path(source_name + ".res")
        if mesh_path == "":
            push_warning("Mesh not found for: %s" % source_name)
            continue

        var mesh = load(mesh_path)
        if !mesh:
            push_warning("Failed to load mesh: %s" % mesh_path)
            continue

        # Create base multimeshinstance3d node
        var multi_mesh_instance = MultiMeshInstance3D.new()
        multi_mesh_instance.name = source_name
        
        var multi_mesh = MultiMesh.new()
        multi_mesh.mesh = mesh
        multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
        multi_mesh_instance.multimesh = multi_mesh

        # Set instance transforms
        var transforms = []
        for instance in grouped[source_name]:
            var origin := Vector3(instance["position"][0], instance["position"][2], -instance["position"][1])
            var instance_scale := Vector3(instance["scale"][0], instance["scale"][2], instance["scale"][1])
            var instance_rotation := Vector3(instance["rotation"][0], instance["rotation"][1], instance["rotation"][2])

            var instance_basis := Basis.IDENTITY
            instance_basis = instance_basis.rotated(Vector3.RIGHT, instance_rotation.x)
            instance_basis = instance_basis.rotated(Vector3.BACK, instance_rotation.y)
            instance_basis = instance_basis.rotated(Vector3.UP, instance_rotation.z)
            instance_basis = instance_basis.scaled(instance_scale)

            var instance_transform := Transform3D(instance_basis, origin)
            transforms.append(instance_transform)

        # Set instance counts
        multi_mesh_instance.multimesh.instance_count = transforms.size()
        multi_mesh_instance.multimesh.visible_instance_count = visible_instance_count

        # Set instances
        for i in transforms.size():
            multi_mesh_instance.multimesh.set_instance_transform(i, transforms[i])

        add_child(multi_mesh_instance)
        multi_mesh_instance.owner = get_tree().edited_scene_root
        print("Added MultiMeshInstance3D: ", multi_mesh_instance.name)

    notify_property_list_changed()

    if Engine.is_editor_hint():
        name = name


func remove_geometry() -> void:
    for child in get_children():
        if child is MultiMeshInstance3D:
            remove_child(child)
            child.queue_free()
    print("Removed generated MultiMeshInstance nodes.")
    notify_property_list_changed()


func find_mesh_path(mesh_name: String, dir_path: String = "res://") -> String:
	# Recursive search for meshes matching the geometry node object instance names
    var dir = DirAccess.open(dir_path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                if file_name != "." && file_name != "..":
                    var found = find_mesh_path(mesh_name, dir_path + file_name + "/")
                    if found != "":
                        return found
            else:
                if file_name.ends_with(mesh_name):
                    return dir_path + file_name
            file_name = dir.get_next()
        dir.list_dir_end()
    return ""
    