local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.mage.Frost = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Frost = ewf.unit.class.mage.Frost;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Frost:class(child)
   child = child or {};
   local this = ewf.unit.class.Mage:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Frost:new(unit, eventMonitor)
   local instance = Frost:class({unit=unit, eventMonitor=eventMonitor, classname = "Mage", specname = "Frost"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end


