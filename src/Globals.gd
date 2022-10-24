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
var emotion : int
var hunger : int
var astar : AStar2D
var creature_name : String

# Nodes
var ui_title : TitleUI
var ui_settings : SettingsUI
var ui_debug : DebugUI
var world : Node2D
var current_level: Node2D
var current_level_data: Dictionary
var camera: Camera2D
var creature : Entity

# Audio
var audio_player_sound : AudioStreamPlayer2D
var audio_player_music : AudioStreamPlayer2D
enum SFX { BUTTON_HOVER, BUTTON_CLICK_1, BUTTON_CLICK_2, EAT }
var audio_sounds : Dictionary = {
    SFX.BUTTON_HOVER: preload("res://media/audio/ui/menu-tick.wav"),
    SFX.BUTTON_CLICK_1: preload("res://media/audio/ui/menu-fx-e.ogg"),
    SFX.BUTTON_CLICK_2: preload("res://media/audio/ui/menu-fx-c.ogg"),
    SFX.EAT: preload("res://media/audio/creature/eating-2.wav"),
}
enum MUSIC { MENU, CALM, ACTIVE }
var audio_musics : Dictionary = {
    MUSIC.MENU: preload("res://media/audio/ui/menu.ogg"),
    MUSIC.CALM: preload("res://media/audio/music/Isolation-calm-1.ogg"),
    MUSIC.ACTIVE: preload("res://media/audio/music/Isolation-active.ogg"),
}

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
