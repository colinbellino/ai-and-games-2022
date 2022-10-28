class_name Shadow extends Behaviour

var shadow_scn = ResourceLoader.load("res://media/scenes/entities/Shadow.tscn")

func _ready() -> void:
    yield(get_tree(), "idle_frame")
    var shadow = shadow_scn.instance()
    # shadow.position.y = 0
    entity.add_child(shadow)
    entity.move_child(shadow, 1)
    # Globals.entities_node.move_child(poop_fx, 1)

