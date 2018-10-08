local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.ArcaneMageBurnPhase = {};
ewf.event.widgets.ArcaneMageBurnPhase.callbacks = {};
----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local ArcaneMageBurnPhase = ewf.event.widgets.ArcaneMageBurnPhase;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function ArcaneMageBurnPhase:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function ArcaneMageBurnPhase:new(unit, eventMonitor)
   local instance = ArcaneMageBurnPhase:class({unit=unit, phase=false,});

   instance:createCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end


----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function ArcaneMageBurnPhase:isBurnPhase()
   return self.phase;
end

function ArcaneMageBurnPhase:isConservePhase()
   return not self.phase;
end

function ArcaneMageBurnPhase:getPhase()
   if(self.phase)then
      return "BURN";
   else
      return "CONSERVE";
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function ArcaneMageBurnPhase:createCallbackMethods()
   local _self = self;

   ArcaneMageBurnPhase.callbacks["PLAYER_REGEN_ENABLED"] = function()
      if(_self.unit == "player") then
         _self.phase = false;
      end
   end;

   ArcaneMageBurnPhase.callbacks["UNIT_SPELLCAST_CHANNEL_START"] = function(unit, spellLineIdCounter, spellId)
      if(_self.unit == unit and GetSpellInfo(spellId) == "Evocation") then
         _self.phase = false;
      end
   end;

   ArcaneMageBurnPhase.callbacks["UNIT_SPELLCAST_SUCCEEDED"] = function(unit, spellLineIdCounter, spellId)
      if(_self.unit == unit and GetSpellInfo(spellId) == "Arcane Power") then
         _self.phase = true;
      end
   end;
end

function ArcaneMageBurnPhase:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("PLAYER_REGEN_ENABLED", self.callbacks["PLAYER_REGEN_ENABLED"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_CHANNEL_START", self.callbacks["UNIT_SPELLCAST_CHANNEL_START"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_SUCCEEDED", self.callbacks["UNIT_SPELLCAST_SUCCEEDED"]));
end
