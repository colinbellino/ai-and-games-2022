class_name IsCreature extends Behaviour

func _ready() -> void:
    assert(Globals.creature == null, "Already one creature in the world!")

    Globals.creature = entity
