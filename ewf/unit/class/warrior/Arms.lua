local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.warrior.Arms = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Arms = ewf.unit.class.warrior.Arms;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Arms:class(child)
   child = child or {};
   local this = ewf.unit.class.Warrior:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Arms:new(unit, eventMonitor)
   local instance = Arms:class({unit=unit, eventMonitor=eventMonitor, classname = "Warrior", specname = "Arms"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end
