class_name Pet extends Behaviour

func _ready() -> void:
    var _result = entity.connect("interacted", self, "entity_interacted")

func entity_interacted(interaction_type: int) -> void:
    if interaction_type == 1:
        Globals.emotion_level += 1
    elif interaction_type == 0:
        Globals.emotion_level -= 1
