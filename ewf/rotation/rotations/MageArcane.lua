local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.rotation.rotations.MageArcane = {}

-- Unique, holds functions so needs to be declared outside new
ewf.rotation.rotations.MageArcane.steps = {}; 

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local MageArcane = ewf.rotation.rotations.MageArcane;
local SpellUtils = ewf.utils.SpellUtils;
local RangeUtils = ewf.utils.RangeUtils;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function MageArcane:class(child)
   child = child or {};
   local this = ewf.rotation.Rotation:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function MageArcane:new(player, eventMonitor)
   local instance = MageArcane:class({player=player});

   instance.takeABreath = ewf.event.widgets.TakeABreath:new(player, eventMonitor);

   return instance;
end

----------------------------------------------------------------------------------------------------------------------------------
-- LOCAL
----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------
-- RESOURCE CHECKS
-------------------------------------------------------------------------
local function getPredictedArcaneCharges(player)
   local charges = 0;

   if(player:isCasting("Arcane Blast")) then
      charges = player:getArcaneCharges() + 1;
   else
      charges = player:getArcaneCharges();
   end

   if(charges >= 4)then
      return 4;
   else
      return charges;
   end
end

-------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------
local function countEnemyUnitsInRange(range)
   return RangeUtils:countEnemyUnitsInRange(range);
end

local function checkConditionals(conditionals)
   return ewf.utils.EwfUtils:checkConditionals(conditionals);
end

-------------------------------------------------------------------------
-- HAS BUFF
-------------------------------------------------------------------------
local function hasPredictedRuleOfThreesBuff(player)
   -- If we have 2 arcane charges and are casting Arcane Blast, predict yes.
   -- If we have 4 arcane charges, predict no.
   -- Otherwise, if we have buff up, predict yes.

   if(player:isCasting("Arcane Blast") and player:hasBuff("Rule of Threes"))then
      return false;
   elseif(player:getArcaneCharges() < 4 and player:hasBuff("Rule of Threes"))then
      return true;
   else
      return false
   end
end

----------------------------------------------------------------------------------------------------------------------------------
-- STEPS
-- Built From: [BfA] Arcane Mage Guide for Battle for Azeroth (8.0)
-- http://www.altered-time.com/forum/viewtopic.php?f=3&t=6916
-- by Dutchmagoz @ Mon Jul 16, 2018 10:27 pm
----------------------------------------------------------------------------------------------------------------------------------

MageArcane.steps[1] = function(player)
   -- CAST CHARGED UP
   -- Charged Up talented and Arcane Charges <= 2
   if(not player:isBurnPhase())then return false end;

   if(player:hasTalent("Charged Up") and getPredictedArcaneCharges(player) <= 2) then
      return true;
   else
      return false;
   end
end

MageArcane.steps[2] = function(player)
   -- CAST ARCANE ORB
   -- Arcane Orb talented and Arcane Charges < 4
   if(not player:isBurnPhase())then return false end;

   if(player:hasTalent("Arcane Orb") and player:getArcaneCharges() < 4) then
      return true;
   else
      return false;
   end
end

MageArcane.steps[3] = function(player)
   -- Cast Nether Tempest
   -- Nether Tempest talented talented and you have 4 Arcane Charges,
   -- and it is not up, or has less than 3 seconds remaining, and both
   -- Arcane Power and Rune of Power are currently not active.
   if(not player:isBurnPhase())then return false end;

   return false;
end

