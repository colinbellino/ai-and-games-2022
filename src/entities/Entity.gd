class_name Entity extends Node2D

onready var sprite_body : AnimatedSprite = find_node("SpriteBody")
onready var area_sound : Area2D = find_node("SoundArea")
var destination : Vector2

# Note: don't change this without using change_state()
var _state : int
var _state_entered : bool
var _state_exited : bool

signal interacted
signal area_entered(area)
signal area_exited(area)

signal attracted(emiter)

func _process(_delta: float):
    if _state == Enums.EntityStates.Idle:
        if _state_entered == false:
            _state_entered = true
            # print("[Entity] %s doing nuffin (idle)" % [name])
            sprite_body.play("idle")

    if _state == Enums.EntityStates.Asleep:
        if _state_entered == false:
            _state_entered = true
            # print("[Entity] %s fell asleep" % [name])
            sprite_body.play("fall_asleep")
            yield(sprite_body, "animation_finished")
            sprite_body.play("asleep")

    if _state == Enums.EntityStates.Activating:
        if _state_entered == false:
            _state_entered = true
            # print("[Entity] %s activated" % [name])
            sprite_body.play("activating")
            yield(sprite_body, "animation_finished")
            sprite_body.play("idle")

    if _state == Enums.EntityStates.Attracted:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play("react")
            yield(sprite_body, "animation_finished")
            sprite_body.play("walk")

            # print("MOVING TOWARD: ", destination)
            var tween = create_tween()
            tween.tween_property(self, "position", destination, 1.0)

            change_state(Enums.EntityStates.Idle)

func interact() -> void:
    # print("[Entity] %s interact" % [name])
    emit_signal("interacted")

func area_interacted(_area: EntityArea2D) -> void:
    # print("[Entity] %s interacted | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    pass

func area_entered(area: EntityArea2D) -> void:
    # print("[Entity] %s entered | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    emit_signal("area_entered", area)
    # var _result = connect("interacted", area, "_interacted", [area])

func area_exited(area: EntityArea2D) -> void:
    # print("[Entity] %s exited | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    emit_signal("area_exited", area)
    # disconnect("interacted", area, "_interacted")

func change_state(state: int) -> void:
    print("[Entity] %s changing state: %s" % [name, Enums.EntityStates.keys()[state]])
    _state = state
    _state_entered = false

# Returns an array of Entity found in the area.
func get_entities_in_area() -> Array:
    var areas := area_sound.get_overlapping_areas()
    var entities := []
    for area in areas:
        if area is EntityArea2D:
            entities.append(area.entity)

    return entities
