local addon, ewf = ... -- get the addon name and namespace (common table).

-- In Seconds
local THROTTLE_VALUE = 0.1

local EventMonitor = ewf.event.EventMonitor:new("EWF Event Monitor");

local PlayerCharacter = ewf.class.builders.UnitBuilder:createUnit("player", EventMonitor);
--print("|cffff5733Earth, Wind, & Fire|r loaded " ..  GetUnitName("player", true) .. " as a " .. PlayerCharacter.specname " " .. PlayerCharacter.classname);

local CurrentRotation = ewf.rotation.rotations.MageFire:new(PlayerCharacter, EventMonitor);

local canConsumeHeatingUp_Cache = ewf.cache.Result:new(CurrentRotation.canConsumeHeatingUp, CurrentRotation);
local canConsumeHotStreak_Cache = ewf.cache.Result:new(CurrentRotation.canConsumeHotStreak, CurrentRotation);
local canActivateBuffsForBurnCycle_Cache = ewf.cache.Result:new(CurrentRotation.canActivateBuffsForBurnCycle, CurrentRotation);

-- PUBLIC INTERFACE
function ewf.public.isBurnPhase()
   if(PlayerCharacter) then
      return PlayerCharacter:isBurnPhase();
   end
end

function ewf.public.getPhase()
   if(PlayerCharacter) then
      return PlayerCharacter:getPhase();
   end
end

function ewf.public.checkRotationStep(step)
   -- Still used by TMW Arcane profile
   if(CurrentRotation) then
      return CurrentRotation:checkRotation(step);
   end
end

function ewf.public.checkConditionals(conditionals)
   if(ewf.utils.EwfUtils) then
      return ewf.utils.EwfUtils:checkConditionals(conditionals);
   end
end


-- TODO Current caching method will not work for this, since you could be looking for step 7 but get results for step 10
function ewf.public.rotation(step)
   if(CurrentRotation) then
      return CurrentRotation:checkRotation(step);
   end
end

-- Fire Mage
function ewf.public.canConsumeHeatingUp()
   if(canConsumeHeatingUp_Cache) then
      return canConsumeHeatingUp_Cache:getResult();
   end
end

function ewf.public.canConsumeHotStreak()
   if(canConsumeHotStreak_Cache) then
      return canConsumeHotStreak_Cache:getResult();
   end
end

function ewf.public.canActivateBuffsForBurnCycle()
   if(canActivateBuffsForBurnCycle_Cache) then
      --print(canActivateBuffsForBurnCycle_Cache:getResult());
      return canActivateBuffsForBurnCycle_Cache:getResult();
   end
end
