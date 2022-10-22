class_name Entity extends Node

onready var sprite_body : Sprite = find_node("SpriteBody")

# Note: don't change this without using change_state()
var _state : int
var _state_entered : bool
var _state_exited : bool

func _ready() -> void:
    pass

func _process(_delta: float):
    if _state == Enums.EntityStates.Idle:
        if _state_entered == false:
            print("[ENTITY] %s doing nuffin (idle)" % [name])
            _state_entered = true

    if _state == Enums.EntityStates.Asleep:
        if _state_entered == false:
            print("[ENTITY] %s fell asleep" % [name])
            _state_entered = true

func clicked() -> void:
    print("[ENTITY] %s clicked" % [name])

func stimulus_entered(area: EntityArea2D) -> void:
    print("[ENTITY] %s entered | source: %s | stimulus: %s" % [name, area.source, area.stimulus])

func stimulus_exited(area: EntityArea2D) -> void:
    print("[ENTITY] %s exited | source: %s | stimulus: %s" % [name, area.source, area.stimulus])

func change_state(state: int) -> void:
    print("[ENTITY] %s changing state: %s" % [name, Enums.EntityStates.keys()[state]])
    _state = state
    _state_entered = false
