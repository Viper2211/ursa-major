import "./level" for Level
import "./menu" for Menu

class Game {
    static init() {
        __level = Level.new()
        __level.init()
    }

    static update() {
        __level.update()
    }

    static draw(delta) {
        __level.draw(delta)
    }
}