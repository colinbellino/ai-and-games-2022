class_name SendStimulus extends Node

onready var entity : Entity = get_parent()

func _ready() -> void:
    var _result = entity.connect("interacted", self, "entity_interacted")

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")

func entity_interacted() -> void:
    entity.change_state(Enums.EntityStates.Activating)
    var type = entity.get_meta("SendStimulus_Type")

    var entities = entity.get_entities_in_area()
    for target in entities:
        target.emit_signal("stimulus_received", type, entity)
