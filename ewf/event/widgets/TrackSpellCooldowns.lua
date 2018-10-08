local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.TrackSpellCooldowns = {}
ewf.event.widgets.TrackSpellCooldowns.eventCallbacks = {};
ewf.event.widgets.TrackSpellCooldowns.cooldowns = {};

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local TrackSpellCooldowns = ewf.event.widgets.TrackSpellCooldowns;
local SpellUtils = ewf.utils.SpellUtils;
local SPELL_CARD = ewf.data.static.SPELL_CARD;

----------------------------------------------------------------------------------------------------------------------------------
-- LOCALS
----------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellCooldowns:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function TrackSpellCooldowns:new(unit, eventMonitor)

   local instance = TrackSpellCooldowns:class({unit=unit});

   instance:createEventCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellCooldowns:getSpellcasts()
   local spellcasts = {}

   for _, spellcast in pairs(self.spellcasts) do
      table.insert(spellcasts, spellcast);
   end

   return spellcasts;
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellCooldowns:createEventCallbackMethods()
   local _self = self;

   TrackSpellCooldowns.unitSpellcastSucceeded = function(unit, spellLineId, spellId)
      if(_self.unit == unit)then
         local _start, _duration, _enabled =  SpellUtils:getCooldownInfo(spellId);

         if(SPELL_CARD[spellId] and _enabled == 1) then
            local spellname = SPELL_CARD[spellId].name;
            local start = GetTime();
            local duration = SPELL_CARD[spellId].cooldown;

            if(duration > 0) then
               _self.cooldowns[spellname] = {start=start, duration=duration, enabled=1};
            end
         else
            C_Timer.After(2, function() _self:processSpellcast(unit, spellLineId, spellId); end);
         end

      end
   end;

   TrackSpellCooldowns.unitSpellcastChannelStop = function(unit, spellLineId, spellId)
      if(_self.unit == unit)then
         local _start, _duration, _enabled =  SpellUtils:getCooldownInfo(spellId);

         if(SPELL_CARD[spellId] and _enabled == 1) then
            local spellname = SPELL_CARD[spellId].name;
            local start = GetTime();
            local duration = SPELL_CARD[spellId].cooldown;

            if(duration > 0) then
               _self.cooldowns[spellname] = {start=start, duration=duration, enabled=1};
            end
         else
            C_Timer.After(2, function() _self:processSpellcast(unit, spellLineId, spellId) end);
         end
      end
   end;

end

function TrackSpellCooldowns:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_SUCCEEDED", self.unitSpellcastSucceeded));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_CHANNEL_STOP", self.unitSpellcastChannelStop));
end

function TrackSpellCooldowns:getSpellCooldown(spellname)
   local cooldownRemaining = 0;

   if(self.cooldowns[spellname])then
      local start, duration, enabled = self.cooldowns[spellname].start, self.cooldowns[spellname].duration, self.cooldowns[spellname].enabled;
      cooldownRemaining = SpellUtils:calculateCooldownRemaining(start, duration, enabled);

      if(cooldownRemaining < 0)then
         -- Cleanout old records
         self.cooldowns[spellname] = nil;

         -- Cleanup the return value
         cooldownRemaining = 0;
      end
   end

   return cooldownRemaining;
end

function TrackSpellCooldowns:processSpellcast(unit, spellLineId, spellId)
   local spellname = SpellUtils:getSpellname(spellId);
   local start, duration, enabled =  SpellUtils:getCooldownInfo(spellId);

   if(enabled == 1) then
      self.cooldowns[spellname] = {start=start, duration=duration, enabled=enabled};
   else
      C_Timer.After(2, function() self:processSpellcast(unit, spellLineId, spellId) end);
   end
end
