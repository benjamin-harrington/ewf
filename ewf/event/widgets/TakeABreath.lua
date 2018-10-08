local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.TakeABreath = {}
ewf.event.widgets.TakeABreath.callbacks = {};
----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local TakeABreath = ewf.event.widgets.TakeABreath;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function TakeABreath:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function TakeABreath:new(player, eventMonitor)
   local instance = TakeABreath:class({player=player, start=0, duration=0.25,});

   instance:createCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function TakeABreath:halt()
   local duration = ((self.start + self.duration) - GetTime());

   return (duration > 0);
end

function TakeABreath:continue()
   return not self:halt();
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function TakeABreath:createCallbackMethods()
   local _self = self;

   TakeABreath.callbacks["UNIT_SPELLCAST_SENT"] = function(unit, spellLineId, spellId)
      if(_self.player.unit == unit) then
      _self.start = GetTime();
      end
   end;

   TakeABreath.callbacks["UNIT_SPELLCAST_STOP"] = function(unit, spellLineId, spellId)
      if(_self.player.unit == unit) then

      end
   end;

   TakeABreath.callbacks["UNIT_SPELLCAST_START"] = function(unit, spellLineId, spellId)
      if(_self.player.unit == unit) then

      end
   end;
end

function TakeABreath:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_SENT", self.callbacks["UNIT_SPELLCAST_SENT"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_STOP", self.callbacks["UNIT_SPELLCAST_STOP"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_START", self.callbacks["UNIT_SPELLCAST_START"]));
end
