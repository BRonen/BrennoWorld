local Camera = require 'Camera'
mapper = require 'map'
require 'character'

Statics = {}
Colisoes = {}

function createStatic(label,x,y,w,h)
  local static = {}
  static.body = love.physics.newBody(World, x,y, "static")
  static.shape = love.physics.newRectangleShape(w,h)
  static.fixture = love.physics.newFixture(static.body, static.shape)
  static.fixture:setUserData(label)

  Colisoes[label] = function(target)  end

  return static
end

function createPortal(target,x,y,w,h)
  local static = {}
  static.body = love.physics.newBody(World, x,y, "static")
  static.shape = love.physics.newRectangleShape(w,h)
  static.fixture = love.physics.newFixture(static.body, static.shape)
  static.fixture:setUserData('Portal')

  Colisoes['Portal'] = function()
    print("Player collision between with Portal")
    mapper:new(target)
    Statics = {}

    World:setCallbacks(beginContact, endContact)
    player = character('/skins/skeleton.png', "Player")
    player:init(400,300)
    player.body:setMass(5)
  end

  return static
end

function setKeyCallback(...)
  local callbacks = {}
  callbacks["d"] = function() Debug = not Debug end
  callbacks["q"] = function() debug.debug() end
  callbacks["escape"] = function() love.event.push('quit') end
  callbacks["e"] = function() Cam.scale = Cam.scale + 1 end
  callbacks["q"] = function() Cam.scale = Cam.scale - 1 end
  return ... or callbacks
end

function love.load(args)
  local time = love.timer.getTime( )

  love.graphics.setDefaultFilter('nearest', 'nearest');

  love.window.setTitle('Test')

  Debug = true

  love.physics.setMeter(64)

  mapper:new('/maps/chez-peter.lua')

  World:setCallbacks(beginContact, endContact)

  keyCallback = setKeyCallback()

  player = character('/skins/skeleton.png', "Player")
  player:init(400,300)
  player.body:setMass(5)

  Cam = Camera()
  --Cam:setFollowStyle('LOCKON')
  --Cam:setFollowLerp(2)
  --Cam:setFollowLead(0.5)
  Cam.scale = 1

  if Debug then print("love.load: " .. love.timer.getTime( ) - time) end
end

function love.draw()
  Cam:attach()

  mapper:drawMap()
  player:draw()

  if Debug then
    love.graphics.circle("line",
      player.body:getX(),
      player.body:getY(),
      player.shape:getRadius()
    )--player

    for _, obj in ipairs(Statics) do
      love.graphics.polygon("fill",
        obj.body:getWorldPoints(
          obj.shape:getPoints()
        )
      ) --Static blocks
    end

    local touches = love.touch.getTouches()

    for _, id in ipairs(touches) do
        local x, y = love.touch.getPosition(id)
        love.graphics.circle("fill", x, y, 20)
    end

    love.graphics.print('FPS: ' .. love.timer.getFPS(), Cam:toWorldCoords(40, 48))
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', Cam:toWorldCoords(40, 64))
  end

  mapper:drawMinimap()

  Cam:detach()
  Cam:draw()
end

function love.touchpressed(id, x, y)
end

function love.mousepressed(x, y)
end

function love.gamepadpressed()
  return
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    player.move:right(dt)
  end
  if love.keyboard.isDown("left") then
    player.move:left(dt)
  end
  if love.keyboard.isDown("up") then
    player.move:up(dt)
  end
  if love.keyboard.isDown("down") then
    player.move:down(dt)
  end

  Cam:update(dt)
  World:update(dt)
  player:update(dt)
  Cam:follow(player.body:getPosition())
end

function love.keypressed(key)
  if keyCallback[key] then keyCallback[key]() end
  print(key)
end

function beginContact(a, b, coll)
  print("\n\n"..a:getUserData() .. " colidded " .. b:getUserData())
  print("pre collision")
  print("pos collision\n")
end

function endContact(a, b, coll)
  print("\n"..a:getUserData().." uncolliding with "..b:getUserData())
end
