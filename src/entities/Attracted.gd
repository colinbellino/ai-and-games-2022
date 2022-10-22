class_name Attracted extends Node

onready var entity : Entity = get_parent()

func _ready() -> void:
    var _result = entity.connect("stimulus_received", self, "entity_stimulus_received")

func _exit_tree() -> void:
    entity.disconnect("stimulus_received", self, "entity_stimulus_received")

func entity_stimulus_received(type: String, emiter: Entity) -> void:
    if type != "Attraction" || entity._state != Enums.EntityStates.Idle:
        return

    entity.destination = emiter.position
    entity.change_state(Enums.EntityStates.Attracted)
    # print("[Attracted] %s stimulus_received to %s" % [entity.name, emiter.name])
