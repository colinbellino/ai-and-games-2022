class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: Label
var hunger_progress: TextureProgress
var settings_button: TextureButton
var feed_button: Button

func _ready() -> void:
    container_control = get_node("%Container")
    label_name = get_node("%NameLabel")
    hunger_progress = get_node("%HungerProgress")
    settings_button = get_node("%SettingsButton")
    feed_button = get_node("%FeedButton")

    settings_button.connect("pressed", self, "settings_button_pressed")
    feed_button.connect("pressed", self, "feed_button_pressed")
    feed_button.connect("mouse_entered", self, "feed_button_mouse_entered")
    feed_button.connect("mouse_exited", self, "feed_button_mouse_exited")

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

func feed_button_pressed() -> void:
    var amount : int = LDTK.get_behaviour_meta(Globals.creature, "FoodSource", "Amount", 10)
    Audio.play_sound(Globals.SFX.BUTTON_CLICK_1, Globals.creature.position)
    Globals.creature.emit_signal("fed", amount)

func feed_button_mouse_entered() -> void:
    Globals.set_cursor(Globals.CURSORS.HAND)

func feed_button_mouse_exited() -> void:
    Globals.set_cursor(Globals.CURSORS.DEFAULT)
