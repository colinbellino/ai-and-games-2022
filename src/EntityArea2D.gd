extends Area2D

class_name EntityArea2D

# Set this up as it's own script to the area2d
# because we might have multiple area2d's for
# an entity to use (eyes, ears other sources of input)

# Using olfactory senses as a starting point
enum Stimulus {SIGHT, SOUND, TOUCH, TASTE, SMELL}

onready var parent = get_parent()

var source : int # Set to parent value
export(Stimulus) var stimulus : int # Override on child ready
var _entities : Array = []


func _ready() -> void:
    source = parent.source
    connect("area_entered", self, "_entity_entered")
    connect("area_exited", self, "_entity_exited")

    parent.connect("clicked", self, "_clicked")


func _mouse_click(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseMotion:
        pass # We could do something with mouseovers here

    if event is InputEventMouseButton and event.is_action_pressed("mouse_left"):
        _clicked()


func _entity_entered(area: Area2D) -> void:
    if not _entities.has(area):
        parent.connect("clicked", area, "_stimulus_clicked")
        parent.connect("entered", area, "_stimulus_entered")
        parent.connect("exited", area, "_stimulus_exited")
        _entered(area)
        _entities.append(area)


func _entity_exited(area: Area2D) -> void:
    var entity_found = _entities.find(area)
    if entity_found != -1:
        _exited(area)
        parent.disconnect("clicked", area, "_stimulus_clicked")
        parent.disconnect("entered", area, "_stimulus_entered")
        parent.disconnect("exited", area, "_stimulus_exited")
        _entities.remove(entity_found)


# Overides
func _clicked() -> void:
    pass


func _entered(area: Area2D) -> void:
    emit_signal("entered", area)


func _exited(area: Area2D) -> void:
    emit_signal("exited", area)
