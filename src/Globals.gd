extends Node

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

var settings : GameSettings
var version : String = "0000000"
var can_fullscreen : bool
var bus_main : int
var bus_music : int
var bus_sound : int

# Resources
onready var sounds : Dictionary = {
    # 1: ResourceLoader.load("res://media/sounds/death_0.mp3"),
    # 2: ResourceLoader.load("res://media/sounds/death_1.mp3"),
    # 3: ResourceLoader.load("res://media/sounds/hit.mp3"),
    # 4: ResourceLoader.load("res://media/sounds/cast_summoning.mp3"),
}

# Nodes
onready var ui_title : TitleUI
onready var ui_settings : SettingsUI

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
