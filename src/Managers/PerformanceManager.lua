local RunService=game:GetService("RunService")
local M={Library=nil,Enabled=false,_connection=nil,FPS=0,FrameTime=0}
function M:SetLibrary(lib) self.Library=lib return self end
function M:Start(callback)
 if self._connection then return self end
 self.Enabled=true
 local frames,elapsed=0,0
 self._connection=RunService.RenderStepped:Connect(function(dt)
  frames+=1;elapsed+=dt;self.FrameTime=dt*1000
  if elapsed>=1 then self.FPS=frames/elapsed;frames=0;elapsed=0;if callback and self.Library then self.Library:SafeCall(callback,self.FPS,self.FrameTime) end end
 end)
 return self
end
function M:Stop() if self._connection then self._connection:Disconnect();self._connection=nil end;self.Enabled=false end
function M:Get() return self.FPS,self.FrameTime end
function M:BuildSection(tab)
 local s=tab:AddSection("Performance")
 s:AddToggle("PerformanceMonitor",{Title="Performance monitor",Default=false,Callback=function(v) if v then self:Start() else self:Stop() end end})
 s:AddParagraph({Title="Runtime stats",Content="Use PerformanceManager:Get() to read FPS and frame time."})
 return s
end
return M
