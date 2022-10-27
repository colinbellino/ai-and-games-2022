class_name IntroUI extends CanvasLayer

var button_start: Button
var input_name: LineEdit
var label_message0: Label
var label_name: Label
var label_name_text : String
var label_message0_text : String
var container_name : Control

signal animate_text_finished()
signal name_submitted()

func _ready() -> void:
    button_start = get_node("%Start")
    input_name = get_node("%Name")
    label_message0 = get_node("%Message0")
    label_name = get_node("%NameLabel")
    container_name = get_node("%NameContainer")

    button_start.connect("mouse_entered", self, "on_button_hover")

    input_name.connect("text_entered", self, "_name_entered")
    input_name.text = ""

    label_name_text = tr(label_name.text)
    label_name.text = ""

    label_message0_text = tr(label_message0.text)
    label_message0.text = ""

func animate_message0() -> void:
    label_message0.text = ""
    for letter in label_message0_text:
        label_message0.text += letter
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")

    yield(get_tree().create_timer(5), "timeout")

    var tween := create_tween()
    tween.tween_property(label_message0, "modulate:a", 0.0, 0.2)
    yield(tween, "finished")
    label_message0.text = ""
    label_message0.modulate.a = 1.0

func animate_text() -> void:
    container_name.visible = true

    label_name.text = ""
    for letter in label_name_text:
        label_name.text += letter
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")

    input_name.text = ""
    for letter in Globals.creature_name:
        input_name.append_at_cursor(letter)
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY), "timeout")
    input_name.grab_focus()

    emit_signal("animate_text_finished")

func play_danger_sound() -> void:
    Audio.play_sound(Globals.SFX.INTRO_DANGER)

func play_explosion_sound() -> void:
    Audio.play_sound(Globals.SFX.EXPLOSION_1)

func on_button_hover():
    Audio.play_sound_random([Globals.SFX.BUTTON_HOVER])

func _name_entered(new_text: String) -> void:
    if new_text.length() == 0 || new_text.length() > 32:
        button_start.disabled = true
    else:
        button_start.disabled = false
        Globals.creature_name = new_text

        var tween := create_tween()
        tween.tween_property(container_name, "modulate:a", 0.0, 0.2)
        yield(tween, "finished")
        container_name.visible = false
        container_name.modulate.a = 1.0

        emit_signal("name_submitted")
