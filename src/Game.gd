class_name Game extends Node

enum GameStates { INIT, TITLE, PLAY }

func _ready():
    # Connect the UI
    Globals.ui_title.button_start.connect("pressed", self, "button_start_pressed")
    Globals.ui_title.button_continue.connect("pressed", self, "button_continue_pressed")
    Globals.ui_title.button_settings.connect("pressed", self, "button_settings_pressed")
    Globals.ui_title.button_quit.connect("pressed", self, "button_quit_pressed")
    Globals.ui_debug.version_label.text = Globals.version

    if Globals.settings.debug_skip_title:
        button_start_pressed()
    else:
        # Start the title
        yield(get_tree(), "idle_frame") # Wait for next frame before initializing the UI
        Globals.ui_title.open()
        change_state(GameStates.TITLE)

        # Start playing menu music
        Audio.play_music(Globals.MUSIC.MENU)

func _process(delta: float):
    Globals.mouse_position = Globals.camera.get_local_mouse_position() / Globals.SPRITE_SIZE / Globals.SCALE

    if Input.is_action_just_released("debug_1"):
        Globals.settings.debug_draw = !Globals.settings.debug_draw

    if Input.is_action_just_released("ui_cancel"):
        quit_game()
        return

    if Globals.game_state == GameStates.TITLE:
        pass
        # if Input.is_action_just_released("debug_1"):
        #     start_game(0)
        # if Input.is_action_just_released("debug_2"):
        #     start_game(1)
        # if Input.is_action_just_released("debug_3"):
        #     start_game(2)
        # if Input.is_action_just_released("debug_4"):
        #     start_game(3)
        # if Input.is_action_just_released("debug_5"):
        #     start_game(4)
        # if Input.is_action_just_released("debug_6"):
        #     start_game(5)
        # if Input.is_action_just_released("debug_7"):
        #     start_game(6)
        # if Input.is_action_just_released("debug_8"):
        #     start_game(7)
        # if Input.is_action_just_released("debug_9"):
        #     start_game(8)
        # if Input.is_action_just_released("debug_10"):
        #     start_game(10)
        # if Input.is_action_just_released("debug_11"):
        #     start_game(11)
        # if Input.is_action_just_released("debug_12"):
        #     start_game(12)

    if Globals.game_state == GameStates.PLAY:
        if Globals.game_state_entered == false:
            Globals.game_state_entered = true
            # Globals.creature.change_state(Enums.EntityStates.Asleep)

        if Input.is_key_pressed(KEY_SHIFT):
            Engine.time_scale = 10
        else:
            Engine.time_scale = 1

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

        Globals.ui_debug.dump_label.text = JSON.print({
            "creature_name": Globals.creature_name,
            "time_scale": "x%s" % [Engine.time_scale],
            "creature_state": Enums.EntityStates.keys()[Globals.creature._state],
            "emotion": Globals.emotion,
            "hunger": Globals.hunger,
        }, "  ")

static func button_start_pressed() -> void:
    start_game(Globals.settings.level)

static func button_continue_pressed() -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_1, Globals.SFX.BUTTON_CLICK_2])
    Globals.ui_title.close()

static func button_settings_pressed() -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_1, Globals.SFX.BUTTON_CLICK_2])
    Globals.ui_settings.open()

static func button_quit_pressed() -> void:
    quit_game()

static func start_game(world_id: int) -> void:
    Globals.ui_title.close()
    Audio.play_music(Globals.MUSIC.CALM)

    var world_path := "res://media/maps/world_%s.ldtk" % [world_id]
    var file := File.new()
    assert(file.file_exists(world_path), "Failed to load sprite frames: %s" % [world_path])

    var result = LDTK.load_ldtk(world_path)
    Globals.current_level = result[0]
    Globals.current_level_data = result[1]
    Globals.world.add_child(Globals.current_level)
    LDTK.update_entities(Globals.current_level.find_node("Entities"))
    Globals.astar = LDTK.create_astar()

    assert(Globals.creature != null, "No creature found in the level, did we forget to add one?")

    change_state(GameStates.PLAY)

static func change_state(state) -> void:
    print("[Game] Changing state: %s" % [GameStates.keys()[state]])
    Globals.game_state = state
    Globals.game_state_entered = false

static func quit_game() -> void:
    print("[Game] Quitting...")
    Globals.get_tree().quit()
