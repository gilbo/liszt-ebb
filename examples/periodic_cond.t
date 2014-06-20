import "compiler.liszt"
local Grid  = L.require 'domains.grid'

local xn = 2
local yn = 3

local grid = Grid.NewGrid2d{size           = {xn, yn},
                            origin         = {0, 0},
                            width          = 1,
                            height         = 1,
                            boundary_depth = {1, 1},
                            periodic_boundary = {true, true} }

grid.cells:NewField('field', L.uint64):LoadConstant(0)

local Init = liszt kernel(c : grid.cells)
    c.field = xn * c.yid + c.xid
end

local Check = liszt kernel(c : grid.cells)
    L.assert( c.field == c(-xn,0).field)
    L.assert( c.field == c(0,-yn).field)
    L.assert( c.field == c(-xn,-yn).field)
    L.assert( c.field == c(xn,0).field)
    L.assert( c.field == c(0,yn).field)
    L.assert( c.field == c(xn,yn).field)
    L.assert( c.field == c(-xn,yn).field)
    L.assert( c.field == c(xn,-yn).field)
end

Init(grid.cells)
Check(grid.cells)

print(grid:xBoundaryDepth())
print(grid:yBoundaryDepth())