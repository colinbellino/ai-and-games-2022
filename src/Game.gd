class_name Game extends Node

enum GameStates { INIT, TITLE, PLAY }

func _ready():
    # Init stuff here
    Globals.settings = Save.read_settings()
    Globals.bus_main = AudioServer.get_bus_index("Master")
    Globals.bus_music = AudioServer.get_bus_index("Music")
    Globals.bus_sound = AudioServer.get_bus_index("Sound")
    Globals.world = get_node("%World")
    Globals.ui_title = get_node("%TitleUI")
    Globals.ui_settings = get_node("%SettingsUI")
    Globals.camera = get_node("%MainCamera")
    Globals.version = load_version()
    Globals.can_fullscreen = OS.get_name() == "Windows"

    if Globals.can_fullscreen:
        Globals.set_fullscreen(Globals.settings.window_fullscreen)
    Globals.set_resolution(Globals.settings.resolution_index)
    Globals.set_linear_db(Globals.bus_main, Globals.settings.volume_main)
    Globals.set_linear_db(Globals.bus_music, Globals.settings.volume_music)
    Globals.set_linear_db(Globals.bus_sound, Globals.settings.volume_sound)
    TranslationServer.set_locale(Globals.settings.locale)

    # Connect the UI
    var _result := Globals.ui_title.button_start.connect("pressed", self, "button_start_pressed")
    _result = Globals.ui_title.button_continue.connect("pressed", self, "button_continue_pressed")
    _result = Globals.ui_title.button_settings.connect("pressed", self, "button_settings_pressed")
    _result = Globals.ui_title.button_quit.connect("pressed", self, "button_quit_pressed")

    if Globals.settings.skip_title:
        button_start_pressed()
    else:
        # Start the title
        yield(get_tree(), "idle_frame") # Wait for next frame before initializing the UI
        Globals.ui_title.open(Globals.version)
        change_state(GameStates.TITLE)

        # Start playing menu music - temp placeholder, will cleanup and migrate music management
        # NOTE: can't start/stop music from the static functions - I'll work on some kind of management scheme
        #       on Sunday.
        var audio_stream: AudioStreamOGGVorbis = preload("res://media/audio/ui/menu.ogg") # <-- this didn't accept a const string from Globals.gd :(
        audio_stream.set_loop(true)
        $MusicPlayer.stream = audio_stream
        $MusicPlayer.play()

func _process(delta: float):
    if Input.is_action_just_released("ui_cancel"):
        quit_game()
        return

    if Globals.game_state == GameStates.TITLE:
        if Input.is_action_just_released("debug_1"):
            start_game(0)
        if Input.is_action_just_released("debug_2"):
            start_game(1)
        if Input.is_action_just_released("debug_3"):
            start_game(2)
        if Input.is_action_just_released("debug_4"):
            start_game(3)
        if Input.is_action_just_released("debug_5"):
            start_game(4)
        if Input.is_action_just_released("debug_6"):
            start_game(5)
        if Input.is_action_just_released("debug_7"):
            start_game(6)
        if Input.is_action_just_released("debug_8"):
            start_game(7)
        if Input.is_action_just_released("debug_9"):
            start_game(8)
        if Input.is_action_just_released("debug_10"):
            start_game(10)
        if Input.is_action_just_released("debug_11"):
            start_game(11)
        if Input.is_action_just_released("debug_12"):
            start_game(12)

    if Globals.game_state == GameStates.PLAY:
        if Globals.game_state_entered == false:
            Globals.game_state_entered = true
            # Globals.creature.change_state(Enums.EntityStates.Asleep)

        Globals.camera.position = Globals.creature.position * Globals.world.scale - get_viewport().size / 2

        if Input.is_action_pressed("move_up"):
            Globals.camera.position.y -= 500.0 * delta
            # Globals.creature.position.y -= 120.0 * delta
        if Input.is_action_pressed("move_down"):
            Globals.camera.position.y += 500.0 * delta
            # Globals.creature.position.y += 120.0 * delta
        if Input.is_action_pressed("move_right"):
            Globals.camera.position.x += 500.0 * delta
            # Globals.creature.position.x += 120.0 * delta
        if Input.is_action_pressed("move_left"):
            Globals.camera.position.x -= 500.0 * delta
            # Globals.creature.position.x -= 120.0 * delta

static func button_start_pressed() -> void:
    start_game(Globals.settings.level)

static func button_continue_pressed() -> void:
    Globals.ui_title.close()

static func button_settings_pressed() -> void:
    Globals.ui_settings.open()

static func button_quit_pressed() -> void:
    quit_game()

static func start_game(world_id: int) -> void:
    Globals.ui_title.close()

    var world_path := "res://media/maps/world_%s.ldtk" % [world_id]
    var file := File.new()
    assert(file.file_exists(world_path), "Failed to load sprite frames: %s" % [world_path])

    Globals.current_level = LDTK.load_ldtk(world_path)
    Globals.world.add_child(Globals.current_level)
    LDTK.update_entities(Globals.current_level.find_node("Entities"))

    assert(Globals.creature != null, "No creature found in the level, did we forget to add one?")

    change_state(GameStates.PLAY)

static func change_state(state) -> void:
    print("[Game] Changing state: %s" % [GameStates.keys()[state]])
    Globals.game_state = state
    Globals.game_state_entered = false

static func quit_game() -> void:
    print("[Game] Quitting...")
    Globals.get_tree().quit()

static func load_version() -> String:
    var file := File.new()
    var result := file.open("res://version.txt", File.READ)
    if result != OK:
        print("[Game] Couldn't load version.")
        file.close()
        return "1111111"

    var data = file.get_as_text()
    file.close()
    return data
