# godot-voice-gen

This is a voice generator based on animalese from the Animal Crossing series.

# Installing:

Either clone this repo into your `[project_folder]/addons/godot-voice-gen` or add it is a submodule with <br>
```
git submodule add https://github.com/Kibibibit/godot-voice-gen ./addons/godot-voice-gen
```

or, if you use SSH with git:
```
git submodule add https://github.com/Kibibibit/godot-voice-gen ./addons/godot-voice-gen
```

Then, once you open your project in Godot, go into `Project Settings > Plugins` and enable `godot-voice-gen`

# Usage:

This plugin adds a new node called `VoiceGen`, which actually does the voice generating. The node has 2 parameters you need to set, either in code or in the inspector.

## `player`
This should be either an `AudioStreamPlayer`, `AudioStreamPlayer2D`, or an `AudioStreamPlayer3D`, depending on whether or not you want the voice to be positional or not. (Note that as `VoiceGen` extends `Node`, you will need to position `player` in code or it will not follow `VoiceGen`'s parent)

This player will actually play the sound files for the voices.

> Note that in the future, `VoiceGen` may be split into `VoiceGen2D`, `VoiceGen3D` and `VoiceGen` to account for different scene types.

## `voice_path`
This should be the directory where all of your voice sound files are stored.


## Mutable Parameters
The other parameters for the generator determine a few things like the speed, pitch and variance of the voiced.
These paramters can be changed freely.

| Parameter | Type | Description |
| - | - | - |
| `pitch` | `float` | This is the amount that the audio files will be pitched up or down by. This also affects the file's speed. |
| `pitch_range` | `float` | This is the maxiumum variance that might be added to each letter, positive or negative. |
| `speed` | `float` | This is time in seconds that each sound will play for before it is cut off to play the next sound. |
| `question_pitch` | `float` | When a sentence ends in a question mark, the last `question_length` letters will be pitched up by this amount |
| `question_length` | `int` | How many letters the sound will be pitched up for before a question mark |
| `voice` | `int` | Which voice the generator will use. Should be the index of one of the names in `voices` |
| `load_on_ready` | `bool` | If `true`, as soon as the `VoiceGen` node loads, it will load in all of its sound files. Normally this needs to be called manually with `load_voices` or `load_voice` |

## Immutable Paramters
These are paramters that are public, but I wouldn't recommend changing them as you might break things. (I'll learn how to set up setters properly eventually)

| Parameter | Type | Description |
| - | - | - |
| `voices` | `Array[String]` | The list of loaded in voice names, used to identify sound files and loaded in sounds | 

## Methods
### `load_voices`

### `load_voice`

### `play`

### `stop`