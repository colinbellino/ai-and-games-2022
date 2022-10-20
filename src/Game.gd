class_name Game extends Node

func _ready():
    # Init stuff here
    Globals.settings = Save.read_settings()
    Globals.bus_main = AudioServer.get_bus_index("Master")
    Globals.bus_music = AudioServer.get_bus_index("Music")
    Globals.bus_sound = AudioServer.get_bus_index("Sound")
    Globals.ui_title = get_node("%TitleUI")
    Globals.ui_settings = get_node("%SettingsUI")
    Globals.version = load_version()
    Globals.can_fullscreen = OS.get_name() == "Windows"

    if Globals.can_fullscreen:
        Globals.set_fullscreen(Globals.settings.window_fullscreen)
    Globals.set_resolution(Globals.settings.resolution_index)

    # Connect the UI
    var _result = Globals.ui_title.button_start.connect("pressed", self, "button_start_pressed")
    _result = Globals.ui_title.button_continue.connect("pressed", self, "button_continue_pressed")
    _result = Globals.ui_title.button_settings.connect("pressed", self, "button_settings_pressed")
    _result = Globals.ui_title.button_quit.connect("pressed", self, "button_quit_pressed")

    # Start the title
    yield(get_tree(), "idle_frame") # Wait for next frame before initializing the UI
    Globals.ui_title.open(Globals.version)

func _process(_delta: float):
    if Input.is_action_just_released("ui_cancel"):
        quit_game()

func button_start_pressed() -> void:
    Globals.ui_title.close()

func button_continue_pressed() -> void:
    Globals.ui_title.close()

func button_settings_pressed() -> void:
    Globals.ui_settings.open()

func quit_game() -> void:
    print("[GAME] Quitting...")
    get_tree().quit()

func button_quit_pressed() -> void:
    quit_game()

static func load_version() -> String:
    var file := File.new()
    var result := file.open("res://version.txt", File.READ)
    if result != OK:
        print("[GAME] Couldn't load version.")
        file.close()
        return "1111111"

    var data = file.get_as_text()
    file.close()
    return data
