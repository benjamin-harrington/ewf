local addon, ewf = ... -- get the addon name and namespace (common table).

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.utils.RangeUtils = {}

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local RangeUtils = ewf.utils.RangeUtils;

----------------------------------------------------------------------------------------------------------------------------------
-- LOCALS
----------------------------------------------------------------------------------------------------------------------------------
local harmfulItems_8_0_1 = {
   [1] = {
   },
   [2] = {
      37727, -- Ruby Acorn
   },
   [3] = {
      42732, -- Everfrost Razor
   },
   [4] = {
      129055, -- Shoe Shine Kit
   },
   [5] = {
      8149, -- Voodoo Charm
      136605, -- Solendra's Compassion
      63427, -- Worgsaw
   },
   [7] = {
      61323, -- Ruby Seeds
   },
   [8] = {
      34368, -- Attuned Crystal Cores
      33278, -- Burning Torch
   },
   [10] = {
      32321, -- Sparrowhawk Net
   },
   [15] = {
      33069, -- Sturdy Rope
   },
   [20] = {
      10645, -- Gnomish Death Ray
   },
   [25] = {
      24268, -- Netherweave Net
      41509, -- Frostweave Net
      31463, -- Zezzak's Shard
   },
   [30] = {
      835, -- Large Rope Net
      7734, -- Six Demon Bag
      34191, -- Handful of Snowflakes
   },
   [35] = {
      24269, -- Heavy Netherweave Net
      18904, -- Zorbin's Ultra-Shrinker
   },
   [38] = {
      140786, -- Ley Spider Eggs
   },
   [40] = {
      28767, -- The Decapitator
   },
   [45] = {
      --        32698, -- Wrangling Rope
      23836, -- Goblin Rocket Launcher
   },
   [50] = {
      116139, -- Haunting Memento
   },
   [55] = {
      74637, -- Kiryn's Poison Vial
   },
   [60] = {
      32825, -- Soul Cannon
      37887, -- Seeds of Nature's Wrath
   },
   [70] = {
      41265, -- Eyesore Blaster
   },
   [80] = {
      35278, -- Reinforced Net
   },
   [90] = {
      133925, -- Fel Lash
   },
   [100] = {
      33119, -- Malister's Frost Wand
   },
   [150] = {
      46954, -- Flaming Spears
   },
   [200] = {
      75208, -- Rancher's Lariat
   },
}

RangeUtils.harmfulItems = harmfulItems_8_0_1;

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function RangeUtils:estimateDistanceToTarget()
   local distance = nil

   if UnitExists("target") and UnitCanAttack("player", "target") then
      for i = 1, #self.harmfulItems do
         local items = self.harmfulItems[i]

         for j = 1, #items do
            local item = self.harmfulItems[j]

            if GetItemInfo(item) and IsItemInRange(item, target) then
               return i
            end
         end
      end
   elseif UnitExists("target") and UnitCanAssist("player", "target") then

   end

   return distance
end

function RangeUtils:countEnemyNameplatesInRange()
   local count = 0

   for i = 1, 40 do

      local unit = "nameplate"..i

      if UnitExists(unit) and UnitCanAttack("player", unit) then
         count = count + 1
      end
   end

   return count
end

function RangeUtils:countEnemyUnitsInRange(range)
   local count = 0

   for i = 1, 40 do
      local unit = "nameplate"..i

      if UnitExists(unit) and UnitCanAttack("player", unit) and self:isUnitInRange(range, unit) then
         count = count + 1
      end
   end

   return count
end

function RangeUtils:isUnitInRange(range, unit)
   if self.harmfulItems[range] then
      local items = self.harmfulItems[range]

      for i = 1, #items do

         local item = items[i]

         if GetItemInfo(item) then
            return IsItemInRange(item, unit)
         end
      end
   end
end
