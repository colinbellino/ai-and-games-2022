class_name EmitStimulus extends Behaviour

func _ready() -> void:
    entity.connect("interacted", self, "entity_interacted")

func _exit_tree() -> void:
    entity.disconnect("interacted", self, "entity_interacted")

func entity_interacted(_interaction_type: int) -> void:
    entity.change_state(Enums.EntityStates.Activating)
    var type = LDTK.get_behaviour_meta(entity, "EmitStimulus", "Type")

    var entities = entity.get_entities_in_area()
    for target in entities:
        target.emit_signal("stimulus_received", type, entity)
