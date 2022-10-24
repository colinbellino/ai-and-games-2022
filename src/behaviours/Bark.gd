class_name Bark extends Behaviour

var next_bark : int
var delay_in_ms : int = 5000

signal bark_finished()

func _ready() -> void:
    next_bark = OS.get_ticks_msec() + delay_in_ms
    pass

func _exit_tree() -> void:
    pass

func _process(_delta: float) -> void:
    if OS.get_ticks_msec() >= next_bark:
        next_bark = OS.get_ticks_msec() + delay_in_ms

        bark(Globals.emotion_level)
        yield(self, "bark_finished")
        next_bark = OS.get_ticks_msec() + delay_in_ms

func bark(emotion_level: int) -> void:
    var original_position := entity.sprite_body.position
    var original_scale := entity.sprite_body.scale

    if emotion_level < -5: # Sad
        var tween := create_tween()
        tween.set_loops(2)
        tween.tween_property(entity.sprite_body, "position:x", original_position.x + -2.0, 0.25)
        tween.tween_property(entity.sprite_body, "position:x", original_position.x, 0.25)
        yield(tween, "finished")

    elif emotion_level > 5: # Happy
        var tween := create_tween()
        tween.set_loops(2)
        tween.tween_property(entity.sprite_body, "position:y", original_position.y + -2.0, 0.25)
        tween.tween_property(entity.sprite_body, "position:y", original_position.y, 0.25)
        yield(tween, "finished")

    else: # Neutral
        var tween := create_tween()
        tween.tween_property(entity.sprite_body, "scale", original_scale * 0.5, 0.25)
        tween.tween_property(entity.sprite_body, "scale", original_scale, 0.25)
        yield(tween, "finished")

    emit_signal("bark_finished")
