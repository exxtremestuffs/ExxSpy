--[[
    EXXPACKAGE - A LIGHTWEIGHT PACKAGE MANAGER FOR LUA
]]

local Package = {}

--- Checks type for assert- uses typeof
function Package.checkTypeOf(x: any, types: string)
    local match
    for type in string.gmatch(types, "%a+") do
        if typeof(x) == type then
            match = true
        end
    end
    return match, match and "" or string.format("'%s' expected, got '%s'", type, typeof(x))
end

--- Checks type for assert- also checks instance subclasses
function Package.checkTypeIs(x: any, types: string)
    if typeof(x) == "Instance" then
        local match = false
        for type in string.gmatch(types, "%a+") do
            if x:IsA(type) then
                match = true
            end
        end
        return match, match and "" or string.format("'%s' expected, got '%s'", types, x.ClassName)
    else
        return Package.checkTypeOf(x, types)
    end
end

--- Checks type of dictionary for assert- uses typeof
function Package.unionCheckTypeOf(dictionary: {string: any})
    for types, x in pairs(dictionary) do
        local match, msg = Package.checkTypeOf(x, types)
        if not match then
            return match, msg
        end
    end
    return true, ""
end

--- Checks type of dictionary for assert- also checks instance subclasses
function Package.unionCheckTypeIs(dictionary: {string: any})
    for x, types in pairs(dictionary) do
        local match, msg = Package.checkTypeIs(x, types)
        if not match then
            return match, msg
        end
    end
    return true, ""
end

function Package.newClass(constructor: function | nil, public: table | nil, private: table | nil, publicStatic: table | nil, privateStatic: table | nil)
    assert(Package.unionCheckTypeOf({
        [constructor] = "function | nil",
        [public] = "table | nil",
        [private] = "table | nil",
        [publicStatic] = "table | nil",
        [privateStatic] = "table | nil"
    }))
end

function Package.extend()

end

getgenv().Package = Package

return Package