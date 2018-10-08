local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.unit.Character = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Character = ewf.unit.Character;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Character:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

----------------------------------------------------------------------------------------------------------------------------------
-- CASTING
----------------------------------------------------------------------------------------------------------------------------------
function Character:isCastingAnything()
   if((UnitCastingInfo(self.unit)) == nil) then
      return false;
   else
      return true;
   end
end

function Character:isCasting(spellname)
   return ((UnitCastingInfo(self.unit)) == spellname);
end

function Character:isChannelingAnything()
   if((UnitChannelInfo(self.unit)) == nil) then
      return false;
   else
      return true;
   end
end

function Character:isChanneling(spellname)
   return ((UnitChannelInfo(self.unit)) == spellname);
end

----------------------------------------------------------------------------------------------------------------------------------
-- TALENTS
----------------------------------------------------------------------------------------------------------------------------------
function Character:hasTalent(talent)
   local talentCard = self:getTalentCard();

   local _, _, _, selected = GetTalentInfo(talentCard[talent].tier, talentCard[talent].column, 1);

   return selected;
end

function Character:getTalentCard()
   if(self.talentCard)then
      return self.talentCard;
   else
      print("ERROR: no talent card exists for unit:" .. self.unit .. " class:" .. self.classname .. " spec:" .. self.specname);
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
----------------------------------------------------------------------------------------------------------------------------------
function Character:hasBuff(name)
   return self.unitAuras:hasBuff(name);
end

function Character:getBuff(name)
   return self.unitAuras:getBuff(name);
end

function Character:getBuffDuration(name)
   if(self.unitAuras:hasBuff(name)) then
      return self.unitAuras:getBuff(name).expirationTime - GetTime();
   end
end

--function Character:setBuffs(buffs)
--   self.buffs = buffs;
--end


----------------------------------------------------------------------------------------------------------------------------------
-- DEBUFFS
----------------------------------------------------------------------------------------------------------------------------------
function Character:hasDebuff(name)
   return self.unitAuras:hasDebuff(name);
end

function Character:getDebuff(name)
   return self.unitAuras:getDebuff(name);
end

function Character:getDebuffDuration(name)
   if(self.unitAuras:hasDebuff(name)) then
      return self.unitAuras:getDebuff(name).expirationTime - GetTime();
   end
end

--function Character:setDebuffs(debuffs)
--   self.debuffs = debuffs;
--end

----------------------------------------------------------------------------------------------------------------------------------
-- SPELL COOLDOWN
----------------------------------------------------------------------------------------------------------------------------------
function Character:getSpellCooldown(spellname)
   return self.trackSpellCooldowns:getSpellCooldown(spellname);
end

function Character:hasSpellCooldownLT(spellname, time)
   return (self.trackSpellCooldowns:getSpellCooldown(spellname) < time);
end

function Character:hasSpellCooldownLE(spellname, time)
   return (self.trackSpellCooldowns:getSpellCooldown(spellname) <= time);
end

function Character:hasSpellCooldownEQ(spellname, time)
   return (self.trackSpellCooldowns:getSpellCooldown(spellname) == time);
end

function Character:hasSpellCooldownGT(spellname, time)
   return (self.trackSpellCooldowns:getSpellCooldown(spellname) > time);
end

function Character:hasSpellCooldownGE(spellname, time)
   return (self.trackSpellCooldowns:getSpellCooldown(spellname) >= time);
end

----------------------------------------------------------------------------------------------------------------------------------
-- SPELL CHARGES
----------------------------------------------------------------------------------------------------------------------------------
function Character:getSpellCharges(spell)
   return (GetSpellCharges(spell));
end

function Character:hasSpellChargesLT(spell, count)
   local currentCharges = GetSpellCharges(spell);

   return (currentCharges < count);
end

function Character:hasSpellChargesLE(spell, count)
   local currentCharges = GetSpellCharges(spell);

   return (currentCharges <= count);
end

function Character:hasSpellChargesEQ(spell, count)
   local currentCharges = GetSpellCharges(spell);

   return (currentCharges == count);
end

function Character:hasSpellChargesGT(spell, count)
   local currentCharges = GetSpellCharges(spell);

   return (currentCharges > count);
end

function Character:hasSpellChargesGE(spell, count)
   local currentCharges = GetSpellCharges(spell);

   return (currentCharges >= count);
end

----------------------------------------------------------------------------------------------------------------------------------
-- POWER
----------------------------------------------------------------------------------------------------------------------------------
function Character:hasPercentPowerLT(percent)
   return (ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit))) < percent);
end

function Character:hasPercentPowerLE(percent)
   return (ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit))) <= percent);
end

function Character:hasPercentPowerEQ(percent)
   return (ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit))) == percent);
end

function Character:hasPercentPowerGT(percent)
   return (ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit))) > percent);
end

function Character:hasPercentPowerGE(percent)
   return (ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit))) >= percent);
end

function Character:getPercentPower()
   return ewf.utils.MathUtils:percent((UnitPower(self.unit)), (UnitPowerMax(self.unit)))
end

----------------------------------------------------------------------------------------------------------------------------------
-- HEALTH
----------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------
-- SPEED
----------------------------------------------------------------------------------------------------------------------------------
function Character:getCurrentSpeed()
   return GetUnitSpeed(self.unit);
end
