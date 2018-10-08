local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.warrior.Protection = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Protection = ewf.unit.class.warrior.Protection;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Protection:class(child)
   child = child or {};
   local this = ewf.unit.class.Warrior:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Protection:new(unit, eventMonitor)
   local instance = Protection:class({unit=unit, eventMonitor=eventMonitor, classname = "Warrior", specname = "Protection"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end
