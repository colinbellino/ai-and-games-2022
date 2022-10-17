class_name Game extends Node

func _ready():
    Globals.title_ui.open()

func _process(_delta: float):
    if Input.is_action_just_released("ui_cancel"):
        quit_game()

func quit_game() -> void:
    print("[Game] Quitting...")
    get_tree().quit()
