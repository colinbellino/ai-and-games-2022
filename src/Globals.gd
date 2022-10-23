extends Node

# Constants
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
var emotion_level : int

# Nodes
var ui_title : TitleUI
var ui_settings : SettingsUI
var ui_debug : DebugUI
var world : Node2D
var current_level: Node2D
var camera: Camera2D
var creature : Entity

# Audio
var audio_player_sound : AudioStreamPlayer
var audio_player_music : AudioStreamPlayer

enum MUSIC { MENU, CALM, ACTIVE }
enum SFX { BUTTON_HOVER, BUTTON_CLICK }

var _snd_button_hover : AudioStream =  preload("res://media/audio/ui/menu-tick.wav")
var _snd_button_e : AudioStream =  preload("res://media/audio/ui/menu-fx-e.ogg")
var _snd_button_c : AudioStream =  preload("res://media/audio/ui/menu-fx-c.ogg")

const _music_menu : String = "res://media/audio/ui/menu.ogg"
const _music_calm_1 : String = "res://media/audio/music/Isolation-calm-1.ogg"
const _music_active : String = "res://media/audio/music/Isolation-active.ogg"

func _ready():
    _snd_button_hover.set_loop_mode(false)
    _snd_button_e.set_loop(false)
    _snd_button_c.set_loop(false)

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

func play_sfx( fx: int) -> void:
    if fx == SFX.BUTTON_HOVER:
        audio_player_sound.stream = _snd_button_hover
        Globals.audio_player_sound.play()
    elif fx == SFX.BUTTON_CLICK:
        var num = randf()
        if num < 0.5:
            audio_player_sound.stream = _snd_button_e
        else:
            audio_player_sound.stream = _snd_button_c

        Globals.audio_player_sound.play()

func play_music( music: int ) -> void:
    var stream = null

    if music == MUSIC.MENU:
        stream = load(_music_menu)
    elif music == MUSIC.CALM:
        stream = load(_music_calm_1)
    elif music == MUSIC.ACTIVE:
        stream = load(_music_active)

    if stream != null:
        stream.set_loop(true)
        if Globals.audio_player_music.playing:
            Globals.audio_player_music.stop()
        Globals.audio_player_music.stream = stream
        Globals.audio_player_music.play()
