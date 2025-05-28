# Geometry tool node setup script
# By: munji
# Last edit: 2025-05-26 (create script)
@tool
extends EditorPlugin

func _enter_tree():
    var icon = load("res://addons/GeometryTool/ico_geometry_tool.svg")
    add_custom_type(
        "GeometryTool",
        "Node3D",
        preload("res://addons/GeometryTool/geometry_tool.gd"),
        icon
    )

func _exit_tree():
    remove_custom_type("GeometryTool")