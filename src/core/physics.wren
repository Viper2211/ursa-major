import "math" for Vector

class PhysicsBody {
    construct new(tags, width, height) {
        _pos = Vector.new(0,0)
        _size = Vector.new(width, height)
        _movement = Vector.new(0,0)
        _tags = tags
    }

    update(gameObjects) {
        var moved = 0
        var attempts = _movement.x.abs.max(_movement.y.abs)

        while (moved < attempts) {
     
            if (_movement.x.abs > 0) {
                _pos = _pos + Vector.new(_movement.x.sign, 0)

                if (collided(gameObjects)) {
                    _pos = _pos - Vector.new(_movement.x.sign, 0)
                }
            }

            if (_movement.y.abs > 0) {
                _pos = _pos + Vector.new(0, _movement.y.sign)

                if (collided(gameObjects)) {
                    _pos = _pos - Vector.new(0, _movement.y.sign)
                }
            }

            moved = moved + 1
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
        var temp = PhysicsBody.new(_tags,_size.x,_size.y)
        temp.pos(_pos.x, _pos.y)
        return temp
    }

    pos { _pos }
    pos(x,y) { 
        _pos = Vector.new(x,y) 
        return _pos
    }
    size { _size }
    movement { _movement }
    tags { _tags }

    entity { _entity }
    entity=(value) { _entity = value }
}