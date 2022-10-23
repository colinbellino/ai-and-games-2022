class_name DebugUI extends CanvasLayer

var dump_label: Label

func _ready() -> void:
    dump_label = get_node("%Dump")
