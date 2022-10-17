extends Node

const font1_path : String = "res://media/fonts/silver.ttf"

# Resources
onready var sounds : Dictionary = {
    # 1: ResourceLoader.load("res://media/sounds/death_0.mp3"),
    # 2: ResourceLoader.load("res://media/sounds/death_1.mp3"),
    # 3: ResourceLoader.load("res://media/sounds/hit.mp3"),
    # 4: ResourceLoader.load("res://media/sounds/cast_summoning.mp3"),
}

# Nodes
onready var title_ui : TitleUI
