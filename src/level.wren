import "generation/lib" for Generator, Dungeon
import "graphics" for Canvas

class Level {
    construct new(){
        Canvas.resize(320,320)
    }

    init() {
        _distanceToBottom = Canvas.height
        _distanceToRight = Canvas.width
        this.generate()
        _startPosition = _gameObjects[_gameObjects.count - 1].physics.pos(162, 160)
        _gameObjects[_gameObjects.count - 1]["start"] = _startPosition
    }

    update() {
        for (object in _gameObjects) {
            if (!object.tags.contains("static")) object.update(_gameObjects)
            if (object.input) object.handle()
        }
    }

    draw(delta) {
        var player = _gameObjects[_gameObjects.count - 1]
        var newPosition = [_startPosition.x - player.physics.pos.x - 12, _startPosition.y - player.physics.pos.y - 16]
        Canvas.cls()
        Canvas.offset(newPosition[0], newPosition[1])
        for (object in _gameObjects) {
            object.draw(delta,_distanceToBottom,_distanceToRight, 0, 0)
        }
    }

    generate() {
        var generator = Generator.new(Dungeon.new(40,40))
        _gameObjects = generator.objects
    }

    objects { _gameObjects }
}