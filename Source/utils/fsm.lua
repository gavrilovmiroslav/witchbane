
local fsm = {}

function fsm:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.states = {}
    self.transitions = {}
    self.current = nil
    return o
end

function fsm:add_state(state)
    self.states[state] = 1
    if self.current == nil then
        self.current = state
    end
end

function fsm:add_link(from, to, name, event)
    if self.transitions[from] == nil then
        self.transitions[from] = {}
    end

    if self.transitions[from][name] == nil then
        self.transitions[from][name] = {}
    end

    self.transitions[from][name] = { to, event }
end

function fsm:follow(name, ...)
    if self.current ~= nil then
        if self.transitions[self.current] ~= nil then
            if self.transitions[self.current][name] ~= nil then
                local next, event = table.unpack(self.transitions[self.current][name])
                if event ~= nil then
                    event(...)
                end
                self.current = next
            else
                print("Warning: transition " .. name .. " is missing on state " .. self.current .. "!")
            end
        else
            print("Warning: state " .. self.current .. " is missing!")
        end
    end
end

return fsm