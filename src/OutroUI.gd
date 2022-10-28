class_name OutroUI extends CanvasLayer

var menu : Control
var quit_button : Button

func _ready() -> void:
    menu = get_node("%Menu")
    quit_button = get_node("%Quit")

    quit_button.connect("pressed", self, "button_quit_pressed")
    quit_button.connect("pressed", self, "play_button_sound")

func button_quit_pressed() -> void:
    Game.quit_game()

func play_button_sound(_whatever = null) -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

func open() -> void:
    menu.visible = true
