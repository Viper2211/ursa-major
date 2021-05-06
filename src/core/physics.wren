import "math" for Vector

class PhysicsBody {
    construct new(tags, width, height, callback) {
        _callback = callback
        _pos = Vector.new(0,0)
        _size = Vector.new(width, height)
        _movement = Vector.new(0,0)
        _speed = 1
        _tags = tags
    }

    update(gameObjects) {
        var movement = _movement

        _pos = _pos + movement * _speed

        if (collided(gameObjects)) {
            _pos = _pos - movement * _speed
        } else {
            _callback.call(entity)
            return
        }

        _pos = _pos + Vector.new(0, movement.y) * _speed

        if (collided(gameObjects)) {
            _pos = _pos - Vector.new(0, movement.y) * _speed
        } else {
            _callback.call(entity)
            return
        }

        _pos = _pos + Vector.new(movement.x, 0) * _speed

        if (collided(gameObjects)) {
            _pos = _pos - Vector.new(movement.x, 0) * _speed
        } else {
            _callback.call(entity)
            return
        }

    }

    collided(gameObjects) {
        if (this.tags.contains("collider")) {
            for (otherObject in gameObjects) {
                if (this.entity.id != otherObject.id) {
                    if (otherObject.tags.contains("collider") && collided_(otherObject.physics)){
                        return true
                    }
                }
            }
        }
        return false
    }

    collided_(other) {
        var x = _pos.x
        var y = _pos.y
        var w = _size.x
        var h = _size.y
        var otherX = other.pos.x
        var otherY = other.pos.y
        var otherW = other.size.x
        var otherH = other.size.y

        if (x <= otherX + otherW && x + w >= otherX && y <= otherY + otherH && y + h >= otherY){
            return true
        }

        return false
    }

    applyForce(x,y) { 
        _movement = _movement + Vector.new(x,y)
        return this.entity
    }
    setForce(x,y) { 
        _movement = Vector.new(x,y) 
        return this.entity
    }
    stop() { 
        _movement = Vector.new(0,0) 
        return this.entity
    }
    clone() {
        var temp = PhysicsBody.new(_tags,_size.x,_size.y,_callback)
        temp.pos(_pos.x, _pos.y)
        temp.speed = _speed
        return temp
    }

    pos { _pos }
    pos(x,y) { 
        _pos = Vector.new(x,y) 
        return _pos
    }
    size { _size }
    speed { _speed }
    speed=(value) { _speed = value }
    movement { _movement }
    tags { _tags }

    entity { _entity }
    entity=(value) { _entity = value }
}