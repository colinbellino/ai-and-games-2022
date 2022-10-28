class_name OutroUI extends CanvasLayer

var menu : Control
var quit_button : Button
var restart_button : Button

func _ready() -> void:
    menu = get_node("%Menu")
    quit_button = get_node("%Quit")
    restart_button = get_node("%Restart")

    quit_button.connect("pressed", self, "button_quit_pressed")
    quit_button.connect("pressed", self, "play_button_sound")
    restart_button.connect("pressed", self, "button_restart_pressed")
    restart_button.connect("pressed", self, "play_button_sound")

func button_quit_pressed() -> void:
    Game.quit_game()

func button_restart_pressed() -> void:
    menu.modulate.a = 0.0
    var tween := create_tween()
    tween.tween_property(menu, "modulate:a", 0.0, 0.5)
    yield(tween, "finished")

    Globals.restart_game()

func play_button_sound(_whatever = null) -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

func open() -> void:
    menu.visible = true
