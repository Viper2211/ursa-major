import "generation/lib" for Generator, Dungeon
import "graphics" for Canvas

class Level {
    construct new(){
        Canvas.resize(320,320)
    }

    generate() {
        var generator = Generator.new(Dungeon.new(40,40))
        _gameObjects = generator.objects
    }

    objects { _gameObjects }
}