MageArcane.steps[4] = function(player)
   -- CAST MIRROR IMAGE
   -- Mirror Image talented
   if(not player:isBurnPhase())then return false end;

   if(player:hasTalent("Mirror Image"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[5] = function(player)
   -- CAST ARCANE BLAST
   -- Rule of Threes talent and Rule of Threes buff and Overpowered talented
   if(not player:isBurnPhase())then return false end;

   if(countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]")) then
      -- If we are in the burn phase and in AOE mode, don't worry about using up the Rule of Threes procs.
      return false;
   elseif(player:hasTalent("Rule of Threes") and hasPredictedRuleOfThreesBuff(player) and player:hasTalent("Overpowered")) then
      return true;
   else
      return false;
   end
end

MageArcane.steps[6] = function(player)
   -- CAST RUNE OF POWER
   if(not player:isBurnPhase())then return false end;
   return false;
end

MageArcane.steps[7] = function(player)
   -- CAST ARCANE POWER
   -- 4 Arcane Charges
   -- 1 Rune of Power, if talented TODO TODO TODO
   -- at least 50% Mana (30% if Overpowered is talented).

   if(getPredictedArcaneCharges(player) < 4) then
      return false;
   elseif(false)then
   -- TODO RUNE OF POWER CHECKS
   elseif((player:getPercentPower() < 50 and not player:hasTalent("Overpowered")) or (player:getPercentPower() < 30 and player:hasTalent("Overpowered"))) then
      return false;
   elseif(SpellUtils:getPlayerCooldown("Evocation") > 15)then
      return false;
   else
      return true;
   end
end

MageArcane.steps[8] = function(player)
   -- CAST PRESENCE OF MIND
   if(not player:isBurnPhase())then return false end;
   return false;
end

MageArcane.steps[9] = function(player)
   -- CAST ARCANE BARRAGE
   if(not player:isBurnPhase())then return false end;

   if(countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]") and getPredictedArcaneCharges(player) == 4)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[10] = function(player)
   -- CAST ARCANE EXPLOSION
   if(not player:isBurnPhase())then return false end;

   if(countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[11] = function(player)
   -- CAST ARCANE MISSILES
   if(not player:isBurnPhase())then return false end;

   if(player:hasBuff("Clearcasting") and player:getPercentPower() <= 95 and not player:hasBuff("Arcane Power"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[12] = function(player)
   -- CAST ARCANE BLAST
   if(not player:isBurnPhase())then return false end;

   if(player:getPercentPower() >= 15)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[13] = function(player)
   -- CAST EVOCATION
   if(not player:isBurnPhase())then return false end;

   if(player:getPercentPower() < 15)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[14] = function(player)
   -- CAST CHARGED UP
   -- Conserve Phase and Charged Up talented and Arcane Charges == 0
   if(not player:isConservePhase())then return false end;

   if(player:hasTalent("Charged Up") and getPredictedArcaneCharges(player) == 0)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[15] = function(player)
   -- CAST NETHER TEMPEST
   if(not player:isConservePhase())then return false end;
   return false;
end

MageArcane.steps[16] = function(player)
   -- CAST ARCANE ORB
   if(not player:isConservePhase())then return false end;
   return false;
end

MageArcane.steps[17] = function(player)
   -- CAST RUNE OF POWER
   if(not player:isConservePhase())then return false end;
   return false;
end

MageArcane.steps[18] = function(player)
   -- CAST ARCANE BLAST
   -- Rule of Threes Talented and Rule of Threes Buff
   if(not player:isConservePhase())then return false end;

   --Added condition player:getArcaneCharges() > 2
   -- If we have a "carry over" rule of threes, we want to save it for when we have 3 arcane charges, not 1 or 2,
   -- because by the third charge the haste increase will cause it to cast faster. This really only comes into
   -- play when AOEing, because on ST we are casting Arcane Blast to build each charge regardless.
   if(player:hasTalent("Rule of Threes") and hasPredictedRuleOfThreesBuff(player) and player:getArcaneCharges() > 2)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[19] = function(player)
   -- CAST ARCANE EXPLOSION
   -- targets in range(10) >= 3 and Clearcasting buff
   if(not player:isConservePhase())then return false end;

   if(countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]") and player:hasBuff("Clearcasting"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[20] = function(player)
   -- CAST ARCANE MISSILES
   -- Clearcasting buff and Mana < 95%
   if(not player:isConservePhase())then return false end;

   if(player:hasBuff("Clearcasting") and player:getPercentPower() < 95)then
      return true;
   else
      return false;
   end
end

MageArcane.steps[21] = function(player)
   -- CAST ARCANE BARRAGE
   -- ((Arcane Charges == 4 AND Mana <= 60% TODO TODO TODO) OR (Arcane Charges == 4 AND targets in range(10) >= 3))
   if(not player:isConservePhase())then return false end;

   if((getPredictedArcaneCharges(player) == 4 and player:getPercentPower() <= 60) or (getPredictedArcaneCharges(player) == 4 and countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]")))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[22] = function(player)
   -- CAST ARCANE EXPLOSION
   -- targets in range(10) >= 3
   if(not player:isConservePhase())then return false end;

   if(countEnemyUnitsInRange(10) >= 3 and checkConditionals("[bar:1]"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[23] = function(player)
   -- CAST SUPERNOVA
   -- Supernova talented
   if(not player:isConservePhase())then return false end;

   if(player:hasTalent("Supernova"))then
      return true;
   else
      return false;
   end
end

MageArcane.steps[24] = function(player)
   -- CAST ARCANE BLAST
   if(not player:isConservePhase())then return false end;

   return true;
end
