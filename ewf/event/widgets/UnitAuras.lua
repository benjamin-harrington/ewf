local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.event.widgets.UnitAuras = {};
ewf.event.widgets.UnitAuras.callbacks = {};
----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local UnitAuras = ewf.event.widgets.UnitAuras;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function UnitAuras:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function UnitAuras:new(unit, eventMonitor)
   local instance = UnitAuras:class({unit=unit, buffs={}, debuffs={},});

   instance:createCallbackMethods();
   instance:registerListeners(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- GETTERS
----------------------------------------------------------------------------------------------------------------------------------
function UnitAuras:hasBuff(name)
   if(self.buffs[name]) then
      return true;
   end
end

function UnitAuras:getBuff(name)
   if(self.buffs[name]) then
      return self.buffs[name];
   end
end

function UnitAuras:getBuffs()
   return self.buffs;
end

function UnitAuras:hasDebuff(name)
   if(self.debuffs[name]) then
      return true;
   end
end

function UnitAuras:getDebuff(name)
   if(self.debuffs[name]) then
      return self.debuffs[name];
   end
end

function UnitAuras:getDebuffs()
   return self.debuffs;
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function UnitAuras:createCallbackMethods()
   local _self = self;

   UnitAuras.callbacks["UNIT_AURA"] = function(unit)
      if(_self.unit == unit) then
         _self.buffs = _self:refreshCurrentBuffList();
         _self.debuffs = _self:refreshCurrentDebuffList();
      end
   end;
end

function UnitAuras:registerListeners(eventMonitor)
   eventMonitor:addEventListener(ewf.event.Listener:new("UNIT_AURA", self.callbacks["UNIT_AURA"]));
end

function UnitAuras:refreshCurrentBuffList()
   local buffs = {};

   -- get all buffs for the current unit
   for i=1, ewf.Constants.MAX_AURAS_ALLOWED do
      local name, _, count, _, _, expirationTime, _, _, _, spellId = UnitBuff(self.unit, i);

      if(name and count and expirationTime and spellId) then
         local buff = {name=name, spellId=spellId, count=count, expirationTime=expirationTime};
         buffs[name] = buff;
      end
   end

   return buffs;
end

function UnitAuras:refreshCurrentDebuffList()
   local debuffs = {};

   -- get all debuffs for the current unit
   for i=1, ewf.Constants.MAX_AURAS_ALLOWED do
      local name, _, count, _, _, expirationTime, _, _, _, spellId = UnitDebuff(self.unit, i);

      if(name and count and expirationTime and spellId) then
         local debuffs = {name=name, spellId=spellId, count=count, expirationTime=expirationTime};
         debuffs[name] = debuffs;
      end
   end

   return debuffs;
end
