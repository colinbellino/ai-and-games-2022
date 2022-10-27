class_name Entity extends Node2D

onready var sprite_body : AnimatedSprite = find_node("SpriteBody")
onready var sprite_emote : Sprite = find_node("SpriteEmote")
onready var area_sound : Area2D = find_node("SoundArea")

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
signal fed(amount)

func _process(_delta: float):
    if _state == Enums.EntityStates.Idle:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play("idle")

    # if _state == Enums.EntityStates.Asleep:
    #     if _state_entered == false:
    #         _state_entered = true
    #         sprite_body.play("fall_asleep")
    #         yield(sprite_body, "animation_finished")
    #         sprite_body.play("asleep")

    if _state == Enums.EntityStates.Bark:
        if _state_entered == false:
            _state_entered = true
            var animation = get_meta("bark_animation")
            # print("bark_animation: ", animation)
            sprite_body.play(animation)
            yield(sprite_body, "animation_finished")
            change_state(Enums.EntityStates.Idle)

    if _state == Enums.EntityStates.Moving:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play("walk")

            var path : PoolVector2Array = get_meta("moving_path")
            var speed : float = get_meta("moving_speed")
            for index in range(1, path.size()):
                var point = path[index]
                var destination : Vector2 = (point + Globals.CELL_CENTER_OFFSET) * Globals.SPRITE_SIZE
                var duration := position.distance_to(destination) / speed
                var direction = 1
                if destination.x  - position.x < 0:
                    direction = -1

                var tween := create_tween()
                tween.tween_property(self, "scale:x", direction * 1.0, 0.1)
                tween.tween_property(self, "position", destination, duration)
                yield(tween, "finished")

            change_state(Enums.EntityStates.Idle)

    if _state == Enums.EntityStates.Dead:
        if _state_entered == false:
            _state_entered = true
            sprite_body.play(get_meta("dead_animation"))
            yield(sprite_body, "animation_finished")

func interact(_interaction_type: int) -> void:
    # print("[Entity] %s interact" % [name])
    emit_signal("interacted", _interaction_type)

func area_interacted(_area: MouseArea2D) -> void:
    # print("[Entity] %s interacted | source: %s | stimulus: %s" % [name, area.source, area.stimulus])
    pass

func area_entered(area: MouseArea2D) -> void:
    print("[Entity] %s entered | source: %s" % [name, area])
    emit_signal("area_entered", area)

func area_exited(area: MouseArea2D) -> void:
    print("[Entity] %s exited | source: %s" % [name, area])
    emit_signal("area_exited", area)

func change_state(state: int) -> void:
    emit_signal("state_exited", _state)
    print("[Entity] %s changing state: %s" % [name, Enums.EntityStates.keys()[state]])
    # print_stack()
    _state = state
    _state_entered = false
    emit_signal("state_entered", state)

# Returns an array of Entity found in the area.
func get_entities_in_area() -> Array:
    return []
