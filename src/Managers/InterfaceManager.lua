local M={Library=nil,Folder="SmoothFluent"}

function M:SetLibrary(x) self.Library=x return self end
function M:SetFolder(x) self.Folder=x or "SmoothFluent" return self end
function M:ApplyCustomFont() return false,"Roblox runtime fonts are handled by the core renderer." end
function M:BuildInterfaceSection(tab)
 local section=tab:AddSection("Interface")
 local names=self.Library and self.Library:ListThemes() or {"Dark"}
 section:AddDropdown("Theme",{Title="Theme",Values=names,Default=self.Library and self.Library.CurrentTheme and "Dark" or names[1],Callback=function(value)
  if self.Library then self.Library:SetTheme(value) end
 end})
 section:AddToggle("UIVisible",{Title="UI visible",Default=true,Callback=function(value)
  for _,window in ipairs(self.Library._windows or {}) do if value then window:Show() else window:Hide() end end
 end})
 return section
end
function M:LoadSettings() return false,"interface settings are runtime-only" end
return M
