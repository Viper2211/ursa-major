from random import randint, choice

class Cell():
    EMPTY,FULL,DOOR = 1,2,3

    def __init__(self,kind):
        self.kind = kind
    
    def as_str(self):
        return " " if self.kind == Cell.EMPTY else "#" if self.kind == Cell.FULL else "D"

class Dungeon():
    dungeon = None
    print_dungeon = lambda self : [print(' '.join([i.as_str() for i in row])) for row in self.dungeon]
    windyness = 50
    room_attempts = 20
    dead_ends_removed = 30

    def __init__(self,width = 10, height = 10):
        self.dungeon = [[Cell(Cell.FULL) for _ in range(0,width)] for _ in range(0,height)]
        self.maze()
        self.rooms()
        self.dungeon.insert(0,[Cell(Cell.FULL) for _ in range(0,width)])
        self.dungeon.append([Cell(Cell.FULL) for _ in range(0,width)])
        for row in self.dungeon:
            row.insert(0,Cell(Cell.FULL))
            row.append(Cell(Cell.FULL))

    def maze(self):
        _maze = []
        _maze.append((randint(0,len(self.dungeon[0])),randint(0,len(self.dungeon)),(1,0)))

        def check(x,y):
            if x >= 0 and x < len(self.dungeon[0]) and y >= 0 and y < len(self.dungeon):
                criteria = [
                    (self.dungeon[y][x-1].kind != Cell.EMPTY) if x > 0 else False,
                    (self.dungeon[y][x+1].kind != Cell.EMPTY) if x < len(self.dungeon[0])-1 else False,
                    (self.dungeon[y-1][x].kind != Cell.EMPTY ) if y > 0 else False,
                    (self.dungeon[y+1][x].kind != Cell.EMPTY) if y < len(self.dungeon)-1 else False,
                ]
                try:
                    if self.dungeon[y][x].kind != Cell.EMPTY and criteria.count(True) >=3:
                        return True
                except:
                    pass
            return False

        def grow_maze():
            x,y,last_dir = _maze[-1]
            self.dungeon[y][x].kind = Cell.EMPTY


            directions = list(filter(lambda x : x[2],[(x-1,y,check(x-1,y)),(x+1,y,check(x+1,y)),(x,y-1,check(x,y-1)),(x,y+1,check(x,y+1))]))
            if len(directions) > 0:
                if randint(0,100) > self.windyness:
                    direction = last_dir
                else:
                    direction = choice(directions)
                _maze.append((direction[0],direction[1],(direction[0]-x,direction[1]-y)))
                self.dungeon[y][x].kind = Cell.EMPTY
            else:
                _maze.pop(-1)

        def remove_dead_ends():
            removed = 0
            while removed < self.dead_ends_removed:
                x = randint(0,len(self.dungeon[0])-1)
                y = randint(0,len(self.dungeon)-1)
                if not check(x,y):
                    self.dungeon[y][x].kind = Cell.FULL
                    removed += 1

        while len(_maze) > 0:
            grow_maze()
        
        remove_dead_ends()

    def rooms(self):
        _rooms = []
        
        def create_room(x,y):
            width = randint(3,6)
            height = randint(3,6)

            def collided():
                for room in _rooms:
                    other_x, other_y, other_w, other_h = room
                    if x > other_x - 1 and x < other_x + other_w + 1  and y > other_y - 1 and y < other_y + other_h + 1:
                        return True 
                return False

            if not collided():
                _rooms.append((x,y,width,height))

        def fill_rooms():
            for room in _rooms:
                x, y, w, h = room
                for x_ in range(x,x+w):
                    for y_ in range(y,y+h):
                        try:
                            self.dungeon[y_][x_].kind = Cell.EMPTY
                        except:
                            pass

        for _ in range(self.room_attempts):
            create_room(randint(0,len(self.dungeon[0])),randint(0,len(self.dungeon)))
        fill_rooms()


dungeon = Dungeon(50,50)
dungeon.print_dungeon()
