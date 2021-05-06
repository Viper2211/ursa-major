import "graphics" for Canvas, ImageData, Color
import "./level" for Level

class Game {
    static init() {
        __distanceToBottom = Canvas.height
        __distanceToRight = Canvas.width
        var level = Level.new()
        level.generate()
        __gameObjects = level.objects
        __startPosition = __gameObjects[__gameObjects.count - 1].physics.pos(162, 160)
        __gameObjects[__gameObjects.count - 1]["start"] = __startPosition
    }

    static update() {
        for (object in __gameObjects) {
            if (!object.tags.contains("static")) object.update(__gameObjects)
            if (object.input) object.handle()
        }
    }

    static draw(delta) {
        var player = __gameObjects[__gameObjects.count - 1]
        var newPosition = [__startPosition.x - player.physics.pos.x - 12, __startPosition.y - player.physics.pos.y - 16]
        Canvas.cls()
        Canvas.offset(newPosition[0], newPosition[1])
        for (object in __gameObjects) {
            object.draw(delta,__distanceToBottom,__distanceToRight, 0, 0)
            //if (!object.tags.contains("static")) Canvas.rect(object.physics.pos.x, object.physics.pos.y, object.physics.size.x, object.physics.size.y, Color.red)
        }

    }
}