local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.rotation.rotations.MageFire = {}

-- Unique, holds functions so needs to be declared outside new
ewf.rotation.rotations.MageFire.Steps = {};

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local MageFire = ewf.rotation.rotations.MageFire;
local Steps = ewf.rotation.rotations.MageFire.Steps;
local EwfUtils = ewf.utils.EwfUtils;
local MathUtils = ewf.utils.MathUtils;

----------------------------------------------------------------------------------------------------------------------------------
-- LOCAL VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local PHASE_1_MIN_TIME = -1;
local PHASE_1_MAX_TIME = 0;

local PHASE_2_MIN_TIME = 0;
local PHASE_2_MAX_TIME = 5;

local PHASE_3_MIN_TIME = 5;
local PHASE_3_MAX_TIME = 15;

local PHASE_4_MIN_TIME = 15;
local PHASE_4_MAX_TIME = 25;

local PHASE_5_MIN_TIME = 25;
local PHASE_5_MAX_TIME = 35;

----------------------------------------------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------

-- COMBUSTION
-- If we are not on bar:1, then we are not including Combustion in our rotation.
-- Combustion time ranges are calculated by ensuring we are between the minimum and the maximum.
local function isInCombustionTimeRange(character, minTime, maxTime)
   if(character:hasBuff("Rune of Power") or character:hasBuff("Combustion")) then
      return false;
   else
      return EwfUtils:checkConditionals("[bar:1]") and character:hasSpellCooldownGT("Combustion", minTime) and (character:hasSpellCooldownLE("Combustion", maxTime));
   end
end

-- METEOR
-- Meteor time ranges are calculated by ensuring we are between the minimum and the maximum.
local function isInMeteorTimeRange(character, minTime, maxTime)
   if(character:hasBuff("Rune of Power") or character:hasBuff("Combustion")) then
      return false;
   else
      return character:hasSpellCooldownGT("Meteor", minTime) and character:hasSpellCooldownLE("Meteor", maxTime);
   end
end

--RUNE OF POWER
-- If we have a rune of power charge, we calculate the value as though Rune of Power is in phase 1.
-- Otherwise, we calculate the value as normal.
local function isInRuneOfPowerTimeRange(character, minTime, maxTime)
   if(character:hasBuff("Rune of Power") or character:hasBuff("Combustion")) then
      return false;
   elseif(character:hasSpellChargesGE("Rune of Power", 1)) then
      return (PHASE_1_MIN_TIME == minTime and PHASE_1_MAX_TIME == maxTime);
   else
      return (character:hasSpellCooldownGT("Rune of Power", minTime) and character:hasSpellCooldownLE("Rune of Power", maxTime));
   end
end


-- Can consume Heating Up. Can consume Hot Streak!.
local function calculatePhase0(character)
   if (character:hasBuff("Rune of Power") or character:hasBuff("Combustion")) then
      --print("isPhase0")
      return true;
   else
      return false;
   end
end

-- Can consume Heating Up. Cannot consume Hot Streak!.
local function calculatePhase1(character)
   local minTime = PHASE_1_MIN_TIME;
   local maxTime = PHASE_1_MAX_TIME;

   if(isInCombustionTimeRange(character, minTime, maxTime) or isInMeteorTimeRange(character, minTime, maxTime) or isInRuneOfPowerTimeRange(character, minTime, maxTime)) then
      --print("isPhase1")
      return true;
   else
      return false;
   end
end

-- Can consume Heating Up. Cannot consume Hot Streak!.
local function calculatePhase2(character)
   local minTime = PHASE_2_MIN_TIME;
   local maxTime = PHASE_2_MAX_TIME;

   if(isInCombustionTimeRange(character, minTime, maxTime) or isInMeteorTimeRange(character, minTime, maxTime) or isInRuneOfPowerTimeRange(character, minTime, maxTime)) then
      --print("isPhase2")
      return true;
   else
      return false;
   end
