class_name Entity extends Node

onready var sprite_body : Sprite = find_node("SpriteBody")

func _ready() -> void:
    pass

func clicked() -> void:
    print("[ENTITY] %s clicked" % [name])

func stimulus_entered(area: EntityArea2D) -> void:
    print("[ENTITY] %s entered | source: %s | stimulus: %s" % [name, area.source, area.stimulus])

func stimulus_exited(area: EntityArea2D) -> void:
    print("[ENTITY] %s exited | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
