class_name LDTK

# Warning: this is some very bad code that i had to copy from the LDtk importer
static func load_ldtk(filepath: String) -> Node2D:
    var LDtk = preload("res://addons/LDtk-Importer/LDtk.gd").new()

    var options := {
        "Import_Collisions": false,
        "Import_Custom_Entities": true,
        "Import_Metadata": true,
        "Import_YSort_Entities_Layer": false,
        "Post_Import_Script": {},
    }

    LDtk.map_data = filepath

    var map = Node2D.new()
    map.name = filepath.get_file().get_basename()

    #add levels as Node2D
    for level in LDtk.map_data.levels:
        var new_level = Node2D.new()
        new_level.name = level.identifier
        new_level.position = Vector2(level.worldX, level.worldY)

        #import level metadata
        if options.Import_Metadata:
            for property in level:
                if not property in ["layerInstances"]:
                    if property == "fieldInstances":
                        for field in level.fieldInstances:
                            new_level.set_meta(field.__identifier, field.__value)
                    else:
                        new_level.set_meta(property, level[property])

        map.add_child(new_level)
        new_level.set_owner(map)

        #add layers
        var layerInstances = get_level_layerInstances(LDtk, level, options)
        for layerInstance in layerInstances:
            new_level.add_child(layerInstance)
            layerInstance.set_owner(map)

            var children = layerInstance.get_children()

            while children:
                for child in children:
                    child.set_owner(map)
                    if child.get_children():
                        var grandchildren = child.get_children()
                        children += grandchildren

                    children.erase(child)

    #Post imports script
    # if not options.Post_Import_Script.empty():
    #     var script = load(options.Post_Import_Script)
    #     if not script or not script is GDScript:
    #         printerr("Post import script is not a GDScript.")
    #         # return ERR_INVALID_PARAMETER
    #         push_error("Error: %s" % ERR_INVALID_PARAMETER)
    #         return null

    #     script = script.new()
    #     if not script.has_method("post_import"):
    #         printerr("Post import script does not have a 'post_import' method.")
    #         # return ERR_INVALID_PARAMETER
    #         push_error("Error: %s" % ERR_INVALID_PARAMETER)
    #         return null

    #     map = script.post_import(map)

    #     if not map or not map is Node2D:
    #         printerr("Invalid scene returned from post import script.")
    #         # return ERR_INVALID_DATA
    #         push_error("Error: %s" % ERR_INVALID_DATA)
    #         return null

    return map

#create layers in level
static func get_level_layerInstances(LDtk, level, options):
    var layers = []
    # var i = level.layerInstances.size()
    for layerInstance in level.layerInstances:
        var new_layer = null
        match layerInstance.__type:
            'Entities':
                if options.Import_YSort_Entities_Layer and layerInstance.__identifier.begins_with("YSort"):
                    new_layer = YSort.new()
                else:
                    new_layer = Node2D.new()
                var entities = LDtk.get_layer_entities(layerInstance, options)
                for entity in entities:
                    new_layer.add_child(entity)
                    entity.set_owner(new_layer)

            'Tiles', 'IntGrid', 'AutoLayer':
                new_layer = LDtk.new_tilemap(layerInstance)

#check for collision layer
        if layerInstance.__type == 'IntGrid':
            var collision_layer = LDtk.import_collisions(layerInstance, options)
            if collision_layer:
                layers.push_front(collision_layer)

#add new layer to layers array if not null
        if new_layer:
            new_layer.name = layerInstance.__identifier
            new_layer.position = Vector2(layerInstance.__pxTotalOffsetX, layerInstance.__pxTotalOffsetY)
            layers.push_front(new_layer)

        # i -= 1

    return layers

# Extract metadata coming from LDTK file to do stuff specific to entities
# **Always do this AFTER the entities_node is added to the tree**
static func update_entities(entities_node) -> void:
    for child in entities_node.get_children():
        var entity : Entity = child
        var identifier : String = entity.get_meta("__identifier")
        var iid : String = entity.get_meta("iid")
        entity.name = "%s (%s)" % [identifier, iid]
        # print("[Game] entity: ", [entity, entity.get_meta_list()])

        # TODO: (Colin) Automate this
        if entity.has_meta("WakeUp"):
            var data = entity.get_meta("WakeUp")
            if data == true:
                var behaviour := WakeUp.new()
                behaviour.name = "WakeUp"
                entity.add_child(behaviour)

        if entity.has_meta("SendStimulus"):
            var data = entity.get_meta("SendStimulus")
            if data == true:
                var behaviour := SendStimulus.new()
                behaviour.name = "SendStimulus"
                entity.add_child(behaviour)

        if entity.has_meta("Attracted"):
            var data = entity.get_meta("Attracted")
            if data == true:
                var behaviour := Attracted.new()
                behaviour.name = "Attracted"
                entity.add_child(behaviour)
        if entity.has_meta("Attracted"):

            var data = entity.get_meta("Sleepy")
            if data == true:
                var behaviour := Sleepy.new()
                behaviour.name = "Sleepy"
                entity.add_child(behaviour)

        var sprite_string : String = entity.get_meta("Sprite")
        var anim_path := "res://media/animations/entities/%s.tres" % [sprite_string]
        if ResourceLoader.exists(anim_path) == false:
            push_error("Failed to load sprite frames: %s" % [anim_path])
            return

        var sprite_frames : SpriteFrames = ResourceLoader.load(anim_path)
        entity.sprite_body.frames = sprite_frames

        if identifier == "Creature":
            if Globals.creature != null:
                push_error("Already on Creature in the world")
                return

            Globals.creature = child
            # TODO: remove this
            # Quick hack to make the creature always visible
            Globals.creature.z_index = 99
