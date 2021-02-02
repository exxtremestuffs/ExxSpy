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

function Package.newClass(name: string, class: {string: any}, constructor: function | nil)
    assert(Package.unionCheckTypeOf({
        [name] = "string",
        [class] = "table",
        [constructor] = "function | nil"
    }))
    class.__index = class
    if type(class.init) == "function" then
        local c = {}
        c.new = function(...)
            local object = {}
            class.__tostring = function()
                return name .. tostring(class):match(":.+")
            end
            setmetatable(object, class)
            constructor(object, ...)
            return object
        end
        c.__index = c
        local namespace = {}
        c.__tostring = function()
            return name .. tostring(c):match(":.+")
        end
        setmetatable(namespace, c)
        return namespace
    else
        local namespace = {}
        class.__tostring = function()
            return name .. tostring(class):match(":.+")
        end
        setmetatable(namespace, class)
        return namespace
    end
end

function Package.extend(child: {string: any}, parent: {string: any})
    local oldindex
    if getmetatable(parent) then
        oldindex = getmetatable(parent).__index
    end
    local mt = {
        __index = function(t, k)
            if parent[k] then
                return parent[k]
            end
            if type(oldindex) == "function" then
                return oldindex(t, k)
            elseif type(oldindex) == "table" then
                return oldindex[k]
            end
        end
    }
    setmetatable(child, mt)
    return child
end

getgenv().Package = Package

return Package