end

-- Cannot consume Heating Up. Can consume Hot Streak!.
local function calculatePhase3(character)
   local minTime = PHASE_3_MIN_TIME;
   local maxTime = PHASE_3_MAX_TIME;

   if(isInCombustionTimeRange(character, minTime, maxTime) or isInMeteorTimeRange(character, minTime, maxTime) or isInRuneOfPowerTimeRange(character, minTime, maxTime)) then
      --print("isPhase3")
      return true;
   else
      return false;
   end
end

-- Can consume Heating Up if fire blast charges >= 3. Can consume Hot Streak!.
local function calculatePhase4(character)
   local minTime = PHASE_4_MIN_TIME;
   local maxTime = PHASE_4_MAX_TIME;

   if(isInCombustionTimeRange(character, minTime, maxTime) or isInMeteorTimeRange(character, minTime, maxTime) or isInRuneOfPowerTimeRange(character, minTime, maxTime)) then
      --print("isPhase4")
      return true;
   else
      return false;
   end
end

-- Can consume Heating Up if fire blast charges >= 2. Can consume Hot Streak!.
local function calculatePhase5(character)
   local minTime = PHASE_5_MIN_TIME;
   local maxTime = PHASE_5_MAX_TIME;

   if(isInCombustionTimeRange(character, minTime, maxTime) or isInMeteorTimeRange(character, minTime, maxTime) or isInRuneOfPowerTimeRange(character, minTime, maxTime)) then
      --print("isPhase5")
      return true;
   else
      return false;
   end
end

-- The order phases are checked here are very important!
-- If our cooldowns are out of sycnh, and they will be, we want to pace the cycle off the phase with
-- highest matching cooldowns. That way, we our not stuck in a low fire blast usage phase for an
-- extended period of time while we wait for slower cooldowns to catch up.
local function getCurrentPhase(character)
   if(calculatePhase5(character))then
      return 5;
   elseif(calculatePhase4(character))then
      return 4;
   elseif(calculatePhase3(character))then
      return 3;
   elseif(calculatePhase2(character))then
      return 2;
   elseif(calculatePhase1(character))then
      return 1;
   elseif(calculatePhase0(character))then
      return 0;
   else
      return 6;
   end
end

--phase 3 is always false, phase 4 and 5 can be conditionally false
local function canConsumeHeatingUp(character, phase)
   local heatingUp = character:hasBuff("Heating Up");

   if(heatingUp and (phase == 0 or phase == 1 or phase == 2 or phase == 6)) then
      return true;
   elseif(heatingUp and (phase == 4 and character:getSpellCharges("Fire Blast") >= 3)) then
      return true;
   elseif(heatingUp and (phase == 5 and character:getSpellCharges("Fire Blast") >= 2)) then
      return true;
   else
      return false;
   end
end

--phase 1 and phase 2 are always false
local function canConsumeHotStreak(character, phase)
   local hotStreak = character:hasBuff("Hot Streak!");

   if(hotStreak and (phase == 0 or phase == 3 or phase == 4 or phase == 5 or phase == 6))then
      return true;
   else
      return false;
   end
end

