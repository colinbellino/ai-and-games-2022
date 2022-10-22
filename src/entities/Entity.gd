class_name Entity extends Node

# export(Globals.Source) var source : int # Set in scene inspector

var sprite_body : Sprite

func _ready() -> void:
    sprite_body = find_node("SpriteBody")

func clicked() -> void:
    print("[ENTITY] Clicked: ", self)

func stimulus_entered(area: EntityArea2D) -> void:
    print("[ENTITY] Entered, Source: ", area.source, " | Stimulus: ", area.stimulus)

func stimulus_exited(area: EntityArea2D) -> void:
    print("[ENTITY] Exited, Source: ", area.source, " | Stimulus: ", area.stimulus)
