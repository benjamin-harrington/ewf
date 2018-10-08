local addon, ewf = ... -- get the addon name and namespace (common table).

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.utils.MathUtils = {}

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function ewf.utils.MathUtils:round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0);
  
  return (math.floor(num * mult + 0.5) / mult);
end

function ewf.utils.MathUtils:percent(numerator, denominator)
  return ewf.utils.MathUtils:round((numerator/denominator)*100);
end