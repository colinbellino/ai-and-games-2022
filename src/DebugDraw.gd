class_name DebugDraw extends Control

var font : DynamicFont

func _ready() -> void:
    font = DynamicFont.new()
    font.font_data = ResourceLoader.load(Globals.font1_path)
    font.size = 26

func _process(_delta: float) -> void:
    get_parent().visible = Globals.settings.debug_draw
    update()

func _draw() -> void:
    if Globals.settings.debug_draw == false:
        return

    var TEXT_OFFSET := Vector2(0.3, 0.6)
    var SCALE := 64

    var points := Globals.astar.get_points()
    for cell_index in points:
        var cell_position := Globals.astar.get_point_position(cell_index)
        var color = Color.red
        color.a = 0.5
        draw_rect(Rect2((cell_position + Vector2(0.1, 0.1)) * SCALE, Vector2(0.8, 0.8) * SCALE),  color)
        draw_string(font, (cell_position + TEXT_OFFSET) * SCALE, "%s,%s" % [cell_position.x, cell_position.y], Color.white)

        var connections := Globals.astar.get_point_connections(cell_index)
        for connection_index in connections:
            var connection_position := Globals.astar.get_point_position(connection_index)
            draw_line((cell_position + Vector2(0.5, 0.5)) * SCALE, (connection_position + Vector2(0.5, 0.5)) * SCALE, Color.blue, 0.5)
