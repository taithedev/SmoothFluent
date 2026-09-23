local M={Library=nil,Folder="SmoothFluent"}
function M:SetLibrary(x) self.Library=x return self end
function M:SetFolder(x) self.Folder=x return self end
function M:ApplyCustomFont() return false,"custom fonts are not available in alpha" end
function M:BuildInterfaceSection(tab) local s=tab:AddSection("Interface");local names={};for n in pairs(self.Library.Themes) do table.insert(names,n) end;s:AddDropdown("Theme",{Title="Theme",Values=names,Default="Dark",Callback=function(v) self.Library:SetTheme(v) end});return s end
function M:LoadSettings() return false end
return M
