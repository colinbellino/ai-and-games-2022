class_name TitleUI extends CanvasLayer

var version_label: Label
var button_start: Button
var button_continue: Button
var button_settings: Button
var button_quit: Button

func _ready() -> void:
    version_label = get_node("%Version")
    button_start = get_node("%Start")
    button_continue = get_node("%Continue")
    button_settings = get_node("%Settings")
    button_quit = get_node("%Quit")

    var _result := button_start.connect("mouse_entered", self, "on_button_hover")
    _result = button_settings.connect("mouse_entered", self, "on_button_hover")
    _result = button_quit.connect("mouse_entered", self, "on_button_hover")

    close()

func open(version: String) -> void:
    version_label.text = version
    button_start.grab_focus()
    visible = true

func close() -> void:
    visible = false

func on_button_hover():
    Globals.play_sfx(Globals.SFX.BUTTON_HOVER)
