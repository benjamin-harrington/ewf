local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.Warrior = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Warrior = ewf.unit.class.Warrior;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Warrior:class(child)
   child = child or {};
   local this = ewf.unit.Character:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Warrior:new(unit, eventMonitor)
   local instance = Warrior:class({unit=unit, eventMonitor=eventMonitor, classname = "Warrior"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end
