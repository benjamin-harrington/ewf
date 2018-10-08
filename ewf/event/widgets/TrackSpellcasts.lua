local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.TrackSpellcasts = {}
ewf.event.widgets.TrackSpellcasts.callbacks = {};

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local TrackSpellcasts = ewf.event.widgets.TrackSpellcasts;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellcasts:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function TrackSpellcasts:new(unit, eventMonitor)
   local instance = TrackSpellcasts:class({unit=unit, spellcasts={}, MAX_CASTS_SIZE=10});

   instance:createCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellcasts:getSpellcasts()
   local spellcasts = {}

   for _, spellcast in pairs(self.spellcasts) do
      table.insert(spellcasts, spellcast);
   end

   return spellcasts;
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function TrackSpellcasts:createCallbackMethods()
   local _self = self;

   TrackSpellcasts.callbacks["UNIT_SPELLCAST_SUCCEEDED"] = function(unit, spellLineId, spellId)
      _self:addSpellToCastHistory(unit, spellId);
   end;

   TrackSpellcasts.callbacks["UNIT_SPELLCAST_CHANNEL_STOP"] = function(unit, spellLineId, spellId)
      _self:addSpellToCastHistory(unit, spellId);
   end;
end

function TrackSpellcasts:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_SUCCEEDED", self.callbacks["UNIT_SPELLCAST_SUCCEEDED"]));
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_SPELLCAST_CHANNEL_STOP", self.callbacks["UNIT_SPELLCAST_CHANNEL_STOP"]));
end

function TrackSpellcasts:addSpellToCastHistory(unit, spellId)
   if(self.unit == unit) then
      while(#self.spellcasts >= self.MAX_CASTS_SIZE) do
         table.remove(self.spellcasts, 1);
      end

      table.insert(self.spellcasts, (GetSpellInfo(spellId)))
   end
end
