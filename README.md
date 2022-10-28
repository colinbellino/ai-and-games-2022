# Untitled Dinosaur Game

<p>In this very small and weird simulation game, you find an abandoned (or should we say, isolated) egg and have to take care of it before it dies.</p><p>The prototype is in a very rough state as we had to pivot our design mid jam and&nbsp;cut corners. The "AI" is limited to simple hunger + mood driven behaviours and some random patterns to make it a little more alive.<br></p><p>We had fun making it, so we hope that you will have fun playing and experimenting with it.</p>
<p>This game was done for the&nbsp;<a href="https://itch.io/jam/aiandgames-2022" target="_blank">AI & Games jam</a> in 7 days.</p>

![screenshot_1](https://user-images.githubusercontent.com/622180/198592340-d76fcc8c-2204-43f7-b8d1-b01d5fa95e7b.png)

<h2>Controls:</h2>
<table><thead><tr><th>Actions</th><th>Mouse & Keyboard</th><th>Gamepad</th></tr></thead><tbody><tr><td>Interact</td><td>Left mouse button / touchscreen</td><td>not supported</td></tr><tr><td>Pause/Settings</td><td>Escape</td><td>not supported
</td></tr><tr><td>Debug view</td><td>F1</td><td>not supported
</td></tr></tbody></table>
<h2>Credits:</h2>
<ul><li>Art:&nbsp;<a href="https://twitter.com/PronomicalArt" target="_blank">Michael "Calart" Pearson</a></li><li>Audio: <span></span><a href="https://twitter.com/bitbionic" target="_blank">Brandon "Bit Bionic" Forrester</a></li><li>Code:&nbsp;<span></span><a href="https://twitter.com/Krikit" target="_blank">Matthew "Krikit" Schultz</a></li><li>Code:&nbsp;<a href="https://twitter.com/colinbellino" rel="nofollow">Colin Bellino</a>
</li><li>Design:&nbsp;<a href="https://twitter.com/ondrej_markus" target="_blank">Ondrej Markus</a>and the rest of team.
</li><li>Paid assets:&nbsp;No
</li><li>Softwares:&nbsp;Godot,&nbsp;Aseprite,&nbsp;Audacity</li></ul>

## Setup the project

- Make sure you setup your editor (or Godot's editor) to indent with 4 SPACES (instead of 1 TAB)
- For external editors, setup EditorConfig: https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig

## Entities

Fields used to create new entities:

- `NodeType` (String): Used to spawn the entity in the scene, should always be set to `res://media/scenes/entities/Entity.tscn`.
- `IsCreature` (Boolean): Will flag the entity as "the creature" so the code can always reference it. Set to `true` to enable the behaviour. If the creature doesn't have this flag, things will break 🤷‍♂️.
- `EntityAnimation` (String): The name of the animation used. Don't add this if you want invisible entities. For example: `plant` will try to load the file `res://media/animations/entities/plant.tres`.
- `EmitStimulus` (Boolean): Will send a stimulus to entities around it when interacted. Set to `true` to enable the behaviour.
- `EmitStimulus_Type` (String): The type of stimulus to emit when interacted. Example: `Attraction`
- `WakeUp` (Boolean): Will enter the `Idle` state if it is `Asleep` when interacted. Set to `true` to enable the behaviour.
- `Attracted` (Boolean): Will enter the `Attracted` state if it is `Idle` when interacted. Set to `true` to enable the behaviour.
- `Sleepy` (Boolean): Will enter the `Asleep` state after X seconds in the `Idle` state. Set to `true` to enable the behaviour.
