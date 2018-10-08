local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.warrior.Fury = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Fury = ewf.unit.class.warrior.Fury;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Fury:class(child)
   child = child or {};
   local this = ewf.unit.class.Warrior:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Fury:new(unit, eventMonitor)
   local instance = Fury:class({unit=unit, eventMonitor=eventMonitor, classname = "Warrior", specname = "Fury"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);

   return instance;
end

