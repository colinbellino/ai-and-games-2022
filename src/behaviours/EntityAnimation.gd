class_name EntityAnimation extends Behaviour

export var sprite_string : String

func _ready() -> void:
    yield(get_tree(), "idle_frame")
    if sprite_string == "":
        sprite_string = LDTK.get_behaviour_value(entity, "EntityAnimation")
    var anim_path := "res://media/animations/entities/%s.tres" % [sprite_string]

    assert(ResourceLoader.exists(anim_path), "Failed to load sprite frames: %s" % [anim_path])

    var sprite_frames : SpriteFrames = ResourceLoader.load(anim_path)
    entity.sprite_body.frames = sprite_frames
