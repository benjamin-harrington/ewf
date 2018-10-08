local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.class.mage.Fire = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Fire = ewf.unit.class.mage.Fire;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Fire:class(child)
   child = child or {};
   local this = ewf.unit.class.Mage:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Fire:new(unit, eventMonitor)
   local instance = Fire:class({unit=unit, eventMonitor=eventMonitor, classname = "Mage", specname = "Fire"});

   instance.unitAuras = ewf.event.widgets.UnitAuras:new(unit, eventMonitor);
   instance.trackSpellCooldowns = ewf.event.widgets.TrackSpellCooldowns:new(unit, eventMonitor);
   instance.trackSpellcasts = ewf.event.widgets.TrackSpellcasts:new(unit, eventMonitor);
   instance.talentCard=ewf.data.static.TALENT_CARD.MAGE_FIRE;

   return instance;
end

function Fire:getSpellcasts()
   return self.trackSpellcasts:getSpellcasts();
end
