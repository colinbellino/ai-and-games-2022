class_name Game extends Node

var initialized : bool

enum GameStates { INIT, TITLE, INTRO, PLAY }

func _ready() -> void:
    print("[Game] ready: ", Globals.initialized)
    if Globals.initialized == false:
        return

    init()

func init():
    OS.set_window_title(Globals.game_names[Globals.random.randi() % Globals.game_names.size()])

    Globals.set_cursor(Globals.CURSORS.DEFAULT)

    # Connect the UI
    Globals.ui_title.button_start.connect("pressed", self, "button_start_pressed")
    Globals.ui_title.button_continue.connect("pressed", self, "button_continue_pressed")
    Globals.ui_title.button_settings.connect("pressed", self, "button_settings_pressed")
    Globals.ui_title.button_quit.connect("pressed", self, "button_quit_pressed")
    Globals.ui_debug.version_label.text = Globals.version

    Globals.ui_splash.visible = true
    yield(get_tree(), "idle_frame")
    Globals.ui_splash.visible = false

    change_state(GameStates.INTRO)

    initialized = true

func _process(delta: float):
    if initialized == false:
        return

    Globals.mouse_position = Globals.camera.get_local_mouse_position() / Globals.SPRITE_SIZE / Globals.SCALE
    Globals.mouse_closest_point = Globals.astar.get_closest_point(Globals.mouse_position - Globals.CELL_CENTER_OFFSET)
    Globals.time_elapsed += delta * 1000

    if Input.is_action_just_released("debug_1"):
        Globals.settings.debug_draw = !Globals.settings.debug_draw

    if Globals.game_state == GameStates.TITLE:
        if Globals.game_state_entered == false:
            Globals.game_state_entered = true

            Globals.ui_title.open()
            # Start playing menu music
            Audio.play_music(Globals.MUSIC.MENU)

        if Input.is_action_just_released("ui_cancel"):
            quit_game()
            return

    if Globals.game_state == GameStates.INTRO:
        if Globals.game_state_entered == false:
            Globals.game_state_entered = true

            var world_path := "res://media/maps/world_%s.ldtk" % [Globals.settings.level]
            var file := File.new()
            assert(file.file_exists(world_path), "Failed to load sprite frames: %s" % [world_path])

            var result = LDTK.load_ldtk(world_path)
            Globals.current_level = result[0]
            Globals.current_level_data = result[1]
            Globals.world.add_child(Globals.current_level)
            Globals.astar = LDTK.create_astar()
            Globals.entities_node = Globals.current_level.find_node("YSort_Entities", true, true)
            var entities_node_parent = Globals.entities_node.get_parent()
            var egg = find_node("Egg0", true, false)
            # egg.modulate = Globals.creature_color

            # Remove all entities for the duration of the intro
            Globals.entities_node.get_parent().remove_child(Globals.entities_node)

            if Globals.settings.debug_skip_title:
                Engine.time_scale = 20

            Audio.play_music(Globals.MUSIC.MENU)
            Globals.ui_intro.visible = true

            Globals.animation_player.play("Intro1")
            yield(Globals.animation_player, "animation_finished")

            Globals.ui_intro.animate_text()
            yield(Globals.ui_intro, "animate_text_finished")

            if Globals.settings.debug_skip_title == false:
                yield(Globals.ui_intro, "name_submitted")
            Globals.ui_intro.container_name.visible = false

            Audio.stop_music()

            Globals.animation_player.play("Intro2")
            yield(Globals.animation_player, "animation_finished")

            # Add them back before starting the game
            entities_node_parent.add_child(Globals.entities_node)

            LDTK.update_entities(Globals.entities_node)
            assert(Globals.creature != null, "No creature found in the level, did we forget to add one?")

            var point = Globals.astar.get_closest_point(egg.position / Globals.SPRITE_SIZE)
            Globals.astar.set_point_disabled(point, true)
            Globals.ui_intro.visible = false

            Engine.time_scale = 1

            yield(get_tree(), "idle_frame")

            start_game()

    if Globals.game_state == GameStates.PLAY:
        if Globals.game_state_entered == false:
            Globals.game_state_entered = true

        if Input.is_action_just_released("debug_2"):
            Globals.ending()

        if Globals.ui_settings.visible:
            Engine.time_scale = 0

            if Input.is_action_just_released("ui_cancel"):
                Globals.ui_settings.close()

        else:
            if Input.is_key_pressed(KEY_SHIFT):
                Engine.time_scale = 10
            else:
                Engine.time_scale = 1

            if Input.is_action_just_released("ui_cancel"):
                Globals.ui_settings.open(true)
                Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

            Globals.creature_closest_point = Globals.astar.get_closest_point(Globals.creature.position / Globals.SPRITE_SIZE)

            Globals.ui_debug.dump_label.text = JSON.print({
                "time_scale": "x%s" % [Engine.time_scale],
                "time_elapsed": Globals.time_elapsed,
                "creature_name": Globals.creature_name,
                "creature_state": Enums.EntityStates.keys()[Globals.creature._state],
                "emotion": Globals.emotion,
                "hunger": Globals.hunger,
                "delta": delta,
            }, "  ")

static func button_start_pressed() -> void:
    # start_game()
    pass

static func button_continue_pressed() -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
    Globals.ui_title.close()

static func button_settings_pressed() -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
    Globals.ui_settings.open()

static func button_quit_pressed() -> void:
    quit_game()

static func start_game() -> void:
    Globals.ui_title.close()
    Globals.ui_play.open()
    Audio.play_music(Globals.MUSIC.CALM)

    Globals.world.find_node("IntroStuff").visible = false

    change_state(GameStates.PLAY)

    var entity : Entity = Globals.creature
    var start_point : int = Globals.astar.get_closest_point(Vector2(7, 2))
    var destination_point : int = Globals.astar.get_closest_point(Vector2(7, 3))
    var path = Globals.astar.get_point_path(start_point, destination_point)
    var speed = LDTK.get_behaviour_meta(entity, "Roaming", "Speed", 16.0)
    entity.set_meta("moving_path", path)
    entity.set_meta("moving_speed", speed)
    entity.change_state(Enums.EntityStates.Moving)

    entity.set_meta("EntityAnimation_Color", Globals.creature_color)

    # TODO: Hide the creature, play the egg cracking anim, then show the creature
    var _egg_entity = Globals.spawn_entity(Globals.egg_prefab, entity.position)
    # _egg_entity.set_meta("EntityAnimation_Color", Globals.creature_color)

static func change_state(state) -> void:
    print("[Game] Changing state: %s" % [GameStates.keys()[state]])
    Globals.game_state = state
    Globals.game_state_entered = false

static func quit_game() -> void:
    print("[Game] Quitting...")
    Save.write_settings(Globals.settings)
    Globals.get_tree().quit()
