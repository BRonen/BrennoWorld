local anim8 = require 'anim8'

function character(path, name)
  local char = {name=name, stop = true, state = "f"}

  local spriteInfo = {
    { 'b' , 9, '2-9', 0.1 },
    { 'l' , 10, '1-9', 0.2 },
    { 'f' , 11, '2-9', 0.1 },
    { 'r' , 12, '1-9', 0.2 }
  }

  char.spriteset = love.graphics.newImage(path)
  char.animation = newAnimations(char.spriteset, spriteInfo, 64, 64)

  function char:init(x, y)
    self.body = love.physics.newBody(World, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(14)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self.name)
    self.fixture:setRestitution(0.2)
  end

  function char:setState(state)
    self.state = state
  end

  function char:stop()
    self.animation[self.state]:gotoFrame(1)
    self.animation[self.state]:pause()
  end

  function char:resume()
    self.animation[self.state]:resume()
  end

  function char:update(dt)

    self.body:setLinearVelocity(0, 0) --stop player

    self.animation[self.state]:update(dt) --update animation (anim8)

    self:resume() --resume (if already resume, just do nothing)

    self:setState(self.move.direction) --update player's direction

    self.body:applyForce(self.move.vecX, self.move.vecY) --move player

    if self.move.vecX == 0 and self.move.vecY == 0 then --if stopped
      self:stop()
    end
    self.move.vecX, self.move.vecY = 0, 0 --reset velocity
  end

  char.move = {direction = "f", vecX=0, vecY=0} --improve this
  function char.move:right(dt)
    self.vecX = 700000*dt
    self.direction = "r"
  end
  function char.move:left(dt)
    self.vecX = -700000*dt
    self.direction = "l"
  end
  function char.move:up(dt)
    self.vecY = -700000*dt
    self.direction = "b"
  end
  function char.move:down(dt)
    self.vecY = 700000*dt
    self.direction = "f"
  end

  function char:draw()
    local x, y = self.body:getPosition()
    self.animation[self.state]:draw( 
      self.spriteset,
      x-32, y-48
    )
  end

  return char
end

function newAnimations(spriteset, spriteInfo, width, height)
  local animations = {}
  local g = anim8.newGrid(width, height, spriteset:getWidth(), spriteset:getHeight(), 0, 0)
  for _, grids in ipairs(spriteInfo) do
    animations[grids[1]] = anim8.newAnimation(g(grids[3],grids[2] ,2, grids[2]), grids[4])
  end
  return animations
end
