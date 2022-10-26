class_name IntroUI extends CanvasLayer

var button_start: Button
var input_name: LineEdit

func _ready() -> void:
    button_start = get_node("%Start")
    input_name = get_node("%Name")

    button_start.connect("mouse_entered", self, "on_button_hover")
    input_name.connect("text_changed", self, "_name_changed")

    input_name.text = Globals.creature_name

func open() -> void:
    visible = true

func close() -> void:
    visible = false

func on_button_hover():
    Audio.play_sound_random([Globals.SFX.BUTTON_HOVER])

func _name_changed(new_text: String) -> void:
    if new_text.length() == 0:
        button_start.disabled = true
    else:
        button_start.disabled = false
        Globals.creature_name = new_text
