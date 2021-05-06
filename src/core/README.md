# Core
The main framework that the game is built around

# How does it work?
In order to keep code easy to maintain and simple, the framework uses the [Component design pattern](https://gameprogrammingpatterns.com/component.html).

All physics interactions, animations, and input handling is delegated to the corresponding component.

Each component has access to its parent entity, allowing access from one component to another.

Each entity also has a special `data` field, with a dictionary that stores additional data.

## Input
Input is handled by an input component class defined in `controller.wren`. A user can also create their own input handling class, provided it has the following methods:
- `input()`
- `entity()`
- `entity`

## Physics
Physics are handled by a physics body class defined in `physics.wren`. A user can also create their own input handling class, but it is not recommended.

The `PhysicsBody` class provides the following methods:
- `update()` - Update the position of the instance
- `collided(_)` - Checks if this physics body has collided with another
- `applyForce(_,_)` - Add to the movement vector of the instance
- `setForce(_,_)` - Set the movement vector of the instance
- `stop()` - Shorthand for setting the instance's movement vector to `(0,0)`
- `clone()` - Clone the instance. Returns a new `PhysicsBody` with the same settings as this instance
- `pos(_,_)` - Set the position of the instance
- `pos` - Get the position of the instance. Returns a `Vector(x,y)`
- `size(_,_)` - Set the size of the instance
- `size` - Get the size of the instance. Returns a `Vector(x,y)`
- `speed=(_)` - Set the speed of the instance
- `speed` - Get the speed of the instance
- `movement` - Get the movement vector of the instance. Returns a `Vector(x,y)`
- `tags` - Get the tags assigned to the instance
- `entity=(_)` - Set the parent entity
- `entity` - Get the parent entity

## Graphics
Graphics are handled by two classes defined in `sprite.wren`:
- `Sprite`
- `Animation`

The `Sprite` class handles single sprites and can be passed as a graphics component. It also exposes a `static resize(_,_)` function to simplify the handling of images. It takes two parameters, the first being the image and the second being the scale.

The `Animation` class is a set of `Sprite` instances and can also be passed as a graphics component. It can be used to create looping animations, while also being used to represent a spritesheet. It provides the following functions:
- `start()`
- `stop()`
- `setSprite(_)`
- `nextSprite()`
- `w`
- `h`
- `step`
- `loop=(_)`
- `loop`
- `advance`
- `advance=(_)`

## Game Objects
Game objects are defined in `gameObject.wren`. The class named `GameObject` is a structure that groups together all the components mentioned above and allows them to be manipulated.

### Example
Taken right out of **Ursa Major**, `level.wren`
```js
__tile = {
    "wall" : PhysicsBody.new(["static","collider"]) {|entity|},
    "floor" : PhysicsBody.new(["static"]) {|entity|},
    "static" : null,
    "empty" : Sprite.new(Sprite.resize(ImageData.loadFromFile("res/EmptyTile.png"),1/4)),
    "mossy" : Sprite.new(Sprite.resize(ImageData.loadFromFile("res/MossyStoneTile.png"),1/4)),
    "full" : Sprite.new(Sprite.resize(ImageData.loadFromFile("res/StoneTile.png"),1/4))
}
```