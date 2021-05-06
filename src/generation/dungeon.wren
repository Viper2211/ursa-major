import "random" for Random
import "math" for Vector
import "generation/cell" for Cell

class Dungeon {
    construct new(width, height) {
        _world = []
        for (i in 0...width) {
            var row = []
            for (j in 0...height) {
                row.add(Cell.WALL)
            }
            _world.add(row)
        }

        _random = Random.new()

        _roomAttempts = width

        maze()
        rooms()
    }

    world { _world }

    maze() {
        var maze = [Vector.new(5,5)]
        _world[5][5] = Cell.EMPTY

        while (maze.count > 0) {
            growMaze_(maze)
        }
    }

    growMaze_(maze) {
        var x = maze[maze.count - 1].x
        var y = maze[maze.count - 1].y

        var directions = [
            check_(x - 1, y),
            check_(x + 1, y),
            check_(x, y - 1),
            check_(x, y + 1)
        ]

        var validDirections = []
        directions.each() {|n|
            if (n) {
                validDirections.add(n)
            }
        }

        if (validDirections.count > 0) {
            var position = _random.sample(validDirections)

            if (!maze.contains(position)) {
                maze.add(position)
                _world[position.y][position.x] = Cell.EMPTY
            }
        } else {
            maze.removeAt(maze.count - 1)
        }
    }

    check_(x, y) {
        var surroundingCells_ = Fn.new () {
            var criteria = 0
            if (x > 0 && _world[y][x - 1] != Cell.EMPTY) { criteria = criteria + 1 }
            if (y > 0 && _world[y - 1][x] != Cell.EMPTY) { criteria = criteria + 1 }
            if (x < _world[0].count - 1 && _world[y][x + 1] != Cell.EMPTY) { criteria = criteria + 1 }
            if (y < _world.count - 1 && _world[y + 1][x] != Cell.EMPTY) { criteria = criteria + 1 }

            return criteria
        }

        if (x >= 0 && x < _world[0].count && y >= 0 && y < _world.count) {
            if (_world[y][x] != Cell.EMPTY && surroundingCells_.call() >= 3) {
                return Vector.new(x,y)
            }
        }

        return false
    }

    rooms() {
        var rooms_ = []

        for (n_ in 0.._roomAttempts) {
            createRoom_(_random.int(0, _world[0].count - 1), _random.int(0, _world.count - 1), rooms_)
        }
        fillRooms_(rooms_)
    }

    createRoom_(x, y, rooms) {
        var w = _random.int(4,7)
        var h = _random.int(3,6)

        var room = [Vector.new(x, y), Vector.new(w, h)]

        for (otherRoom in rooms) {
            if (collided_(room, otherRoom)) {
                return
            }
        }

        rooms.add(room)
    }

    fillRooms_(rooms) {
        for (room in rooms) {
            var x = room[0].x
            var y = room[0].y
            var w = room[1].x
            var h = room[1].y

            for (x_ in x..(x + w)) {
                for (y_ in y..(y + h)) {
                    Fiber.new {
                        _world[y_][x_] = Cell.EMPTY
                    }.try()
                }
            }
        }
    }

    collided_(room1, room2) {
        var x = room1[0].x
        var y = room1[0].y
        var w = room1[1].x
        var h = room1[1].y

        var x2 = room2[0].x
        var y2 = room2[0].y
        var w2 = room2[1].x
        var h2 = room2[1].y

        if (x > x2 - 1 && x < x2 + w2 + 1 && y > y2 - 1 && y < y2 + h2 + 1) {
            return true
        }

        return false
    }
}