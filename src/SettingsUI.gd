class_name SettingsUI extends CanvasLayer

var button_fullscreen: CheckButton
var button_resolution: OptionButton
var button_locale: OptionButton
var button_close: Button
var button_quit: Button
var slider_volume_main : Slider
var slider_volume_music : Slider
var slider_volume_sound : Slider

func _ready() -> void:
    button_fullscreen = get_node("%Fullscreen")
    button_resolution = get_node("%Resolution")
    button_locale = get_node("%Locale")
    button_close = get_node("%Close")
    button_quit = get_node("%Quit")
    slider_volume_main = get_node("%VolumeMain")
    slider_volume_music = get_node("%VolumeMusic")
    slider_volume_sound = get_node("%VolumeSound")

    button_fullscreen.connect("pressed", self, "button_fullscreen_pressed")
    button_fullscreen.connect("pressed", self, "play_button_sound")
    button_resolution.connect("item_selected", self, "button_resolution_item_selected")
    button_resolution.connect("item_selected", self, "play_button_sound")
    button_locale.connect("item_selected", self, "button_locale_item_selected")
    button_locale.connect("item_selected", self, "play_button_sound")
    button_close.connect("pressed", self, "button_close_pressed")
    button_close.connect("pressed", self, "play_button_sound")
    button_quit.connect("pressed", self, "button_quit_pressed")
    button_quit.connect("pressed", self, "play_button_sound")
    slider_volume_main.connect("value_changed", self, "slider_volume_main_changed")
    slider_volume_main.connect("value_changed", self, "play_button_sound")
    slider_volume_music.connect("value_changed", self, "slider_volume_music_changed")
    slider_volume_music.connect("value_changed", self, "play_button_sound")
    slider_volume_sound.connect("value_changed", self, "slider_volume_sound_changed")
    slider_volume_sound.connect("value_changed", self, "play_button_sound")

    close()

func open(show_quit_button: bool = false) -> void:
    button_fullscreen.visible = false
    if Globals.can_fullscreen:
        button_fullscreen.visible = true
        button_fullscreen.pressed = Globals.settings.window_fullscreen

    button_resolution.visible = false
    if Globals.can_change_resolution:
        button_resolution.visible = true
        button_resolution.clear()
        for item in Globals.resolutions:
            button_resolution.add_item(item[0])
        button_resolution.selected = Globals.settings.resolution_index

    slider_volume_main.value = Globals.settings.volume_main
    slider_volume_music.value = Globals.settings.volume_music
    slider_volume_sound.value = Globals.settings.volume_sound

    var locales := TranslationServer.get_loaded_locales()
    button_locale.clear()
    for locale in locales:
        button_locale.add_item("locale_" + locale)
    button_locale.selected = locales.find(Globals.settings.locale)

    button_fullscreen.grab_focus()

    button_quit.visible = false
    if show_quit_button:
        button_quit.visible = true

    visible = true

func close() -> void:
    visible = false

func button_fullscreen_pressed() -> void:
    Globals.settings.window_fullscreen = !Globals.settings.window_fullscreen
    Globals.set_fullscreen(Globals.settings.window_fullscreen)

func button_resolution_item_selected(resolution_index: int) -> void:
    Globals.settings.resolution_index = resolution_index
    Globals.set_resolution(Globals.settings.resolution_index)

func button_locale_item_selected(locale_index: int) -> void:
    var locales := TranslationServer.get_loaded_locales()
    Globals.settings.locale = locales[locale_index]
    TranslationServer.set_locale(Globals.settings.locale)

func button_close_pressed() -> void:
    Save.write_settings(Globals.settings)
    close()

func button_quit_pressed() -> void:
    Save.write_settings(Globals.settings)
    Game.quit_game()

func slider_volume_main_changed(value: float) -> void:
    Globals.settings.volume_main = value
    Globals.set_linear_db(Globals.bus_main, Globals.settings.volume_main)
    # print("bus_main: ", [Globals.get_linear_db(Globals.bus_main), AudioServer.get_bus_volume_db(Globals.bus_main)])

func slider_volume_music_changed(value: float) -> void:
    Globals.settings.volume_music = value
    Globals.set_linear_db(Globals.bus_music, Globals.settings.volume_music)
    # print("bus_music: ", [Globals.get_linear_db(Globals.bus_music), AudioServer.get_bus_volume_db(Globals.bus_music)])

func slider_volume_sound_changed(value: float) -> void:
    Globals.settings.volume_sound = value
    Globals.set_linear_db(Globals.bus_sound, Globals.settings.volume_sound)
    # print("bus_sound: ", [Globals.get_linear_db(Globals.bus_sound), AudioServer.get_bus_volume_db(Globals.bus_sound)])

func play_button_sound(_whatever = null) -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
