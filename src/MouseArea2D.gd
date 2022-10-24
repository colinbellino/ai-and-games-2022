class_name MouseArea2D extends Area2D

onready var entity = get_parent()

func _ready() -> void:
    connect("input_event", self, "on_input_event")

func on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseMotion:
        pass # We could do something with mouseovers here

    if event.is_action_released("mouse_left"):
        entity.interact(0)
    elif event.is_action_released("mouse_right"):
        entity.interact(1)
