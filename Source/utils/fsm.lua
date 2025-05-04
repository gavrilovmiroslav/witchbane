
local fsm = {}

function fsm:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.states = {}
    self.transitions = {}
    self.on_enter = {}
    self.on_exit = {}
    self.on_draw = {}
    self.on_update = {}
    self.current = nil
    return o
end

function fsm:add_state(state)
    self.states[state] = 1
    if self.current == nil then
        self.current = state
    end
end

function fsm:add_on_enter_hook(state, fn)
    self.on_enter[state] = fn
end

function fsm:add_on_exit_hook(state, fn)
    self.on_exit[state] = fn
end

function fsm:add_on_update_hook(state, fn)
    self.on_update[state] = fn
end

function fsm:add_on_draw_hook(state, fn)
    self.on_draw[state] = fn
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

function fsm:update()
    if self.current ~= nil then
        if self.on_update[self.current] ~= nil then
            self.on_update[self.current]()
        end
    end
end

function fsm:draw()
    if self.current ~= nil then
        if self.on_draw[self.current] ~= nil then
            self.on_draw[self.current]()
        end
    end
end

function fsm:follow(name, ...)
    if self.current ~= nil then
        if self.transitions[self.current] ~= nil then
            if self.transitions[self.current][name] ~= nil then
                local next, event = table.unpack(self.transitions[self.current][name])
                if self.on_exit[self.current] ~= nil then
                    self.on_exit[self.current]()
                end
                if event ~= nil then
                    event(...)
                end
                self.current = next
                if self.on_enter[self.current] ~= nil then
                    self.on_enter[self.current]()
                end
            else
                print("Warning: transition " .. name .. " is missing on state " .. self.current .. "!")
            end
        else
            print("Warning: state " .. self.current .. " is missing!")
        end
    end
end

function fsm:init()
    if self.current ~= nil then
        if self.on_enter[self.current] ~= nil then
            self.on_enter[self.current]()
        end
    end
end

return fsm