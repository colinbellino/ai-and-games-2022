class_name WakeUp extends Behaviour

func _ready() -> void:
    entity.connect("interacted", self, "entity_interacted")

func entity_interacted(_interaction_type: int) -> void:
    print("[WAKE_UP] %s waking up" % [name])
    entity.change_state(Enums.EntityStates.Idle)
    Audio.stop_sound()
