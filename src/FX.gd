extends Entity


func _ready() -> void:
    $SpriteBody.connect("animation_finished", self, "_animation_finished")

func _animation_finished() -> void:
    queue_free()
