class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: Label
var avatar_sprite: Sprite

func _ready() -> void:
    container_control = get_node("%Container")
    label_name = get_node("%NameLabel")
    avatar_sprite = get_node("%Avatar")

    close()

func open() -> void:
    label_name.text = Globals.creature_name
    visible = true

    breakpoint
    var tween := container_control.create_tween()
    tween.tween_property(container_control, "rect_position:y", 0.0, 0.3)
    yield(tween, "finished")

func close() -> void:
    var tween := container_control.create_tween()
    tween.tween_property(container_control, "rect_position:y", -container_control.rect_size.y, 0.2)
    yield(tween, "finished")

    visible = false
