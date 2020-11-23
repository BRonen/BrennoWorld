local map = {}

function map:new(path)
  local time = love.timer.getTime( )
  if World then World:destroy() end
  World = love.physics.newWorld()

  self.tileTable, self.tileSet, self.quads, self.lineWidth = love.filesystem.load(path)()
  
  print(#self.tileTable)
  map.canvas = love.graphics.newCanvas(
    (#self.tileTable/(self.lineWidth/3))*TileH,
    (self.lineWidth)*TileW
  )
  love.window.setMode(800, 600)

  map.canvas:renderTo(function()
  
    for i=1,#self.tileTable do
      local tile = self.tileTable[i]
      
      if tile ~= "/" then
        local x = math.floor(i%(self.lineWidth))
        local y = math.floor(i/(self.lineWidth))

        print("'"..self.tileTable[i].."'")

        love.graphics.draw(
          self.tileSet, self.quads[tile],
          (x-1)*TileW, (y-1)*TileH
        )
      end
    end
    
  end) --set render function to canvas

  map.canvasImg = love.graphics.newImage(
    map.canvas:newImageData( )
  )
  if Debug then print("Loading map: " .. love.timer.getTime( ) - time) end
end

function map:drawMap()
  love.graphics.draw(map.canvasImg) --render canvas
end
function map:drawMinimap()
  local x, y = Cam:toWorldCoords(
    800-16-map.canvasImg:getWidth()/10, --minimap width
    --map.canvasImg:getHeight()/10
    16--minimap height
  )

  --minimap width + playerX/10, minimap height + playerY/10 
  local px, py = x+player.body:getX()/10, y+player.body:getY()/10

  love.graphics.draw(
    map.canvasImg,
    x, y, 0, 0.1, 0.1
  )
  love.graphics.rectangle("fill", px-2, py-2, 5, 5)
end

return map
