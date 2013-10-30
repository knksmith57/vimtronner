directions = require './directions'
Wall = require './wall'
buffer = require './buffer'

CYCLE_CHAR = []
CYCLE_CHAR[directions.UP] = buffer(0xe2, 0x95, 0xbf)
CYCLE_CHAR[directions.DOWN] = buffer(0xE2, 0x95, 0xBD)
CYCLE_CHAR[directions.LEFT] = buffer(0xE2, 0x95, 0xBE)
CYCLE_CHAR[directions.RIGHT] = buffer(0xE2, 0x95, 0xBC)

class Cycle
  constructor: (x, y, direction, color)->
    @x = x
    @y = y
    @direction = direction
    @color = color
    @walls = []

  character: ->
    CYCLE_CHAR[@direction]

  move: ->
    @walls.push new Wall(@x, @y, @nextWallType())
    switch @direction
      when directions.UP
        @y -= 1 unless @y == 1
      when directions.DOWN
        @y += 1 unless @y == process.stdout.rows
      when directions.LEFT
        @x -= 1 unless @x == 1
      when directions.RIGHT
        @x += 1 unless @x == process.stdout.columns

  nextWallType: ->
    lastWallType = @walls.last?.type
    lastWallType ?= switch @direction
      when directions.UP, directions.DOWN
        Wall.WALL_TYPES.NORTH_SOUTH
      when directions.LEFT, directions.RIGHT
        Wall.WALL_TYPES.EAST_WEST

  turnLeft: -> @direction = directions.LEFT unless @direction is directions.RIGHT
  turnRight: -> @direction = directions.RIGHT unless @direction is directions.LEFT
  turnUp: -> @direction = directions.UP unless @direction is directions.DOWN
  turnDown: -> @direction = directions.DOWN unless @direction is directions.UP

module.exports = Cycle