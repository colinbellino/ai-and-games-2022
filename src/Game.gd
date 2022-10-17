class_name Game extends Node

func _ready():
    # Init stuff here
    Globals.title_ui = get_node("%Title")
    Globals.version = load_version()

    # Connect the UI
    var _result = Globals.title_ui.button_start.connect("pressed", self, "button_start_pressed")
    _result = Globals.title_ui.button_continue.connect("pressed", self, "button_continue_pressed")
    _result = Globals.title_ui.button_quit.connect("pressed", self, "button_quit_pressed")

    # Start the title
    Globals.title_ui.open(Globals.version)

func _process(_delta: float):
    if Input.is_action_just_released("ui_cancel"):
        quit_game()

func button_start_pressed() -> void:
    print("[GAME] button_start_pressed")
    Globals.title_ui.close()

func button_continue_pressed() -> void:
    print("[GAME] button_start_pressed")
    Globals.title_ui.close()

func quit_game() -> void:
    print("[GAME] Quitting...")
    get_tree().quit()

func button_quit_pressed() -> void:
    quit_game()

func load_version() -> String:
    var file := File.new()
    var result := file.open("res://version.txt", File.READ)
    if result != OK:
        print("[GAME] Couldn't load version.")
        file.close()
        return "1111111"

    var data = file.get_as_text()
    file.close()
    return data
