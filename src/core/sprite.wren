import "graphics" for ImageData, Drawable

class Sprite {
    static resize(image,scale) {
        if (image is String) {
            image = ImageData.loadFromFile(image)
        }

        return image.transform({
            "scaleX": scale,
            "scaleY": scale
        })
    }

    construct new(value) {
        if (value is String) {
            _image = ImageData.loadFromFile(value)
        } else if (value is ImageData || value is Drawable) {
            _image = value 
        } else {
            Fiber.abort("Sprite : Expected either a String or ImageData")
        }
        _w = 16
        _h = 16
    }

    construct new(value,w,h) {
        if (value is String) {
            _image = ImageData.loadFromFile(value)
        } else if (value is ImageData || value is Drawable) {
            _image = value 
        } else {
            Fiber.abort("Sprite : Expected either a String or ImageData")
        }
        _w = w
        _h = h
    }

    draw(delta,x,y) { _image.draw(x,y) }
    w { _w }
    h { _h }

    entity { _entity }
    entity=(value) { _entity = value }
}

class Animation {
    construct new(sprites) {
        _sprites = sprites
        _step = 0
        _loop = false
        _on = true
    }

    construct new(sprites,loop) {
        _sprites = sprites
        _step = 0
        _loop = loop
        _on = true
    }

    draw(delta,x,y) { 
        if (_step >= 0) {
            nextSprite().draw(delta,x,y) 
        }
    }
    start() { 
        _step = 0 
        _advance = true
        return this
    }
    stop() { 
        _step = -1 
        _advance = false
        return this
    }
    nextSprite() {
        if (_step >= _sprites.count) {
            if (_loop) _step = 0 else _step = -1
        }

        if (_step < 0) {
            return null
        }

        var image = _sprites[_step]
        if (_advance) _step = _step + 1

        return image
    }
    setSprite(idx) {
        _step = idx
        _advance = false
    }

    w { _sprites[0].w }
    h { _sprites[0].h }
    step { _step }
    loop { _loop }
    loop=(value) { _loop = value }
    advance { _advance }
    advance=(value) { _advance = value }

    entity { _entity }
    entity=(value) { 
        _entity = value
        for (sprite in _sprites) {
            sprite.entity = _entity
        }
    }
}