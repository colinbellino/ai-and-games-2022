extends Node

# Constants
const UINT8_MAX  = (1 << 8)  - 1 # 255
const UINT16_MAX = (1 << 16) - 1 # 65535
const UINT32_MAX = (1 << 32) - 1 # 4294967295

const INT8_MIN  = -(1 << 7)  # -128
const INT16_MIN = -(1 << 15) # -32768
const INT32_MIN = -(1 << 31) # -2147483648
const INT64_MIN = -(1 << 63) # -9223372036854775808

const INT8_MAX  = (1 << 7)  - 1 # 127
const INT16_MAX = (1 << 15) - 1 # 32767
const INT32_MAX = (1 << 31) - 1 # 2147483647
const INT64_MAX = (1 << 63) - 1 # 9223372036854775807
const font1_path : String = "res://media/fonts/silver.ttf"
const resolutions : Array = [
    # ["426 x 240", Vector2(426, 240)],
    # ["640 x 360", Vector2(640, 360)],
    # ["854 x 480", Vector2(854, 480)],
    ["960 x 540", Vector2(960, 540)],
    ["1280 x 720", Vector2(1280, 720)],
    ["1920 x 1080", Vector2(1920, 1080)],
    ["2560 x 1440", Vector2(2560, 1440)],
    ["3840 x 2160", Vector2(3840, 2160)],
    ["7680 x 4320", Vector2(7680, 4320)],
]
const SPRITE_SIZE : int = 16
const SCALE : int = 4
const CELL_CENTER_OFFSET : Vector2 = Vector2(0.5, 0.5)
const LETTER_APPEAR_DELAY : float = 0.1

# Resources
onready var textures : Dictionary = {}
onready var entity_prefab := ResourceLoader.load("res://media/scenes/entities/Entity.tscn") as PackedScene

# State
var settings : GameSettings
var version : String = "0000000"
var can_fullscreen : bool
var can_change_resolution : bool
var bus_main : int
var bus_music : int
var bus_sound : int
var game_state : int
var game_state_entered : bool
var game_state_exited : bool
var emotion : Vector2
var hunger : int
var poop : int
var total_poops: int
var astar : AStar2D
var creature_name : String
var mouse_position : Vector2
var mouse_closest_point : int = -1
var creature_closest_point : int = -1
var random = RandomNumberGenerator.new()
var creature_names : Array = []
var game_names : Array = []
var time_elapsed : float

# Nodes
var ui_title : TitleUI
var ui_settings : SettingsUI
var ui_debug : DebugUI
var ui_intro : IntroUI
var ui_splash : CanvasLayer
var world : Node2D
var current_level: Node2D
var current_level_data: Dictionary
var camera: Camera2D
var creature : Entity
var animation_player : AnimationPlayer
var screen_shake : ScreenShake

# Audio
var audio_player_sound : AudioStreamPlayer2D
var audio_player_music : AudioStreamPlayer2D

enum SFX { BUTTON_HOVER, BUTTON_CLICK_1, BUTTON_CLICK_2, EAT, SLEEP, LAUGH, CRY, WALK, POOP, TEXT_TYPE, INTRO_DANGER, EXPLOSION_1,
           DEATH, ANGER, BORED, SWISH }

var audio_sounds : Dictionary = {
    SFX.BUTTON_HOVER: preload("res://media/audio/ui/menu-tick.wav"),
    SFX.BUTTON_CLICK_1: preload("res://media/audio/ui/menu-fx-e.ogg"),
    SFX.BUTTON_CLICK_2: preload("res://media/audio/ui/menu-fx-c.ogg"),
    SFX.EAT: preload("res://media/audio/creature/eating-2.wav"),
    SFX.SLEEP: preload("res://media/audio/creature/snoring-1.ogg"),
    SFX.LAUGH: preload("res://media/audio/creature/laugh.wav"),
    SFX.CRY: preload("res://media/audio/creature/crying-1.ogg"),
    SFX.WALK: preload("res://media/audio/creature/step-slow.ogg"),
    SFX.POOP: preload("res://media/audio/creature/small-fart.wav"),
    SFX.TEXT_TYPE: preload("res://media/audio/ui/fft-text.mp3"),
    # SFX.INTRO_DANGER: preload("res://media/audio/ui/Then, everything changed when the fire nation attacked.mp3"),
    # SFX.EXPLOSION_1: preload("res://media/audio/not_a_creeper.mp3"),
    SFX.INTRO_DANGER: preload("res://media/audio/whoosh.ogg"),
    SFX.EXPLOSION_1: preload("res://media/audio/explosion.ogg"),
    SFX.DEATH: preload("res://media/audio/creature/dying-1.ogg"),
    SFX.ANGER: preload("res://media/audio/creature/angry.ogg"),
    SFX.BORED: preload("res://media/audio/creature/bored.ogg"),
    SFX.SWISH: preload("res://media/audio/swish.ogg"),
}
enum MUSIC { MENU, CALM, ACTIVE }
var audio_musics : Dictionary = {
    MUSIC.MENU: preload("res://media/audio/ui/menu.ogg"),
    MUSIC.CALM: preload("res://media/audio/music/Isolation-calm-1.ogg"),
    MUSIC.ACTIVE: preload("res://media/audio/music/Isolation-active.ogg"),
}

var one_shot = preload("res://media/scenes/OneShotAudioStream.tscn")


