# Project Creature

### Setup the project

- Make sure you setup your editor (or Godot's editor) to indent with 4 SPACES (instead of 1 TAB)
- For external editors, setup EditorConfig: https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig

### Entities

Fields used to create new entities:

- `NodeType` (String): Used to spawn the entity in the scene, should always be set to `res://media/scenes/entities/Entity.tscn`.
- `IsCreature` (Boolean): Will flag the entity as "the creature" so the code can always reference it. Set to `true` to enable the behaviour. If the creature doesn't have this flag, things will break 🤷‍♂️.
- `EntityAnimation` (String): The name of the animation used. Don't add this if you want invisible entities. For example: `plant` will try to load the file `res://media/animations/entities/plant.tres`.
- `EmitStimulus` (Boolean): Will send a stimulus to entities around it when interacted. Set to `true` to enable the behaviour.
- `EmitStimulus_Type` (String): The type of stimulus to emit when interacted. Example: `Attraction`
- `WakeUp` (Boolean): Will enter the `Idle` state if it is `Asleep` when interacted. Set to `true` to enable the behaviour.
- `Attracted` (Boolean): Will enter the `Attracted` state if it is `Idle` when interacted. Set to `true` to enable the behaviour.
- `Sleepy` (Boolean): Will enter the `Asleep` state after X seconds in the `Idle` state. Set to `true` to enable the behaviour.
