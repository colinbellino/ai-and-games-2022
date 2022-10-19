class_name SettingsUI extends CanvasLayer

var button_fullscreen: CheckButton
var button_resolution: OptionButton
var button_close: Button

func _ready() -> void:
    button_fullscreen = get_node("%Fullscreen")
    button_resolution = get_node("%Resolution")
    for item in Globals.resolutions:
        button_resolution.add_item(item[0])
    button_close = get_node("%Close")

    var _result = button_fullscreen.connect("pressed", self, "button_fullscreen_pressed")
    _result = button_resolution.connect("item_selected", self, "button_resolution_item_selected")

    close()

func open() -> void:
    visible = true

func close() -> void:
    visible = false

func button_fullscreen_pressed() -> void:
    Globals.settings.window_fullscreen = !Globals.settings.window_fullscreen
    OS.window_fullscreen = Globals.settings.window_fullscreen

func button_resolution_item_selected(resolution_index: int) -> void:
    Globals.settings.resolution_index = resolution_index
    Globals.set_resolution(Globals.settings.resolution_index)