-- TODO Eventually remove once rotation is complete, but needed for legacy support until then
local function canActivateBuffsForBurnCycle(character, phase)
   if(phase == 1 and character:hasBuff("Hot Streak!")) then
      return true;
   else
      return false;
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function MageFire:class(child)
   child = child or {};
   local this = ewf.rotation.Rotation:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function MageFire:new(character, eventMonitor)
   local instance = MageFire:class({character=character});

   instance.GCD = ewf.event.widgets.GlobalCooldown:new(eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function MageFire:canConsumeHeatingUp()
   return canConsumeHeatingUp(self.character, getCurrentPhase(self.character));
end

function MageFire:canConsumeHotStreak()
   return canConsumeHotStreak(self.character, getCurrentPhase(self.character));
end

-- TODO Eventually remove once rotation is complete, but needed for legacy support until then
function MageFire:canActivateBuffsForBurnCycle()
   return canActivateBuffsForBurnCycle(self.character, getCurrentPhase(self.character));
end

function MageFire:checkRotation(step)
   if(step and self.Steps[step]) then
      local phase = getCurrentPhase(self.character);
      return self.Steps[step](self.character, phase, self.GCD);
   else
      return false;
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- STEPS
----------------------------------------------------------------------------------------------------------------------------------

-- METEOR (PHASE 1)
Steps[1] = function(character, phase, gcd)
   return phase == 1 and character:hasBuff("Hot Streak!") and character:getSpellCharges("Fire Blast") >= 2 and not character:isCasting("Meteor");
end;

-- RUNE OF POWER (PHASE 1)
Steps[2] = function(character, phase, gcd)
   return phase == 1 and character:hasBuff("Hot Streak!") and character:getSpellCharges("Fire Blast") >= 2 and not character:hasBuff("Rune of Power") and not character:isCasting("Rune of Power");
end;

-- COMBUSTION (PHASE 1)
Steps[3] = function(c, phase, gcd)
   return phase == 1 and EwfUtils:check("[bar:1]") and c:getSpellCharges("Fire Blast") >= 2 and c:hasBuff("Hot Streak!") and not c:hasBuff("Combustion");
end;

-- FIRE BLAST (PHASE 1)
Steps[4] = function(character, phase, gcd)
   return phase == 1 and canConsumeHeatingUp(character, phase);
end;

-- PYROBLAST (DURING COMBUSTION)
Steps[5] = function(character, phase, gcd)
   return canConsumeHotStreak(character, phase) and character:hasBuff("Combustion");
end;

-- FIRE BLAST (DURING COMBUSTION)
Steps[6] = function(character, phase, gcd)
   return canConsumeHeatingUp(character, phase) and character:hasBuff("Combustion") and not character:isCasting("Scorch");
end;

-- DRAGON'S BREATH (DURING COMBUSTION)
Steps[7] = function(character, phase, gcd)
   return false; -- TODO
end;

-- SCORCH (DURING COMBUSTION)
Steps[8] = function(character, phase, gcd)
   return (canConsumeHeatingUp(character, phase) and character:hasBuff("Combustion") and not character:isCasting("Scorch"));
end;

-- PYROBLAST
Steps[9] = function(character, phase, gcd)
   return (canConsumeHotStreak(character, phase) and not character:hasBuff("Combustion") and (character:isCasting("Fireball") or character:isCasting("Scorch")));
end;

-- FIRE BLAST
Steps[10] = function(character, phase, gcd)
   return canConsumeHeatingUp(character, phase) and not character:hasBuff("Combustion") and (character:isCasting("Fireball") or character:isCasting("Scorch"));
end;

-- SCORCH
Steps[11] = function(c, phase, gcd)
   local health = UnitHealth("target");
   local maxHealth = UnitHealthMax("target");
   local percentHealth = MathUtils:percent(health, maxHealth);

   if(c:isCastingAnything() or c:isChannelingAnything() or gcd:hasDuration()) then
      return false;
   else
      return (c:hasTalent("Searing Touch") and percentHealth <= 30 and not c:hasBuff("Combustion"));
   end
end;

-- FIREBALL
Steps[12] = function(c, phase, gcd)
   if(c:isCastingAnything() or c:isChannelingAnything() or gcd:hasDuration()) then
      return false;
   else
      return (c:getCurrentSpeed() == 0 and not c:hasBuff("Combustion"));
   end
end;

-- SCORCH
Steps[13] = function(c, phase, gcd)
   if(c:isCastingAnything() or c:isChannelingAnything() or gcd:hasDuration()) then
      return false;
   else
      return (not c:hasBuff("Combustion"));
   end
end;
