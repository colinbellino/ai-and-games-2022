class_name TitleUI extends CanvasLayer

var button_start: Button
var button_continue: Button
var button_quit: Button

func _ready() -> void:
    button_start = get_node("%Start")
    button_continue = get_node("%Continue")
    button_quit = get_node("%Quit")

func open() -> void:
    visible = true

func close() -> void:
    visible = false
