class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: Label
var hunger_progress: TextureProgress
var settings_button: TextureButton

func _ready() -> void:
    container_control = get_node("%Container")
    label_name = get_node("%NameLabel")
    hunger_progress = get_node("%HungerProgress")
    settings_button = get_node("%SettingsButton")

    settings_button.connect("pressed", self, "settings_button_pressed")

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

func settings_button_pressed() -> void:
    Globals.ui_settings.open(true)
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_1, Globals.SFX.BUTTON_CLICK_2])
