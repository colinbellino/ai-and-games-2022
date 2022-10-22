# Project Creature

### Setup the project

- Make sure you setup your editor (or Godot's editor) to indent with 4 SPACES (instead of 1 TAB)
- For external editors, setup EditorConfig: https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig

### Entities

Fields used to create new entities:

- `NodeType` (String): Used to spawn the entity in the scene, should always be set to `res://media/scenes/entities/Entity.tscn`.
- `Sprite` (String): The name of the sprite/animation used. For example: `plant` will try to load the file `res://media/animations/entities/plant.tres`.
- `SendStimulus` (Boolean): Will send a stimulus to entities around it when activated. Set to `true` to enable the behaviour.
- `SendStimulus_Type` (String): The type of stimulus to send on activation. Example: `Attraction`
- `WakeUp` (Boolean): Will enter the `Idle` state if it is `Asleep` when activated. Set to `true` to enable the behaviour.
- `Attracted` (Boolean): Will enter the `Attracted` state if it is `Idle` when activated. Set to `true` to enable the behaviour.
- `Sleepy` (Boolean): Will enter the `Asleep` state after X seconds in the `Idle` state. Set to `true` to enable the behaviour.
