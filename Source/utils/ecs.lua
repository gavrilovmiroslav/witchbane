
local ecs = {}

function table.copy(t)
    local u = { }
    for k, v in pairs(t) do u[k] = v end 
    return setmetatable(u, getmetatable(t))
end

function ecs:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.archetypes = {}
    self.components = {}
    return o
end

function ecs:comp(name)
    return function(vals)
        vals["_name"] = name
        return vals
    end
end

function ecs:spawn(...)
    table.insert(self.archetypes, {})
    local idx = #self.archetypes
    self:attach(idx, arg)
    return idx
end

function ecs:get_archetype(idx)
    return self.archetypes[idx] or {}
end

function ecs:attach(idx, ...)
    if arg == nil then return end
    if #arg == 0 then return end

    for _, comp in ipairs(arg) do
        if comp["_name"] ~= nil then
            local c = comp["_name"]
            if self.components[c] == nil then
                self.components[c] = {}
            end

            if self.components[c][idx] == nil then
                self.archetypes[idx][c] = true
                self.components[c][idx] = comp
            else
                print("Cannot attach: entity " .. tostring(idx) .. " already has a component of type " .. c)
            end
        else
            print("Cannot attach: table value not a component")
        end
    end
end

function ecs:detach(idx, ...)
    if arg == nil then return end

    for _, name in ipairs(arg) do
        if self.components[name] ~= nil then
            self.components[name][idx] = nil
        end

        if self.archetypes[idx] ~= nil then
            self.archetypes[idx][name] = nil
        end
    end
end

function ecs:query(...)
    if arg == nil then return end

    local results = nil
    for _, name in ipairs(arg) do
        if results == nil then
            results = table.copy(self.components[name])
        else
            for idx, _ in pairs(results) do
                if not self.archetypes[idx][name] then
                    results[idx] = nil
                end
            end
        end
    end
    return results
end

return ecs