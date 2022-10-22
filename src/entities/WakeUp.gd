class_name WakeUp extends Node

onready var entity : Entity = get_parent()

func _ready() -> void:
    var _result = entity.connect("interacted", self, "entity_interacted")

func entity_interacted() -> void:
    print("[WAKE_UP] %s waking up" % [name])
    entity.change_state(Enums.EntityStates.Idle)
