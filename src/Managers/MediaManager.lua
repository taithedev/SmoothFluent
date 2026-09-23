local M={Folder="SmoothFluent/Media"}
function M:SetFolder(x) self.Folder=x return self end
function M:GetCached() return nil end
function M:Cache(url) return url end
return M
