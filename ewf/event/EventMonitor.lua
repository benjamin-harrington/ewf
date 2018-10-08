local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.EventMonitor = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local EventMonitor = ewf.event.EventMonitor;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function EventMonitor:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function EventMonitor:new(name)
   local newInstance = EventMonitor:class({name=name, frame=CreateFrame("FRAME"), eventListeners={},});

   newInstance:registerEventHandler();

   return newInstance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- REGISTER EVENT HANDLER
----------------------------------------------------------------------------------------------------------------------------------
function EventMonitor:registerEventHandler()
   local _self = self;

   local script = function(self, event, ...)
      for _, callback in pairs(_self.eventListeners[event]) do
         callback(...);
      end
   end

   self.frame:SetScript("OnEvent", script);
end

----------------------------------------------------------------------------------------------------------------------------------
-- SETTERS
----------------------------------------------------------------------------------------------------------------------------------
function EventMonitor:addEventListener(listener)
   if(not self.frame:IsEventRegistered(listener:getEvent())) then
      self.frame:RegisterEvent(listener:getEvent());
   end

   if(not self.eventListeners[listener:getEvent()]) then
      self.eventListeners[listener:getEvent()] = {};
   end

   table.insert(self.eventListeners[listener:getEvent()], listener:getCallback());
end

function EventMonitor:addEventListeners(listeners)
   for _, listener in pairs(listeners) do
      self:addEventListener(listener);
   end
end
