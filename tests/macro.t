import "compiler.liszt"

local R = L.NewRelation(4,"relation")
R:NewField("result", L.uint64)

-- This macro emits a side effect every time it is evaluated
local side_effect = L.NewMacro(function(x)
	return liszt quote
		L.print(L.id(x))
	in
		x
	end
end)

local test_macro = L.NewMacro(function (y)
	return liszt `L.id(y)+ L.id(y)
end)

local liszt kernel test (r : R)
	--side effect should only be evaluated once!
	r.result = test_macro(side_effect(r))

end

test(R)