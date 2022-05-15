import "core/lib" for GameObject, PhysicsBody, InputController, Sprite, Animation
import "generation/cell" for Cell
import "math" for Vector
import "random" for Random
import "graphics" for Canvas, ImageData, Color

import "generation/dungeon" for Dungeon

class Generator {
    construct new(procGenStyle) {
        
        __playerData = {
            "physics" : PhysicsBody.new(["player","collider"], 24, 30),
            "wasd input" : InputController.new() { |entity, keyboard, mouse|
                entity.physics.stop()
                
                if (keyboard["W"].down) {
                    entity.physics.setForce(entity.physics.movement.x, -3)
                    entity.graphics.setSprite(1)
                } else if (keyboard["S"].down) {
                    entity.physics.setForce(entity.physics.movement.x, 3)
                    entity.graphics.setSprite(0)
                }

                if (keyboard["A"].down) {
                    entity.physics.setForce(-3, entity.physics.movement.y)
                    entity.graphics.setSprite(2)
                } else if (keyboard["D"].down) {
                    entity.physics.setForce(3, entity.physics.movement.y)
                    entity.graphics.setSprite(3)
                }
            },
            "spritesheet" : Animation.new([
                Sprite.new(ImageData.loadFromFile("res/Player.png").transform({"srcX":0, "srcY":4, "srcW":48, "srcH":60, "scaleX":1/2, "scaleY":1/2})),
                Sprite.new(ImageData.loadFromFile("res/Player.png").transform({"srcX":48, "srcY":4, "srcW":48, "srcH":60, "scaleX":1/2, "scaleY":1/2})),
                Sprite.new(ImageData.loadFromFile("res/Player.png").transform({"srcX":96, "srcY":4, "srcW":48, "srcH":60, "scaleX":1/2, "scaleY":1/2})),
                Sprite.new(ImageData.loadFromFile("res/Player.png").transform({"srcX":144, "srcY":4, "srcW":48, "srcH":60, "scaleX":1/2, "scaleY":1/2}))
            ],false).stop(),
        }

        __tile = {
            "collider" : PhysicsBody.new(["static","collider"], 32, 32),
            "floor" : PhysicsBody.new(["static"], 32, 32),
            "static" : null,
            "empty" : Sprite.new(Sprite.resize(ImageData.loadFromFile("res/EmptyTile.png"),1/2)),
            "wall" :  Sprite.new(Sprite.resize(ImageData.loadFromFile("res/StoneTile.png"),1/2)),

        }

        if (!__player) {
            __player = GameObject.new(__playerData["spritesheet"],__playerData["physics"],__playerData["wasd input"])
            __player.graphics.setSprite(0)


            __numToTile = {
                1 : GameObject.new(__tile["wall"],__tile["collider"],__tile["static"]),
                0 : GameObject.new(__tile["empty"],__tile["floor"],__tile["static"]),
            }

            __random = Random.new()
        }

        _gameObjects = []
        this.build(procGenStyle.world)
    }

    build(objects) {
        for (y in 0...objects.count) {
            for (x in 0...objects[0].count) {
                var tile = __numToTile[objects[y][x]].clone()
                tile.physics.pos(x * 32, y * 32)
                _gameObjects.add(tile)
            }
        }

        _gameObjects.add(__player)
    }

    objects { _gameObjects }
}