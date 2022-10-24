class_name TitleUI extends CanvasLayer

var button_start: Button
var button_continue: Button
var button_settings: Button
var button_quit: Button

func _ready() -> void:
    button_start = get_node("%Start")
    button_continue = get_node("%Continue")
    button_settings = get_node("%Settings")
    button_quit = get_node("%Quit")

    button_start.connect("mouse_entered", self, "on_button_hover")
    button_settings.connect("mouse_entered", self, "on_button_hover")
    button_quit.connect("mouse_entered", self, "on_button_hover")

    close()

func open() -> void:
    button_start.grab_focus()
    visible = true

func close() -> void:
    visible = false

func on_button_hover():
    Audio.play_sound_random([Globals.SFX.BUTTON_HOVER])
