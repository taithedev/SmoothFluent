local HttpService=game:GetService("HttpService")
local M={Library=nil,Folder="SmoothFluent"}
function M:SetLibrary(x) self.Library=x return self end
function M:SetFolder(x) self.Folder=x return self end
function M:IgnoreThemeSettings() return self end
local function path(self,n) return self.Folder.."/"..n..".json" end
function M:Save(n)
 if not writefile then return false,"writefile unavailable" end
 if makefolder and not isfolder(self.Folder) then pcall(makefolder,self.Folder) end
 local ok,s=pcall(HttpService.JSONEncode,HttpService,self.Library.Flags or {});if not ok then return false,s end
 writefile(path(self,n),s);return true
end
function M:Load(n)
 if not (readfile and isfile and isfile(path(self,n))) then return false,"config not found" end
 local ok,d=pcall(HttpService.JSONDecode,HttpService,readfile(path(self,n)));if not ok then return false,d end
 for k,v in pairs(d) do local e=self.Library.Options[k];if e and e.SetValue then pcall(e.SetValue,e,v) end end
 return true
end
function M:BuildConfigSection(tab) local s=tab:AddSection("Configuration");s:AddInput("ConfigName",{Title="Config name",Default="default"});s:AddButton({Title="Save",Callback=function() self:Save(self.Library.Flags.ConfigName or "default") end});s:AddButton({Title="Load",Callback=function() self:Load(self.Library.Flags.ConfigName or "default") end});return s end
function M:LoadAutoloadConfig() return false end
return M
