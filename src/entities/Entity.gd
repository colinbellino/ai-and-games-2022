class_name Entity extends Node

onready var sprite_body : AnimatedSprite = find_node("SpriteBody")

# Note: don't change this without using change_state()
var _state : int
var _state_entered : bool
var _state_exited : bool

signal interacted
signal area_entered(area)
signal area_exited(area)

func _ready() -> void:
    pass

func _process(_delta: float):
    if _state == Enums.EntityStates.Idle:
        if _state_entered == false:
            _state_entered = true
            print("[ENTITY] %s doing nuffin (idle)" % [name])
            sprite_body.play("idle")

    if _state == Enums.EntityStates.Asleep:
        if _state_entered == false:
            _state_entered = true
            print("[ENTITY] %s fell asleep" % [name])
            sprite_body.play("fall_asleep")
            yield(sprite_body, "animation_finished")
            sprite_body.play("asleep")

func clicked() -> void:
    print("[ENTITY] %s clicked" % [name])
    emit_signal("interacted")

func interacted(area: EntityArea2D) -> void:
    print("[ENTITY] %s interacted | source: %s | stimulus: %s" % [name, area.source, area.stimulus])

func area_entered(area: EntityArea2D) -> void:
    print("[ENTITY] %s entered | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    connect("interacted", area, "_interacted", [area])
    emit_signal("area_entered", area)

func area_exited(area: EntityArea2D) -> void:
    print("[ENTITY] %s exited | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    disconnect("interacted", area, "_interacted")
    emit_signal("area_exited", area)

func change_state(state: int) -> void:
    print("[ENTITY] %s changing state: %s" % [name, Enums.EntityStates.keys()[state]])
    _state = state
    _state_entered = false
