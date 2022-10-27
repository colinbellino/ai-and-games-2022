class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: Label
var avatar_sprite: Sprite
var hunger_progress: TextureProgress

func _ready() -> void:
    container_control = get_node("%Container")
    label_name = get_node("%NameLabel")
    avatar_sprite = get_node("%Avatar")
    hunger_progress = get_node("%HungerProgress")

    close()

func open() -> void:
    label_name.text = Globals.creature_name
    visible = true

    var tween := container_control.create_tween()
    tween.tween_property(container_control, "rect_position:y", 0.0, 0.3)
    yield(tween, "finished")

func close() -> void:
    var tween := container_control.create_tween()
    tween.tween_property(container_control, "rect_position:y", -container_control.rect_size.y, 0.2)
    yield(tween, "finished")

    visible = false

func _process(_delta: float) -> void:
    hunger_progress.value = Globals.hunger / float(Hunger.HUNGER_MAX) * 100.0
