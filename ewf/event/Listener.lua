local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.Listener = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Listener = ewf.event.Listener;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Listener:class(child)
   child = child or {};

   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Listener:new(event, callback, unit)
   local newInstance = Listener:class();

   newInstance.event = event;
   newInstance.callback = callback;

   return newInstance;
end

function Listener:getEvent()
   return self.event;
end

function Listener:getCallback()
   return self.callback;
end
