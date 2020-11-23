
local tileString = [[
  ################################  ###
  #           #                #      #
  #           #  L[]R   L[]R   # L[]R #
  #           #  L()R   L()R   # L()R #
  #           #                #      #
  #           #                ###  ###
  #           #  L[]R   L[]R          #
  #           #  L()R   L()R    L[]R  #
  #                             L()R  #
  #           #  L[]R   L[]R          #
  #           #  L()R   L()R   ###  ###
  #           #                #LL  RR#
  #           #                #LL  RR#
  #           #  L[]R   L[]R   #LL  RR#
  #           #  L()R   L()R   #LL  RR#
  #           #                #LL  RR#
  #####################################
]]

TileW, TileH = 32, 32

local lineWidth = 39--#(tileString:match("[^\n]+"))
tileString = tileString:gsub("\n", "")

local quadInfo = {
  { ' ',  0,  0 }, -- floor
  { '[', 32,  0 }, -- table top left
  { ']', 64,  0 }, -- table top right
  { '(', 32, 32 }, -- table bottom left
  { ')', 64, 32 }, -- table bottom right
  { 'L',  0, 32 }, -- chair on the left
  { 'R', 96, 32 }, -- chair on the right
  { '#', 96,  0 }, -- bricks
  { '@',  0,  0 }  -- portal
}

local function isStatic(columnIndex, rowIndex)
  table.insert( Statics, createStatic( --add static blocks to collid
    "Block",
    ((columnIndex-1)*32)-16, (rowIndex*32)-16,
    TileW-2, TileH-2
  ) ) --add static blocks to collid
end

local especialsInfo = {}

especialsInfo['#'] = isStatic -- bricks

especialsInfo['['] = isStatic -- table top left
especialsInfo[']'] = isStatic -- table top right
especialsInfo['('] = isStatic -- table bottom left
especialsInfo[')'] = isStatic -- table bottom right

especialsInfo['@'] = function(rowIndex, columnIndex)
  table.insert( Statics, createPortal(
    "maps/core-dump.lua",
    ((columnIndex-1)*32)-16, (rowIndex*32)-16,
    TileW-2, TileH-2
  ) )
end

local path = '/tiles/resto.png' --tileImagePath

local tileTable = {}

local index = 1
for tile in tileString:gmatch(".") do
  table.insert(tileTable, tile)

  if character ~= "/" then
    if especialsInfo[tile] then --if has especial properties
      local x, y = math.floor(index%lineWidth)+1, math.floor(index/lineWidth)
      especialsInfo[tile](x, y)
    end
  end
  index = index+1
end
index = nil

local tileSet = love.graphics.newImage(path)
  
local tilesetW, tilesetH = tileSet:getWidth(), tileSet:getHeight()

quads = {}

for _,info in ipairs(quadInfo) do
  -- info[1] = the character, info[2] = x, info[3] = y
  quads[info[1]] = love.graphics.newQuad(
    info[2], info[3],
    TileW,  TileH,
    tilesetW, tilesetH
  )--piece by piece in "dictionary"
end

return tileTable, tileSet, quads, lineWidth
