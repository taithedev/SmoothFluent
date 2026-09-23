local HttpService=game:GetService("HttpService")
local M={Library=nil,Folder="SmoothFluent",IgnoreIndexes={},IgnoreTheme=true}

function M:SetLibrary(x) self.Library=x return self end
function M:SetFolder(x) self.Folder=x or "SmoothFluent" return self end
function M:IgnoreThemeSettings(value) self.IgnoreTheme=value~=false return self end
function M:SetIgnoreIndexes(list)
 self.IgnoreIndexes={}
 for _,name in ipairs(list or {}) do self.IgnoreIndexes[name]=true end
 return self
end

local function path(self,name) return self.Folder.."/"..tostring(name)..".json" end
local function ensureFolder(folder)
 if makefolder and not isfolder(folder) then pcall(makefolder,folder) end
end

function M:Save(name)
 if not self.Library then return false,"library not set" end
 if not writefile then return false,"writefile unavailable" end
 ensureFolder(self.Folder)
 local data={}
 for key,value in pairs(self.Library.Flags or {}) do
  if not self.IgnoreIndexes[key] then data[key]=value end
 end
 local ok,encoded=pcall(HttpService.JSONEncode,HttpService,data)
 if not ok then return false,encoded end
 local okWrite,err=pcall(writefile,path(self,name or "default"),encoded)
 if not okWrite then return false,err end
 return true
end

function M:Load(name)
 if not self.Library then return false,"library not set" end
 local file=path(self,name or "default")
 if not (readfile and isfile and isfile(file)) then return false,"config not found" end
 local ok,data=pcall(HttpService.JSONDecode,HttpService,readfile(file))
 if not ok or type(data)~="table" then return false,data or "invalid config" end
 for key,value in pairs(data) do
  local option=self.Library.Options[key]
  if option and option.SetValue then pcall(function() option:SetValue(value) end) end
 end
 return true
end

function M:Delete(name)
 if not (delfile and isfile) then return false,"deletefile unavailable" end
 local file=path(self,name or "default")
 if not isfile(file) then return false,"config not found" end
 local ok,err=pcall(delfile,file)
 return ok,err
end

function M:ListConfigs()
 local result={}
 if not (listfiles and isfolder) or not isfolder(self.Folder) then return result end
 for _,file in ipairs(listfiles(self.Folder)) do
  if file:sub(-5)==".json" then table.insert(result,file:match("([^/\\]+)%.json$")) end
 end
 table.sort(result)
 return result
end

function M:SetAutoload(name)
 if not writefile then return false,"writefile unavailable" end
 ensureFolder(self.Folder)
 local ok,err=pcall(writefile,self.Folder.."/autoload.txt",tostring(name or ""))
 return ok,err
end

function M:LoadAutoloadConfig()
 if not (readfile and isfile) then return false,"filesystem unavailable" end
 local file=self.Folder.."/autoload.txt"
 if not isfile(file) then return false,"no autoload config" end
 local name=readfile(file)
 if name=="" then return false,"no autoload config" end
 return self:Load(name)
end

function M:BuildConfigSection(tab)
 local section=tab:AddSection("Configuration")
 section:AddInput("ConfigName",{Title="Config name",Default="default",Placeholder="default"})
 section:AddButton({Title="Save",Callback=function()
  local ok,err=self:Save(self.Library.Flags.ConfigName or "default")
  if self.Library then self.Library:Notify({Title=ok and "Config saved" or "Save failed",Content=err or "Saved successfully.",Type=ok and "Success" or "Error"}) end
 end})
 section:AddButton({Title="Load",Callback=function()
  local ok,err=self:Load(self.Library.Flags.ConfigName or "default")
  if self.Library then self.Library:Notify({Title=ok and "Config loaded" or "Load failed",Content=err or "Loaded successfully.",Type=ok and "Success" or "Error"}) end
 end})
 section:AddButton({Title="Set autoload",Callback=function() self:SetAutoload(self.Library.Flags.ConfigName or "default") end})
 return section
end

return M
