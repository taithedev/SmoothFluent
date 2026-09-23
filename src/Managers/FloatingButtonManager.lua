local M={Library=nil,Folder="SmoothFluent",Buttons={}}
function M:SetLibrary(x) self.Library=x return self end
function M:SetFolder(x) self.Folder=x return self end
function M:AddButton(name,frame,callback) local b={Name=name,Frame=frame,Callback=callback};table.insert(self.Buttons,b);return b end
function M:BuildConfigSection(tab) local s=tab:AddSection("Floating Buttons");s:AddParagraph({Title="Registered",Content=tostring(#self.Buttons).." button(s) registered."});return s end
function M:LoadAutoloadConfig() return false end
return M
