import "input" for Keyboard, Mouse

class InputController {
    construct new(callback) {
        _callback = callback
    }

    input() { _callback.call(entity, Keyboard, Mouse) }

    entity { _entity }
    entity=(value) { _entity = value }
}