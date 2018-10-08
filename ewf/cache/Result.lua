local addon, ewf = ...

----------------------------------------------------------------------------------------------------------------------------------
-- CLASS DEFINITION
----------------------------------------------------------------------------------------------------------------------------------
ewf.cache.Result = {};

----------------------------------------------------------------------------------------------------------------------------------
-- IMPORTS
----------------------------------------------------------------------------------------------------------------------------------
local Result = ewf.cache.Result;

----------------------------------------------------------------------------------------------------------------------------------
-- CONSTRUCTOR
----------------------------------------------------------------------------------------------------------------------------------
function Result:class(child)
   child = child or {};
   local this = ewf.class.Object:class(self);
   setmetatable(child, this);
   this.__index = this;

   return child;
end

function Result:new(callback, callback_self)
   return Result:class({callback=callback, callback_self=callback_self, lastAccess=0, result=0, throttleRate = 0.1,});
end

----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function Result:setThrottleRate(throttleRate)
   self.throttleRate = throttleRate;
end

function Result:getResult(...)
   if((self.lastAccess + self.throttleRate - GetTime()) <= 0) then
      self.lastAccess = GetTime();
      self.result = self.callback(self.callback_self, ...);
   end

   return self.result;
end
