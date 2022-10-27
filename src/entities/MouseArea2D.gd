class_name MouseArea2D extends Area2D

onready var entity  = get_parent()

func _ready() -> void:
    yield(get_tree(), "idle_frame")
    connect("input_event", self, "on_input_event")
    connect("mouse_entered", self, "on_mouse_entered")
    connect("mouse_exited", self, "on_mouse_exited")

func _exit_tree() -> void:
    if is_connected("mouse_entered", self, "on_mouse_entered"):
        disconnect("mouse_entered", self, "on_mouse_entered")
    if is_connected("mouse_exited", self, "on_mouse_exited"):
        disconnect("mouse_exited", self, "on_mouse_exited")

func on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseMotion:
        pass # We could do something with mouseovers here

    if event.is_action_released("mouse_left"):
        entity.interact(0)
    elif event.is_action_released("mouse_right"):
        entity.interact(1)

func on_mouse_entered() -> void:
    Globals.set_cursor(Globals.CURSORS.HAND)
    entity.emit_signal("area_entered", self)

func on_mouse_exited() -> void:
    Globals.set_cursor(Globals.CURSORS.DEFAULT)
    entity.emit_signal("area_exited", self)
