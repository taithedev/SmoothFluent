local M={Library=nil,Commands={}}
function M:SetLibrary(lib) self.Library=lib return self end
function M:Register(name,callback,description)
 self.Commands[string.lower(name)]={Name=name,Callback=callback,Description=description or ""}
 return self
end
function M:Run(name,...)
 local command=self.Commands[string.lower(name or "")]
 if not command then return false,"command not found" end
 local ok,err=xpcall(function() command.Callback(...) end,debug.traceback)
 if not ok and self.Library then self.Library:SafeCall(self.Library._errorHandler,err,err) end
 return ok,err
end
function M:List()
 local result={}
 for _,command in pairs(self.Commands) do table.insert(result,command) end
 table.sort(result,function(a,b) return a.Name<b.Name end)
 return result
end
return M
