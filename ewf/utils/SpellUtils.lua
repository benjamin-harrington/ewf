local addon, ewf = ... -- get the addon name and namespace (common table).

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.utils.SpellUtils = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local SpellUtils = ewf.utils.SpellUtils;

----------------------------------------------------------------------------------------------------------------------------------
-- LOCALS
----------------------------------------------------------------------------------------------------------------------------------
local function getSpellname(spell)
   local spellname = nil;

   if(type(spell) == "number") then
      spellname = (GetSpellInfo(spell));
   else
      spellname = spell;
   end

   return spellname;
end

local function getCooldownInfo(spell)
   local start, duration, enabled = GetSpellCooldown(spell);

   return start, duration, enabled;
end

local function calculateCooldownRemaining(start, duration, enabled)
   local cooldownRemaining = nil;

   if (enabled == 0) then
      cooldownRemaining = 0;
   elseif (start > 0 and duration > 0) then
      cooldownRemaining = ewf.utils.MathUtils:round(start + duration - GetTime(), 1);
   else
      cooldownRemaining =  0;
   end

   return cooldownRemaining;
end

local function getSpellCooldown(spell)
   local start, duration, enabled = GetSpellCooldown(spell);

   return calculateCooldownRemaining(start, duration, enabled);
end

local function getChargeCooldown(spell)
   local _, _, cooldownStart, cooldownDuration  = GetSpellCharges(spell);

   return calculateCooldownRemaining(cooldownStart, cooldownDuration, nil);
end

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function SpellUtils:getSpellname(spell)
   return getSpellname(spell);
end

function SpellUtils:getCooldownInfo(spell)
   return getCooldownInfo(spell);
end

function SpellUtils:getSpellCooldown(spell)
   return getSpellCooldown(spell);
end

function SpellUtils:getChargeCooldown(spell)
   return getChargeCooldown(spell);
end

function SpellUtils:calculateCooldownRemaining(start, duration, enabled)
   return calculateCooldownRemaining(start, duration, enabled);
end

----------------------------------------------------------------------------------------------------------------------------------
-- WIP FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
-- Checks if spell is ready, i.e. off cooldown, target, mana, charges, etc.
function SpellUtils:isSpellReady()

end

-- Checks of the spell is off cooldown
function SpellUtils:isSpellOffCooldown(spellname, booktype)
   local start, duration, enabled, modRate = GetSpellCooldown(spellname, booktype);

   if enabled == 0 then
      return false;
   elseif (start > 0 and duration > 0) then
      return false;
   else
      return true;
   end
end

function SpellUtils:isSpellInRange(spellname, unit)

end
