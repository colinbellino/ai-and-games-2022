class_name Attracted extends Node

onready var entity : Entity = get_parent()

func _ready() -> void:
    var _result = entity.connect("attracted", self, "entity_attracted")

func _exit_tree() -> void:
    entity.disconnect("attracted", self, "entity_attracted")

func entity_attracted(emiter: Entity) -> void:
   print("[Attracted] %s attracted to %s" % [entity.name, emiter.name])
