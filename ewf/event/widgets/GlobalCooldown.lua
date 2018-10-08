local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.GlobalCooldown = {}
ewf.event.widgets.GlobalCooldown.callbacks = {};
----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local GlobalCooldown = ewf.event.widgets.GlobalCooldown;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function GlobalCooldown:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function GlobalCooldown:new(eventMonitor)
   local instance = GlobalCooldown:class({start=0, duration=0,});

   instance:createCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function GlobalCooldown:getDuration()
   local duration = ((self.start + self.duration) - GetTime());

   if(duration > 0) then
      return duration;
   else
      return 0;
   end
end

function GlobalCooldown:hasDuration()
   local duration = self:getDuration();

   if(duration > 0) then
      return true;
   else
      return false;
   end
end

function GlobalCooldown:isOk(percent)
   local duration = ((self.start + (self.duration * percent)) - GetTime());

   if(duration > 0) then
      return false;
   else
      return true;
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function GlobalCooldown:createCallbackMethods()
   local _self = self;

   GlobalCooldown.callbacks["UNIT_SPELLCAST_START"] = function(unit, spellLineId, spellId)
      _self:processGlobalCooldownUpdate(GetSpellCooldown(61304));
   end;

   GlobalCooldown.callbacks["UNIT_SPELLCAST_SUCCEEDED"] = function(unit, spellLineId, spellId)
      _self:processGlobalCooldownUpdate(GetSpellCooldown(61304));
   end;

   GlobalCooldown.callbacks["UNIT_SPELLCAST_CHANNEL_START"] = function(unit, spellLineId, spellId)
      _self:processGlobalCooldownUpdate(GetSpellCooldown(61304));
   end;
end

function GlobalCooldown:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_START", self.callbacks["UNIT_SPELLCAST_START"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_SUCCEEDED", self.callbacks["UNIT_SPELLCAST_SUCCEEDED"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_CHANNEL_START", self.callbacks["UNIT_SPELLCAST_CHANNEL_START"]));
end

function GlobalCooldown:processGlobalCooldownUpdate(startTime, duration, enabled, modRate)
   if(duration > 0) then
      self.start = GetTime();
      self.duration = duration;
   end
end
