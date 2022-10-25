class_name TitleUI extends CanvasLayer

var button_start: Button
var button_continue: Button
var button_settings: Button
var button_quit: Button
var input_name: LineEdit

func _ready() -> void:
    button_start = get_node("%Start")
    button_continue = get_node("%Continue")
    button_settings = get_node("%Settings")
    button_quit = get_node("%Quit")
    input_name = get_node("%Name")

    button_start.connect("mouse_entered", self, "on_button_hover")
    button_settings.connect("mouse_entered", self, "on_button_hover")
    button_quit.connect("mouse_entered", self, "on_button_hover")
    input_name.connect("text_changed", self, "_name_changed")

    input_name.text = Globals.creature_name

    close()

func open() -> void:
    button_start.grab_focus()
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
