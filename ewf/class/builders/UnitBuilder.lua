local addon, ewf = ... -- get the addon name and namespace (common table).

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.class.builders.UnitBuilder = {};

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local UnitBuilder = ewf.class.builders.UnitBuilder;

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function UnitBuilder:createUnit(unit, eventMonitor)
   local _, _, classId = UnitClass(unit);
   local specIndex = GetSpecialization();
   local specId = GetSpecializationInfoForClassID(classId, specIndex);

   if(self.classes[classId] and self.classes[classId][specId]) then
      return self.classes[classId][specId](unit, eventMonitor);
   else
      return nil;
   end
end

UnitBuilder.classes = {
   --WARRIOR
   [1] = {

      --Arms
      [71]  = function(unit, eventMonitor) return ewf.unit.class.warrior.Arms:new(unit, eventMonitor) end,

      --Fury
      [72]  = function(unit, eventMonitor) return ewf.unit.class.warrior.Fury:new(unit, eventMonitor) end,

      --Protection
      [73]  = function(unit, eventMonitor) return ewf.unit.class.warrior.Protection:new(unit, eventMonitor) end,
   },

   --PALADIN
   [2] = {

      --Holy
      [65] = function(unit)  end,

      --Protection
      [66] = function(unit)  end,

      --Retribution
      [70] = function(unit)  end,
   },

   --HUNTER
   [3] = {

      --Beast Mastery
      [253] = function(unit)  end,

      --Marksmanship
      [254] = function(unit)  end,

      --Survival
      [255] = function(unit)  end,
   },

   --ROGUE
   [4] = {

      --Assassination
      [259] = function(unit)  end,

      --Outlaw
      [260] = function(unit)  end,

      --Subtlety
      [261] = function(unit)  end,
   },

   --PRIEST
   [5] = {

      --Discipline
      [256] = function(unit)  end,

      --Holy
      [257] = function(unit)  end,

      --Shadow
      [258] = function(unit)  end,
   },

   --DEATHKNIGHT
   [6] = {

      --Blood
      [250] = function(unit)  end,

      --Frost
      [251] = function(unit)  end,

      --Unholy
      [252] = function(unit)  end,
   },

   --SHAMAN
   [7] = {

      --Elemental
      [262] = function(unit)  end,

      --Enhancement
      [263] = function(unit)  end,

      --Restoration
      [264] = function(unit)  end,
   },

   --MAGE
   [8] = {

      --Arcane
      [62]  = function(unit, eventMonitor) return ewf.unit.class.mage.Arcane:new(unit, eventMonitor) end,

      --Fire
      [63]  = function(unit, eventMonitor) return ewf.unit.class.mage.Fire:new(unit, eventMonitor) end,

      --Frost
      [64]  = function(unit, eventMonitor) return ewf.unit.class.mage.Frost:new(unit, eventMonitor) end
   },

   --WARLOCK
   [9] = {

      --Affliction
      [265] = function(unit)  end,

      --Demonology
      [266] = function(unit)  end,

      --Destruction
      [267] = function(unit)  end,
   },

   --MONK
   [10] = {

      --Brewmaster
      [268] = function(unit)  end,

      --Windwalker
      [269] = function(unit)  end,

      --Mistweaver
      [270] = function(unit)  end,
   },

   --DRUID
   [11] = {

      --Balance
      [102] = function(unit)  end,

      --Feral
      [103] = function(unit)  end,

      --Guardian
      [104] = function(unit)  end,
      
      --Restoration
      [105] = function(unit)  end,
   },

   --DEMONHUNTER
   [12] = {

      --Havoc
      [577] = function(unit)  end,

      --Vengeance
      [581] = function(unit)  end,
   },
};
