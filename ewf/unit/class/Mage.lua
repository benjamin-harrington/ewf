local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.Mage = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Mage = ewf.unit.class.Mage;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Mage:class(child)
   child = child or {};
   local this = ewf.unit.Character:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Mage:new(unit, eventMonitor)
   local instance = Mage:class({unit=unit, eventMonitor=eventMonitor, classname = "Mage"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end

