class_name Entity extends Node2D

onready var sprite_body : AnimatedSprite = find_node("SpriteBody")
onready var sprite_emote : Sprite = find_node("SpriteEmote")
onready var area_sound : Area2D = find_node("SoundArea")
var destination : Vector2

# Note: don't change this without using change_state()
var _state : int
var _state_entered : bool
var _state_exited : bool

signal interacted(interaction_type)
signal area_entered(area)
signal area_exited(area)
signal state_entered(new_state)
signal state_exited(previous_state)
signal stimulus_received(type, emiter)

func _process(_delta: float):
    if _state == Enums.EntityStates.Idle:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play("idle")

    if _state == Enums.EntityStates.Asleep:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play("fall_asleep")
            yield(sprite_body, "animation_finished")
            sprite_body.play("asleep")

    if _state == Enums.EntityStates.Bark:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play(get_meta("bark_animation"))
            yield(sprite_body, "animation_finished")
            change_state(Enums.EntityStates.Idle)

func interact(_interaction_type: int) -> void:
    # print("[Entity] %s interact" % [name])
    emit_signal("interacted", _interaction_type)

func area_interacted(_area: EntityArea2D) -> void:
    # print("[Entity] %s interacted | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    pass

func area_entered(area: EntityArea2D) -> void:
    # print("[Entity] %s entered | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    emit_signal("area_entered", area)

func area_exited(area: EntityArea2D) -> void:
    # print("[Entity] %s exited | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    emit_signal("area_exited", area)

func change_state(state: int) -> void:
    emit_signal("state_exited", _state)
    print("[Entity] %s changing state: %s" % [name, Enums.EntityStates.keys()[state]])
    _state = state
    _state_entered = false
    emit_signal("state_entered", state)

# Returns an array of Entity found in the area.
func get_entities_in_area() -> Array:
    var areas := area_sound.get_overlapping_areas()
    var entities := []
    for area in areas:
        if area is EntityArea2D:
            entities.append(area.entity)

    return entities
