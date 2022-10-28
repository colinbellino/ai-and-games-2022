class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: Label
var hunger_progress: TextureProgress
var settings_button: TextureButton
var feed_button: Button
var feed_sprite: Sprite
var next_feed : float
var mood_progress : TextureProgress
var mood_sprite : Sprite

func _ready() -> void:
    container_control = get_node("%Container")
    label_name = get_node("%NameLabel")
    hunger_progress = get_node("%HungerProgress")
    settings_button = get_node("%SettingsButton")
    feed_button = get_node("%FeedButton")
    feed_sprite = get_node("%FeedSprite")
    mood_progress = get_node("%MoodProgress")
    mood_sprite = get_node("%MoodSprite")

    settings_button.connect("pressed", self, "settings_button_pressed")
    settings_button.connect("mouse_entered", self, "button_mouse_entered")
    settings_button.connect("mouse_exited", self, "button_mouse_exited")
    feed_button.connect("pressed", self, "feed_button_pressed")
    feed_button.connect("mouse_entered", self, "button_mouse_entered")
    feed_button.connect("mouse_exited", self, "button_mouse_exited")

    close()

func _process(_delta: float) -> void:
    feed_button.disabled = Globals.time_elapsed < next_feed
    feed_sprite.modulate.a = 0.3 if Globals.time_elapsed < next_feed else 1.0
    hunger_progress.value = Globals.hunger / float(Globals.HUNGER_MAX) * 100.0
    mood_progress.value = (Globals.emotion.x + 1.0) * 50.0
    if Globals.emotion.x <= -0.5:
        mood_sprite.region_rect.position.x = 0
    if Globals.emotion.x >= 0.5:
        mood_sprite.region_rect.position.x = 32
    if Globals.emotion.x > -0.5 && Globals.emotion.x < 0.5:
        mood_sprite.region_rect.position.x = 16

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

func settings_button_pressed() -> void:
    Globals.ui_settings.open(true)
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

func feed_button_pressed() -> void:
    if Globals.time_elapsed >= next_feed:
        var amount : int = LDTK.get_behaviour_meta(Globals.creature, "FoodSource", "Amount", 30)
        Audio.play_sound(Globals.SFX.BUTTON_CLICK_1, Globals.creature.position)
        Globals.creature.emit_signal("fed", amount)
        next_feed = Globals.time_elapsed + 5000.0
        Globals.set_cursor(Globals.CURSORS.DEFAULT)

func button_mouse_entered() -> void:
    Globals.set_cursor(Globals.CURSORS.HAND)

func button_mouse_exited() -> void:
    Globals.set_cursor(Globals.CURSORS.DEFAULT)
