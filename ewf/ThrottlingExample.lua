local THROTTLE_VALUE = 0.2;
local lastAccess1 = 0;
local cachedValue1 = false;

function ewf.public.exampleMethod()
   if((lastAccess1 + THROTTLE_VALUE - GetTime()) <= 0) then
      lastAccess1 = GetTime();

      if(true) then -- Ensure the class we are calling has been created.
         cachedValue1 = nil; --Call here
      end
   end

   return cachedValue1;
end