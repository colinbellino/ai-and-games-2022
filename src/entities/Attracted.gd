class_name Attracted extends Node

onready var entity : Entity = get_parent()

func _ready() -> void:
    var _result = entity.connect("attracted", self, "entity_attracted")

func _exit_tree() -> void:
    entity.disconnect("attracted", self, "entity_attracted")

func entity_attracted(emiter: Entity) -> void:
    # TODO: Do this only if Idle maybe?
    entity.destination = emiter.position
    entity.change_state(Enums.EntityStates.Attracted)
    # print("[Attracted] %s attracted to %s" % [entity.name, emiter.name])
