local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.mage.Arcane = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Arcane = ewf.unit.class.mage.Arcane;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Arcane:class(child)
   child = child or {};
   local this = ewf.unit.class.Mage:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Arcane:new(unit, eventMonitor)
   local instance = Arcane:class({unit = unit, eventMonitor = eventMonitor, classname = "Mage", specname = "Arcane",});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(instance.unit, instance.eventMonitor);
   instance.arcaneMageBurnPhase = ewf.event.widgets.ArcaneMageBurnPhase:new(instance.unit, instance.eventMonitor);
   instance.talentCard=ewf.data.static.TALENT_CARD.MAGE_ARCANE;

   return instance;
end

---------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function Arcane:getArcaneCharges()
   return UnitPower(self.unit, 16);
end

function Arcane:getMaxArcaneCharges()
   return UnitPowerMax(self.unit, 16);
end

function Arcane:isBurnPhase()
   return self.arcaneMageBurnPhase:isBurnPhase();
end

function Arcane:isConservePhase()
   return self.arcaneMageBurnPhase:isConservePhase();
end

function Arcane:getPhase()
   return self.arcaneMageBurnPhase:getPhase();
end
