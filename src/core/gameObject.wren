
class GameObject {
    static id { 
        if (__id) {
            __id = __id + 1
            return __id - 1
        }
        __id = 0
        return 0
    }

    construct new(graphicsComponent,physicsComponent,inputComponent) {
        _graphicsComponent = graphicsComponent
        _physicsComponent = physicsComponent
        _inputComponent = inputComponent
        _graphicsComponent.entity = this
        _physicsComponent.entity = this
        _otherData = {}
        if (_inputComponent) _inputComponent.entity = this
        _id = GameObject.id
    }

    update(gameObjects) {
        _physicsComponent.update(gameObjects)
    }

    handle() {
        _inputComponent.input()
    }

    undo() {
        _physicsComponent.undo()
    }

    draw(delta, bottom, right, xOffset, yOffset) {
        _graphicsComponent.draw(delta, _physicsComponent.pos.x,_physicsComponent.pos.y)
    }

    clone() {
        return GameObject.new(_graphicsComponent,_physicsComponent.clone(),_inputComponent)
    }

    physics { _physicsComponent }
    input { _inputComponent }
    graphics { _graphicsComponent }
    tags { _physicsComponent.tags }
    id { _id }
    [key]=(value) { _otherData[key] = value }
    [key] { _otherData[key] }
}