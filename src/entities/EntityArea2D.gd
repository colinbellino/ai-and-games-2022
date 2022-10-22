class_name EntityArea2D extends Area2D

# Set this up as it's own script to the area2d
# because we might have multiple area2d's for
# an entity to use (eyes, ears other sources of input)
# Using olfactory senses as a starting point
onready var entity : Node2D = get_parent()

var source : int # Set to parent value for easier reference
export(Enums.Stimulus) var stimulus : int # Override on scene inspector
var _entities : Array = []

func _ready() -> void:
    var _result = connect("area_entered", self, "_entity_entered")
    _result = connect("area_exited", self, "_entity_exited")

func _entity_entered(area: Area2D) -> void:
    if not _entities.has(area):
        entity.area_entered(area)
        _entities.append(area)

func _entity_exited(area: Area2D) -> void:
    var entity_found = _entities.find(area)
    if entity_found != -1:
        entity.area_exited(area)
        _entities.remove(entity_found)

func _interacted(area: EntityArea2D):
    entity.area_interacted(area)
