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

func _process(delta: float):
    if Input.is_action_just_released("ui_cancel"):
        quit_game()
        return

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

        if Input.is_action_pressed("move_up"):
            Globals.camera.position.y -= 500.0 * delta
            Globals.creature.position.y -= 120.0 * delta
        if Input.is_action_pressed("move_down"):
            Globals.camera.position.y += 500.0 * delta
            Globals.creature.position.y += 120.0 * delta
        if Input.is_action_pressed("move_right"):
            Globals.camera.position.x += 500.0 * delta
            Globals.creature.position.x += 120.0 * delta
        if Input.is_action_pressed("move_left"):
            Globals.camera.position.x -= 500.0 * delta
            Globals.creature.position.x -= 120.0 * delta

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
    if file.file_exists(world_path) == false:
        push_error("Failed to load sprite frames: %s" % [world_path])
        return

    Globals.current_level = LDTK.load_ldtk(world_path)
    Globals.world.add_child(Globals.current_level)

    # Extract metadata coming from LDTK file to do stuff specific to entities
    var entities_node = Globals.current_level.find_node("Entities")
    for child in entities_node.get_children():
        var entity : Entity = child
        var identifier : String = entity.get_meta("__identifier")
        var iid : String = entity.get_meta("iid")
        entity.name = "%s (%s)" % [identifier, iid]
        # print("[Game] entity: ", [entity, entity.get_meta_list()])

        var sprite_string : String = entity.get_meta("Sprite")
        # match sprite_string:
        #     "Creature": print("CREATURE!")
        #     "Plant": print("PLANT!")

        if entity.has_meta("WakeUp"):
            var data = entity.get_meta("WakeUp")
            if data == true:
                var behaviour := WakeUp.new()
                behaviour.name = "WakeUp"
                entity.add_child(behaviour)

        if entity.has_meta("AttractEntities"):
            var data = entity.get_meta("AttractEntities")
            if data == true:
                var behaviour := AttractEntities.new()
                behaviour.name = "AttractEntities"
                entity.add_child(behaviour)

        if entity.has_meta("Attracted"):
            var data = entity.get_meta("Attracted")
            if data == true:
                var behaviour := Attracted.new()
                behaviour.name = "Attracted"
                entity.add_child(behaviour)
        if entity.has_meta("Attracted"):

            var data = entity.get_meta("Sleepy")
            if data == true:
                var behaviour := Sleepy.new()
                behaviour.name = "Sleepy"
                entity.add_child(behaviour)

        var anim_path := "res://media/animations/entities/%s.tres" % [sprite_string]
        if ResourceLoader.exists(anim_path) == false:
            push_error("Failed to load sprite frames: %s" % [anim_path])
            return

        var sprite_frames : SpriteFrames = ResourceLoader.load(anim_path)
        entity.sprite_body.frames = sprite_frames

        if identifier == "Creature":
            if Globals.creature != null:
                push_error("Already on Creature in the world")
                return

            Globals.creature = child

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
