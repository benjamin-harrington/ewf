local addon, ewf = ... -- get the addon name and namespace (common table).

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.utils.EwfUtils = {}

local function checkConditionals(conditionals)
   return SecureCmdOptionParse(conditionals);
end

function ewf.utils.EwfUtils:checkConditionals(conditionals)
   return checkConditionals(conditionals);
end

function ewf.utils.EwfUtils:check(conditionals)
   return checkConditionals(conditionals);
end
