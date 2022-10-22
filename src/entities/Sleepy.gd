class_name Sleepy extends Node

onready var entity : Entity = get_parent()

var timer_start : int
var sleep_delay_in_ms : int = 5000

func _ready() -> void:
    var _result = entity.connect("state_entered", self, "entity_state_entered")

func _exit_tree() -> void:
    entity.disconnect("state_entered", self, "entity_state_entered")

func _process(_delta: float) -> void:
    if entity._state == Enums.EntityStates.Idle:
        if OS.get_ticks_msec() >= timer_start + sleep_delay_in_ms:
            entity.change_state(Enums.EntityStates.Asleep)

func entity_state_entered(state: int) -> void:
    if state == Enums.EntityStates.Idle:
        timer_start = OS.get_ticks_msec()
