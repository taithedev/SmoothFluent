local Janitor={}
Janitor.__index=Janitor
function Janitor.new() return setmetatable({Tasks={}},Janitor) end
function Janitor:Add(object,method,index)
 index=index or #self.Tasks+1
 self:Remove(index)
 self.Tasks[index]={Object=object,Method=method}
 return object
end
function Janitor:Remove(index)
 local item=self.Tasks[index]
 if not item then return end
 self.Tasks[index]=nil
 local object,method=item.Object,item.Method
 pcall(function()
  if typeof(object)=="RBXScriptConnection" then object:Disconnect()
  elseif type(method)=="function" then method(object)
  elseif type(object)=="function" then object()
  elseif object and method and object[method] then object[method](object)
  elseif object and object.Destroy then object:Destroy() end
 end)
end
function Janitor:Cleanup() for index in pairs(self.Tasks) do self:Remove(index) end end
Janitor.Destroy=Janitor.Cleanup
return Janitor
