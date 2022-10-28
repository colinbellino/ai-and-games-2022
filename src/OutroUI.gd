class_name OutroUI extends CanvasLayer


func _ready() -> void:
    $"%Quit".connect("pressed", self, "button_quit_pressed")
    $"%Quit".connect("pressed", self, "play_button_sound")

func _show_menu():
    $"%Menu".visible = true

func button_quit_pressed() -> void:
    Save.write_settings(Globals.settings)
    Game.quit_game()

func play_button_sound(_whatever = null) -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_1, Globals.SFX.BUTTON_CLICK_2])

func play() -> void:
    var pos = Globals.creature.position
    var box = Rect2(pos - Vector2(25,-25), Vector2(50,50))

    var tween = get_tree().create_tween()
    tween.tween_property($"%BorderTop", "rect_position", Vector2(0, $"%BorderTop".rect_position.y + box.position.y), 1)
    tween.tween_property($"%BorderLeft", "rect_position",  Vector2($"%BorderLeft".rect_position.x + box.position.x, 0), 1)
    tween.tween_property($"%BorderRight", "rect_position",  Vector2($"%BorderRight".rect_position.x - box.end.x, 0), 1)
    tween.tween_property($"%BorderBottom", "rect_position",  Vector2(0,$"%BorderBottom".rect_position.y - box.end.y), 1)
    tween.tween_callback(self, "_show_menu")
