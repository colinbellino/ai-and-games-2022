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

    close()

func open(version: String) -> void:
    version_label.text = version
    visible = true

func close() -> void:
    visible = false
