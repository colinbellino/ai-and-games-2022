class_name OutroUI extends CanvasLayer


func _ready() -> void:
	$"%Quit".connect("pressed", self, "button_quit_pressed")
	$"%Restart".connect("pressed", self, "button_restart_pressed")
	$"%Quit".connect("pressed", self, "play_button_sound")

func _show_menu():
	$"%Menu".visible = true

func button_quit_pressed() -> void:
	Save.write_settings(Globals.settings)
	Game.quit_game()

func button_restart_pressed() -> void:
	$"%Menu".visible = false
	Globals.ui_outro.visible = false
	Game.change_state(Game.GameStates.INTRO)

func play_button_sound(_whatever = null) -> void:
	Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_1, Globals.SFX.BUTTON_CLICK_2])

func play() -> void:
	Globals.ui_outro.visible = true
	var scale = 128
	var pos = Globals.creature.global_position
	var box = Rect2(Vector2(pos.x - scale, pos.y - scale), Vector2(scale,scale))
	var top = $"%BorderTop".rect_position.y + box.position.y
	var left = $"%BorderLeft".rect_position.x + box.position.x
	var right = $"%BorderRight".rect_position.x - box.end.x
	var bottom = $"%BorderBottom".rect_position.y - box.end.y

	print(box.position, box.end, ",", top, ",", left, ",", right, ",", bottom)

	var tween = get_tree().create_tween()
	tween.parallel().tween_property($"%BorderTop", "rect_position", Vector2(0, top), 1)
	tween.parallel().tween_property($"%BorderLeft", "rect_position",  Vector2(left, 0), 1)
	tween.parallel().tween_property($"%BorderRight", "rect_position",  Vector2(right, 0), 1)
	tween.parallel().tween_property($"%BorderBottom", "rect_position",  Vector2(0, bottom), 1)
	tween.tween_callback(self, "_show_menu")
