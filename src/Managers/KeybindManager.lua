local UIS=game:GetService("UserInputService")
local M={Library=nil,Bindings={}}
function M:SetLibrary(lib) self.Library=lib return self end
function M:Register(name,key,callback,mode)
 self:Unregister(name)
 local state=false
 local connection=UIS.InputBegan:Connect(function(input,processed)
  if processed then return end
  if input.KeyCode~=key and input.UserInputType~=key then return end
  mode=mode or "Toggle"
  if mode=="Hold" then state=true elseif mode=="Toggle" then state=not state else state=true end
  if callback and self.Library then self.Library:SafeCall(callback,state,input) end
 end)
 self.Bindings[name]={Key=key,Mode=mode,Callback=callback,Connection=connection,GetState=function() return state end}
 return self.Bindings[name]
end
function M:Unregister(name)
 local b=self.Bindings[name]
 if b and b.Connection then b.Connection:Disconnect() end
 self.Bindings[name]=nil
end
function M:Clear() for name in pairs(self.Bindings) do self:Unregister(name) end end
function M:Destroy() self:Clear() end
return M
