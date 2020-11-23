local tileString = [[
#########################
# AAA^AAAAAA      # ^^^ #
# |||@||||||      # @@@ #
#                 #     #
# AAAAAAA^AA      ### ###
# |||||||@||        # # #
#                   * * #
# *                 l l #
# l                     #
#         ^             #
#         @             #
# *                     #
# l                     #
#                       #
# AAAAA^AAA^AAA^    ^^  #
# |||||@|||@|||@    @@  #
#                       #
#################&&######
]]

TileW, TileH = 32, 32

local quadInfo = {
  { ' ',  0,  0 }, -- gray floor
  { '#',  0, 32 }, -- brick wall
  { '^', 32,  0 }, -- mainframe 1 top
  { '@', 32, 32 }, -- mainframe 1 bottom
  { 'A', 64,  0 }, -- mainframe 2 top
  { '|', 64, 32 }, -- maingrame 2 bottom
  { '*', 96,  0 }, -- plant top
  { 'l', 96, 32 }, -- plant bottom
  { '&',  0,  0 }  -- gray floor
}

local especialsInfo = {}

especialsInfo['#'] = function(rowIndex, columnIndex)
  table.insert( Statics, createStatic( --add static blocks to collid
    "Block",
    ((columnIndex-1)*32)-16, (rowIndex*32)-16,
    TileW-2, TileH-2
  ) ) --add static blocks to collid
end
especialsInfo['&'] = function(rowIndex, columnIndex)
  table.insert( Statics, createPortal( --add static blocks to collid
    "maps/chez-peter.lua",
    ((columnIndex-1)*32)-16, (rowIndex*32)-16,
    TileW-2, TileH-2
  ) ) --add static blocks to collid
end

quadInfo.path = '/tiles/lab.png' --tileImagePath

return tileString, quadInfo, especialsInfo