func _ready() -> void:
    # Init stuff here
    Globals.settings = Save.read_settings()
    Globals.bus_main = AudioServer.get_bus_index("Master")
    assert(Globals.bus_main != null, "Globals.bus_main not initialized correctly.")
    Globals.bus_music = AudioServer.get_bus_index("Music")
    assert(Globals.bus_music != null, "Globals.bus_music not initialized correctly.")
    Globals.bus_sound = AudioServer.get_bus_index("Sound")
    assert(Globals.bus_sound != null, "Globals.bus_sound not initialized correctly.")
    Globals.world = get_node("/root/Game/%World")
    assert(Globals.world != null, "Globals.world not initialized correctly.")
    Globals.ui_title = get_node("/root/Game/%TitleUI")
    assert(Globals.ui_title != null, "Globals.ui_title not initialized correctly.")
    Globals.ui_settings = get_node("/root/Game/%SettingsUI")
    assert(Globals.ui_settings != null, "Globals.ui_settings not initialized correctly.")
    Globals.ui_debug = get_node("/root/Game/%DebugUI")
    assert(Globals.ui_debug != null, "Globals.ui_debug not initialized correctly.")
    Globals.ui_intro = get_node("/root/Game/%IntroUI")
    assert(Globals.ui_intro != null, "Globals.ui_intro not initialized correctly.")
    Globals.ui_splash = get_node("/root/Game/%SplashUI")
    assert(Globals.ui_splash != null, "Globals.ui_splash not initialized correctly.")
    Globals.camera = get_node("/root/Game/%MainCamera")
    assert(Globals.camera != null, "Globals.camera not initialized correctly.")
    Globals.animation_player = get_node("/root/Game/%AnimationPlayer")
    assert(Globals.animation_player != null, "Globals.animation_player not initialized correctly.")
    Globals.audio_player_sound = get_node("/root/Game/%SoundPlayer")
    assert(Globals.audio_player_sound != null, "Globals.audio_player_sound not initialized correctly.")
    Globals.audio_player_music = get_node("/root/Game/%MusicPlayer")
    assert(Globals.audio_player_music != null, "Globals.audio_player_music not initialized correctly.")
    Globals.screen_shake = get_node("/root/Game/%ScreenShake")
    assert(Globals.screen_shake != null, "Globals.screen_shake not initialized correctly.")
    Globals.version = load_file("res://version.txt", "1111111")
    assert(Globals.version != null, "Globals.version not initialized correctly.")
    Globals.can_fullscreen = OS.get_name() == "Windows"
    Globals.can_change_resolution = OS.get_name() != "HTML5"
    Globals.random.randomize()
    Globals.creature_names = load_creatures()
    assert(Globals.creature_names.size() > 0, "Globals.creature_names not initialized correctly.")
    Globals.creature_name = Globals.creature_names[Globals.random.randi() % Globals.creature_names.size()]
    Globals.game_names = load_game_names()
    assert(Globals.game_names.size() > 0, "Globals.game_names not initialized correctly.")
    Globals.creature_name = Globals.game_names[Globals.random.randi() % Globals.game_names.size()]
    assert(Globals.creature_name != "", "Globals.creature_name not initialized correctly.")
    Globals.astar = AStar2D.new()
    assert(Globals.astar != null, "Globals.astar not initialized correctly.")

    if Globals.can_fullscreen:
        Globals.set_fullscreen(Globals.settings.window_fullscreen)
    Globals.set_resolution(Globals.settings.resolution_index)
    Globals.set_linear_db(Globals.bus_main, Globals.settings.volume_main)
    Globals.set_linear_db(Globals.bus_music, Globals.settings.volume_music)
    Globals.set_linear_db(Globals.bus_sound, Globals.settings.volume_sound)
    TranslationServer.set_locale(Globals.settings.locale)

# Utils

# FIXME: looks like this doesn't work on MacOS
func set_fullscreen(value: bool) -> void:
    OS.window_fullscreen = value

func set_resolution(resolution_index: float) -> void:
    OS.window_size = resolutions[resolution_index][1]
    get_viewport().set_size_override(true, resolutions[resolution_index][1])
    get_viewport().set_size_override_stretch(true)

func get_linear_db(bus_index: int) -> float:
    return db2linear(AudioServer.get_bus_volume_db(bus_index))

func set_linear_db(bus_index: int, linear_db: float) -> void:
    linear_db = clamp(linear_db, 0.0, 1.0)
    AudioServer.set_bus_volume_db(bus_index, linear2db(linear_db))

func add_emotion(amount: Vector2, source: String = "Unknown"):
    emotion.x = clamp(emotion.x + amount.x, -1, 1)
    emotion.y = clamp(emotion.y + amount.y, -1, 1)
    print("[Emotion Added %s][Amount %s]" % [source, amount])


static func load_file(filepath: String, default_value: String = "") -> String:
    var file := File.new()
    var result := file.open(filepath, File.READ)
    if result != OK:
        print("[Game] Couldn't load file: %s" % [filepath])
        file.close()
        return default_value

    var data = file.get_as_text()
    file.close()
    return data

static func load_creatures() -> Array:
    var text := load_file("res://creatures.txt", "Denver")
    var lines : Array = text.split("\n")
    if lines[lines.size() -1] == "":
        lines.pop_back()

    return lines

static func load_game_names() -> Array:
    var text := load_file("res://game_names.txt", "Creature")
    var lines : Array = text.split("\n")
    if lines[lines.size() -1] == "":
        lines.pop_back()

    return lines
