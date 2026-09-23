local Signal={}
Signal.__index=Signal
function Signal.new()
 return setmetatable({_handlers={},_destroyed=false},Signal)
end
function Signal:Connect(callback)
 if self._destroyed or type(callback)~="function" then return {Disconnect=function() end} end
 local item={Callback=callback,Connected=true,_owner=self}
 function item:Disconnect()
  if not self.Connected then return end
  self.Connected=false
  for i,v in ipairs(self._owner._handlers) do
   if v==self then table.remove(self._owner._handlers,i) break end
  end
 end
 table.insert(self._handlers,item)
 return item
end
function Signal:Fire(...)
 if self._destroyed then return end
 for _,item in ipairs(table.clone(self._handlers)) do
  if item.Connected then task.spawn(item.Callback,...) end
 end
end
function Signal:Destroy()
 self._destroyed=true
 table.clear(self._handlers)
end
return Signal
