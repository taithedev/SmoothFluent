local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local TextService=game:GetService("TextService")
local CoreGui=game:GetService("CoreGui")

local Fluent={
 Version="0.2.0-beta",
 Flags={},Options={},Themes={},_windows={},
 _connections={},_destroyed=false
}
Fluent.Themes={
 Dark={Accent=Color3.fromRGB(139,92,246),Background=Color3.fromRGB(12,12,16),Surface=Color3.fromRGB(20,20,27),Surface2=Color3.fromRGB(28,28,37),Border=Color3.fromRGB(54,54,68),Text=Color3.fromRGB(245,245,250),SubText=Color3.fromRGB(165,165,180),Hover=Color3.fromRGB(39,39,51),Success=Color3.fromRGB(74,222,128),Warning=Color3.fromRGB(250,204,21),Error=Color3.fromRGB(248,113,113),Info=Color3.fromRGB(96,165,250)},
 AMOLED={Accent=Color3.fromRGB(168,85,247),Background=Color3.new(0,0,0),Surface=Color3.fromRGB(7,7,9),Surface2=Color3.fromRGB(15,15,18),Border=Color3.fromRGB(38,38,43),Text=Color3.fromRGB(250,250,250),SubText=Color3.fromRGB(150,150,158),Hover=Color3.fromRGB(24,24,28),Success=Color3.fromRGB(74,222,128),Warning=Color3.fromRGB(250,204,21),Error=Color3.fromRGB(248,113,113),Info=Color3.fromRGB(96,165,250)},
 Ocean={Accent=Color3.fromRGB(56,189,248),Background=Color3.fromRGB(7,13,20),Surface=Color3.fromRGB(13,22,33),Surface2=Color3.fromRGB(20,32,46),Border=Color3.fromRGB(38,60,79),Text=Color3.fromRGB(239,248,255),SubText=Color3.fromRGB(155,180,198),Hover=Color3.fromRGB(28,45,61),Success=Color3.fromRGB(74,222,128),Warning=Color3.fromRGB(250,204,21),Error=Color3.fromRGB(248,113,113),Info=Color3.fromRGB(96,165,250)}
}
Fluent.CurrentTheme=Fluent.Themes.Dark

Fluent._errorHandler=function() end

function Fluent:_attachOption(flag, option)
 if type(option) ~= "table" then return option end
 option._changed = option._changed or {}
 local originalSet = option.SetValue
 if originalSet and not option._smoothWrapped then
  option._smoothWrapped = true
  option.SetValue = function(self, value, ...)
   local result = originalSet(self, value, ...)
   for _, callback in ipairs(self._changed) do
    local ok, err = xpcall(function() callback(self:GetValue(), self) end, debug.traceback)
    if not ok then pcall(Fluent._errorHandler, err, err) end
   end
   return result
  end
 end
 function option:OnChanged(callback)
  if type(callback) ~= "function" then return self end
  table.insert(self._changed, callback)
  return self
 end
 function option:RemoveOnChanged(callback)
  for i=#self._changed,1,-1 do
   if self._changed[i] == callback then table.remove(self._changed,i) end
  end
  return self
 end
 function option:Destroy()
  if self.Frame and self.Frame.Destroy then self.Frame:Destroy() end
  return self
 end
 return option
end

setmetatable(Fluent.Options, {
 __newindex=function(t,k,v)
  rawset(t,k,Fluent:_attachOption(k,v))
 end
})

function Fluent:SafeCall(callback,...)
 return safe(callback,...)
end

function Fluent:Tween(instance, duration, properties)
 return tween(instance,duration,properties)
end

function Fluent:Destroy()
 self._destroyed=true
 for _,connection in ipairs(self._connections) do pcall(function() connection:Disconnect() end) end
 table.clear(self._connections)
 for _,window in ipairs(self._windows) do
  pcall(function() if window.Gui then window.Gui:Destroy() end end)
 end
 table.clear(self._windows)
 if self._notifyHolder then pcall(function() self._notifyHolder:Destroy() end) end
 self._notifyHolder=nil
end

function Fluent:GetVersion()
 return self.Version
end

function Fluent:GetTheme()
 return self.CurrentTheme
end

function Fluent:ListThemes()
 local names={}
 for name in pairs(self.Themes) do table.insert(names,name) end
 table.sort(names)
 return names
end


local function safe(fn,...)
 if not fn then return end
 local ok,res=xpcall(fn,debug.traceback,...)
 if not ok then pcall(Fluent._errorHandler,res,res) end
 return res
end
local function tween(o,t,p) local x=TweenService:Create(o,TweenInfo.new(t or .16,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p);x:Play();return x end
local function corner(p,r) local x=Instance.new("UICorner");x.CornerRadius=UDim.new(0,r or 8);x.Parent=p end
local function stroke(p,c,tr) local x=Instance.new("UIStroke");x.Color=c or Fluent.CurrentTheme.Border;x.Transparency=tr or 0;x.Parent=p end
local function pad(p,n) local x=Instance.new("UIPadding");x.PaddingTop=UDim.new(0,n);x.PaddingBottom=UDim.new(0,n);x.PaddingLeft=UDim.new(0,n);x.PaddingRight=UDim.new(0,n);x.Parent=p end
local function text(p,s,z,c) local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=s or "";x.TextColor3=c or Fluent.CurrentTheme.Text;x.TextSize=z or 13;x.Font=Enum.Font.Gotham;x.TextXAlignment=Enum.TextXAlignment.Left;x.TextWrapped=true;x.Parent=p;return x end
local function button(p,s,h) local x=Instance.new("TextButton");x.AutoButtonColor=false;x.Text=s or "";x.TextColor3=Fluent.CurrentTheme.Text;x.TextSize=12;x.Font=Enum.Font.GothamMedium;x.BackgroundColor3=Fluent.CurrentTheme.Surface2;x.Size=UDim2.new(1,0,0,h or 34);x.Parent=p;corner(x,8);stroke(x,Fluent.CurrentTheme.Border,.25);x.MouseEnter:Connect(function() tween(x,.1,{BackgroundColor3=Fluent.CurrentTheme.Hover}) end);x.MouseLeave:Connect(function() tween(x,.1,{BackgroundColor3=Fluent.CurrentTheme.Surface2}) end);return x end
local function parentGui() local ok,h=pcall(function() return gethui and gethui() end);return ok and h or CoreGui end
local function drag(handle,target) local active,start,pos;handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active=true;start=i.Position;pos=target.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then active=false end end) end end);UserInputService.InputChanged:Connect(function(i) if active and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-start;target.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y) end end) end

function Fluent:SetErrorHandler(fn) self._errorHandler=fn or function() end;return self end
function Fluent:RegisterCustomTheme(name,theme) self.Themes[name]=theme;return self end
function Fluent:SetTheme(name) local t=self.Themes[name];if not t then return false end;self.CurrentTheme=t;for _,w in ipairs(self._windows) do w:RefreshTheme() end;return true end

local function makeElement(parent,title,desc,height)
 local f=Instance.new("Frame");f.BackgroundColor3=Fluent.CurrentTheme.Surface;f.Size=UDim2.new(1,0,0,height or (desc and 64 or 48));f.Parent=parent;corner(f,9);stroke(f,Fluent.CurrentTheme.Border,.3);pad(f,10)
 local t=text(f,title,13);t.Position=UDim2.fromOffset(10,7);t.Size=UDim2.new(1,-20,0,22);t.Font=Enum.Font.GothamMedium
 if desc then local d=text(f,desc,10,Fluent.CurrentTheme.SubText);d.Position=UDim2.fromOffset(10,30);d.Size=UDim2.new(1,-20,0,25) end
 return f
end

local function addSection(tab,titleText)
 local sec={Tab=tab,Elements={}}
 local holder=Instance.new("Frame");holder.BackgroundColor3=Fluent.CurrentTheme.Surface;holder.Size=UDim2.new(1,0,0,45);holder.Parent=tab.Page;corner(holder,10);stroke(holder,Fluent.CurrentTheme.Border,.3);pad(holder,8)
 local list=Instance.new("UIListLayout");list.Padding=UDim.new(0,7);list.Parent=holder
 local head=text(holder,titleText or "",12,Fluent.CurrentTheme.SubText);head.Size=UDim2.new(1,0,0,22);head.Font=Enum.Font.GothamBold
 local function resize() holder.Size=UDim2.new(1,0,0,list.AbsoluteContentSize.Y+16) end
 list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
 function sec:SetSearch(q) for _,e in ipairs(self.Elements) do if e.SetSearch then e:SetSearch(q) end end end
 function sec:AddButton(o)
  o=o or {};local f=makeElement(holder,o.Title or "Button",o.Description);local b=button(f,"Run",30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(85,30);b.MouseButton1Click:Connect(function() safe(o.Callback) end)
  local e={Frame=f,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or ""),q,1,true)~=nil end};table.insert(sec.Elements,e);return e
 end
 function sec:AddParagraph(o)
  o=o or {};local f=makeElement(holder,o.Title or "",nil,math.max(56,TextService:GetTextSize(o.Content or "",11,Enum.Font.Gotham,Vector2.new(500,1000)).Y+43));local c=text(f,o.Content or "",11,Fluent.CurrentTheme.SubText);c.Position=UDim2.fromOffset(10,30);c.Size=UDim2.new(1,-20,0,f.Size.Y.Offset-35);local e={Frame=f,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower((o.Title or "").." "..(o.Content or "")),q,1,true)~=nil end};table.insert(sec.Elements,e);return e
 end
 function sec:AddToggle(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description);local state=o.Default==true;local b=button(f,state and "ON" or "OFF",30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(62,30);Fluent.Flags[flag]=state
  local function set(v,fire) state=not not v;Fluent.Flags[flag]=state;b.Text=state and "ON" or "OFF";b.BackgroundColor3=state and Fluent.CurrentTheme.Accent or Fluent.CurrentTheme.Surface2;if fire then safe(o.Callback,state) end end
  b.MouseButton1Click:Connect(function() set(not state,true) end)
  local e={Frame=f,SetValue=function(_,v) set(v,true) end,GetValue=function() return state end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddSlider(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description,78);local rail=Instance.new("Frame");rail.BackgroundColor3=Fluent.CurrentTheme.Border;rail.Position=UDim2.fromOffset(10,48);rail.Size=UDim2.new(1,-20,0,6);rail.Parent=f;corner(rail,3);local fill=Instance.new("Frame");fill.BackgroundColor3=Fluent.CurrentTheme.Accent;fill.Size=UDim2.fromScale(0,1);fill.Parent=rail;corner(fill,3);local val=text(f,"",11);val.TextXAlignment=Enum.TextXAlignment.Right;val.Position=UDim2.new(1,-10,0,8);val.Size=UDim2.fromOffset(80,20)
  local min,max=o.Min or 0,o.Max or 100;local current=math.clamp(o.Default or min,min,max);Fluent.Flags[flag]=current
  local function set(v,fire) current=math.clamp(v,min,max);current=o.Rounding and tonumber(string.format("%."..o.Rounding.."f",current)) or math.floor(current+.5);Fluent.Flags[flag]=current;val.Text=tostring(current);fill.Size=UDim2.fromScale((current-min)/math.max(1,max-min),1);if fire then safe(o.Callback,current) end end
  rail.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local x=math.clamp((i.Position.X-rail.AbsolutePosition.X)/rail.AbsoluteSize.X,0,1);set(min+(max-min)*x,true) end end);set(current,false)
  local e={Frame=f,SetValue=function(_,v) set(v,true) end,GetValue=function() return current end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddInput(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description);local box=Instance.new("TextBox");box.Text=o.Default or "";box.PlaceholderText=o.Placeholder or "";box.ClearTextOnFocus=false;box.TextColor3=Fluent.CurrentTheme.Text;box.PlaceholderColor3=Fluent.CurrentTheme.SubText;box.TextSize=11;box.Font=Enum.Font.Gotham;box.BackgroundColor3=Fluent.CurrentTheme.Surface2;box.Position=UDim2.new(1,-10,0,9);box.AnchorPoint=Vector2.new(1,0);box.Size=UDim2.fromOffset(180,30);box.Parent=f;corner(box,7);Fluent.Flags[flag]=box.Text;box.FocusLost:Connect(function() Fluent.Flags[flag]=box.Text;safe(o.Callback,box.Text) end)
  local e={Frame=f,SetValue=function(_,v) box.Text=tostring(v);Fluent.Flags[flag]=box.Text end,GetValue=function() return box.Text end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddDropdown(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description);local values=o.Values or {};local current=o.Default or values[1];local b=button(f,tostring(current or "Select"),30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(150,30);Fluent.Flags[flag]=current
  b.MouseButton1Click:Connect(function()
   local menu=Instance.new("Frame");menu.BackgroundColor3=Fluent.CurrentTheme.Surface2;menu.Size=UDim2.fromOffset(175,math.min(240,#values*34+10));menu.Position=UDim2.fromOffset(b.AbsolutePosition.X,b.AbsolutePosition.Y+b.AbsoluteSize.Y+4);menu.ZIndex=100;menu.Parent=parentGui();corner(menu,8);stroke(menu,Fluent.CurrentTheme.Border)
   local sc=Instance.new("ScrollingFrame");sc.BackgroundTransparency=1;sc.BorderSizePixel=0;sc.Size=UDim2.fromScale(1,1);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.ScrollBarThickness=2;sc.Parent=menu;pad(sc,5);local lay=Instance.new("UIListLayout");lay.Padding=UDim.new(0,4);lay.Parent=sc
   for _,v in ipairs(values) do local x=button(sc,tostring(v),30);x.ZIndex=101;x.MouseButton1Click:Connect(function() current=v;Fluent.Flags[flag]=v;b.Text=tostring(v);safe(o.Callback,v);menu:Destroy() end) end
  end)
  local e={Frame=f,SetValue=function(_,v) current=v;Fluent.Flags[flag]=v;b.Text=tostring(v) end,GetValue=function() return current end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddColorpicker(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description);local c=o.Default or Color3.new(1,1,1);Fluent.Flags[flag]=c;local b=button(f,"COLOR",30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(75,30);b.BackgroundColor3=c
  local e={Frame=f,SetValue=function(_,v) c=v;Fluent.Flags[flag]=v;b.BackgroundColor3=v;safe(o.Callback,v) end,GetValue=function() return c end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddKeybind(flag,o)
  o=o or {};local f=makeElement(holder,o.Title or flag,o.Description);local key=o.Default or "RightControl";local b=button(f,key,30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(105,30);local mode=o.Mode or "Toggle";local state=false;local connection
  local function bind(k) if connection then connection:Disconnect() end;connection=UserInputService.InputBegan:Connect(function(i,g) if not g and i.KeyCode==k then if mode=="Toggle" then state=not state;safe(o.Callback,state) else safe(o.Callback) end end end) end
  bind(Enum.KeyCode[key] or Enum.KeyCode.RightControl);b.MouseButton1Click:Connect(function() b.Text="Press key";local c;c=UserInputService.InputBegan:Connect(function(i) if i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode.Name;b.Text=key;bind(i.KeyCode);c:Disconnect() end end) end)
  local e={Frame=f,SetValue=function(_,v) key=v;b.Text=v;bind(Enum.KeyCode[v] or v) end,GetValue=function() return key end,SetSearch=function(_,q) f.Visible=q=="" or string.find(string.lower(o.Title or flag),q,1,true)~=nil end};Fluent.Options[flag]=e;table.insert(sec.Elements,e);return e
 end
 function sec:AddDivider() local d=Instance.new("Frame");d.BackgroundColor3=Fluent.CurrentTheme.Border;d.BorderSizePixel=0;d.Size=UDim2.new(1,0,0,1);d.Parent=holder;return d end
 function sec:AddSpace(o) local d=Instance.new("Frame");d.BackgroundTransparency=1;d.Size=UDim2.new(1,0,0,(o or {}).Height or 10);d.Parent=holder;return d end
 function sec:AddCode(o) o=o or {};local f=makeElement(holder,o.Title or "Code",nil,100);local box=Instance.new("TextBox");box.MultiLine=true;box.TextEditable=false;box.ClearTextOnFocus=false;box.Text=o.Code or "";box.TextColor3=Fluent.CurrentTheme.Text;box.TextSize=10;box.Font=Enum.Font.Code;box.TextXAlignment=Enum.TextXAlignment.Left;box.TextYAlignment=Enum.TextYAlignment.Top;box.BackgroundColor3=Fluent.CurrentTheme.Background;box.Position=UDim2.fromOffset(10,32);box.Size=UDim2.new(1,-20,0,58);box.Parent=f;corner(box,6);return {Frame=f} end
 function sec:AddImage(o) o=o or {};local f=makeElement(holder,o.Title or "",nil,180);local im=Instance.new("ImageLabel");im.BackgroundTransparency=1;im.Image=o.Image or "";im.ScaleType=Enum.ScaleType.Fit;im.Position=UDim2.fromOffset(10,30);im.Size=UDim2.new(1,-20,0,140);im.Parent=f;corner(im,o.Radius or 8);return {Frame=f,SetAspectRatio=function() end} end
 function sec:AddVideo(o) return self:AddImage({Title=o.Title or "",Image=o.Video or "",Radius=o.Radius}) end
 function sec:AddAudio(o) o=o or {};local f=makeElement(holder,o.AudioTitle or "Audio",o.AudioSubtitle);local b=button(f,"Play",30);b.AnchorPoint=Vector2.new(1,0);b.Position=UDim2.new(1,-10,0,9);b.Size=UDim2.fromOffset(80,30);local s=Instance.new("Sound");s.SoundId=o.Audio or "";s.Volume=o.Volume or 1;s.Looped=o.Looped or false;s.Parent=f;b.MouseButton1Click:Connect(function() if s.IsPlaying then s:Pause();b.Text="Play" else s:Play();b.Text="Pause" end end);if o.AutoPlay then s:Play();b.Text="Pause" end;return {Frame=f,Sound=s} end
 function sec:AddGroup(o) o=o or {};local f=makeElement(holder,o.Title or "Group",nil,120);local grid=Instance.new("UIGridLayout");grid.CellPadding=UDim2.fromOffset(o.Gap or 8,o.Gap or 8);grid.CellSize=UDim2.new(1/(o.Columns or 2),-8,0,42);grid.Parent=f;local g={Frame=f};function g:AddElement() local h=Instance.new("Frame");h.BackgroundTransparency=1;h.Parent=f;return {AddButton=function(_,x) local z=button(h,x.Title or "Button",32);z.MouseButton1Click:Connect(x.Callback or function() end);return z end} end;return g end
 function sec:AddSocial(o) return self:AddButton({Title=o.DisplayName or o.Username or "Social",Description=o.Platform or o.ProfileUrl,Callback=function() if setclipboard and o.ProfileUrl then setclipboard(o.ProfileUrl) end end}) end
 function sec:AddDiscord(o) return self:AddButton({Title="Discord",Description=o.InviteCode or "Invite",Callback=function() if setclipboard and o.InviteCode then setclipboard("https://discord.gg/"..o.InviteCode) end end}) end
 function sec:AddViewport() return self:AddParagraph({Title="Viewport",Content="Viewport renderer is planned for the next renderer module."}) end
 resize();return sec
end

function Fluent:CreateWindow(o)
 o=o or {};local w={Title=o.Title or "SmoothFluent",SubTitle=o.SubTitle or "",Size=o.Size or UDim2.fromOffset(620,470),Tabs={},_tabs={},_visible=true};table.insert(self._windows,w)
 local gui=Instance.new("ScreenGui");gui.Name="SmoothFluent_"..math.random(10000,99999);gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=parentGui();w.Gui=gui
 local main=Instance.new("Frame");main.Size=w.Size;main.Position=o.Position or UDim2.new(.5,-w.Size.X.Offset/2,.5,-w.Size.Y.Offset/2);main.BackgroundColor3=self.CurrentTheme.Background;main.BackgroundTransparency=.04;main.Parent=gui;corner(main,14);stroke(main,self.CurrentTheme.Border,.1);w.Main=main;drag(bar or main,main)
 local bar=Instance.new("Frame");bar.BackgroundTransparency=1;bar.Size=UDim2.new(1,0,0,58);bar.Parent=main
 local title=text(bar,w.Title,18);title.Position=UDim2.fromOffset(18,7);title.Size=UDim2.new(1,-180,0,25);title.Font=Enum.Font.GothamBold
 local sub=text(bar,w.SubTitle,11,self.CurrentTheme.SubText);sub.Position=UDim2.fromOffset(19,32);sub.Size=UDim2.new(1,-180,0,18)
 local search
 if o.Search~=false then search=Instance.new("TextBox");search.PlaceholderText="Search...";search.ClearTextOnFocus=false;search.TextColor3=self.CurrentTheme.Text;search.PlaceholderColor3=self.CurrentTheme.SubText;search.TextSize=12;search.Font=Enum.Font.Gotham;search.BackgroundColor3=self.CurrentTheme.Surface;search.Size=UDim2.fromOffset(115,32);search.Position=UDim2.new(1,-135,0,13);search.Parent=bar;corner(search,8);stroke(search,self.CurrentTheme.Border,.3);w.SearchBox=search end
 local body=Instance.new("Frame");body.BackgroundTransparency=1;body.Position=UDim2.fromOffset(12,60);body.Size=UDim2.new(1,-24,1,-72);body.Parent=main
 local tabs=Instance.new("ScrollingFrame");tabs.BackgroundColor3=self.CurrentTheme.Surface;tabs.BorderSizePixel=0;tabs.Size=UDim2.new(0,145,1,0);tabs.AutomaticCanvasSize=Enum.AutomaticSize.Y;tabs.ScrollBarThickness=2;tabs.Parent=body;corner(tabs,10);stroke(tabs,self.CurrentTheme.Border,.3);pad(tabs,7);local tl=Instance.new("UIListLayout");tl.Padding=UDim.new(0,5);tl.Parent=tabs
 local pages=Instance.new("Frame");pages.BackgroundTransparency=1;pages.Position=UDim2.fromOffset(155,0);pages.Size=UDim2.new(1,-155,1,0);pages.Parent=body
 function w:RefreshTheme() main.BackgroundColor3=Fluent.CurrentTheme.Background;title.TextColor3=Fluent.CurrentTheme.Text;sub.TextColor3=Fluent.CurrentTheme.SubText;if search then search.BackgroundColor3=Fluent.CurrentTheme.Surface end;tabs.BackgroundColor3=Fluent.CurrentTheme.Surface;for _,t in ipairs(self._tabs) do t:RefreshTheme() end end
 function w:Show() self._visible=true;main.Visible=true end
 function w:Hide() self._visible=false;main.Visible=false end
 function w:Toggle() if self._visible then self:Hide() else self:Show() end end
 function w:SelectTab(i) local t=self._tabs[i];if t then t:Select() end end
 function w:AddTab(to)
  to=to or {};local t={Window=self,Title=to.Title or "Tab",Elements={}};table.insert(self._tabs,t);self.Tabs[t.Title:gsub("%W","")]=t
  local tb=button(tabs,t.Title,34);tb.TextXAlignment=Enum.TextXAlignment.Left;t.Button=tb
  local page=Instance.new("ScrollingFrame");page.BackgroundTransparency=1;page.BorderSizePixel=0;page.Size=UDim2.fromScale(1,1);page.ScrollBarThickness=3;page.AutomaticCanvasSize=Enum.AutomaticSize.Y;page.Visible=false;page.Parent=pages;pad(page,8);local pl=Instance.new("UIListLayout");pl.Padding=UDim.new(0,8);pl.Parent=page;t.Page=page
  function t:Select() for _,x in ipairs(self.Window._tabs) do x.Page.Visible=false;x.Button.BackgroundColor3=Fluent.CurrentTheme.Surface2 end;self.Page.Visible=true;self.Button.BackgroundColor3=Fluent.CurrentTheme.Accent;self.Window.ActiveTab=self end
  function t:RefreshTheme() self.Button.TextColor3=Fluent.CurrentTheme.Text;self.Button.BackgroundColor3=self==self.Window.ActiveTab and Fluent.CurrentTheme.Accent or Fluent.CurrentTheme.Surface2 end
  function t:AddSection(title) local s=addSection(self,title);table.insert(self.Elements,s);return s end
  function t:AddCollapsibleSection(title) return self:AddSection(title) end
  if #self._tabs==1 then t:Select() end
  return t
 end
 if search then search:GetPropertyChangedSignal("Text"):Connect(function() local q=string.lower(search.Text);for _,t in ipairs(w._tabs) do for _,e in ipairs(t.Elements) do if e.SetSearch then e:SetSearch(q) end end end end) end
 UserInputService.InputBegan:Connect(function(i,g) if not g and i.KeyCode==(o.MinimizeKey or Enum.KeyCode.RightControl) then w:Toggle() end end)
 function w:Dialog(x)
  x=x or {};local overlay=Instance.new("Frame");overlay.BackgroundColor3=Color3.new(0,0,0);overlay.BackgroundTransparency=.35;overlay.Size=UDim2.fromScale(1,1);overlay.ZIndex=50;overlay.Parent=gui
  local card=Instance.new("Frame");card.Size=UDim2.fromOffset(390,210);card.Position=UDim2.new(.5,-195,.5,-105);card.BackgroundColor3=Fluent.CurrentTheme.Surface;card.ZIndex=51;card.Parent=overlay;corner(card,12);stroke(card,Fluent.CurrentTheme.Border);pad(card,18)
  local h=text(card,x.Title or "Dialog",18);h.Size=UDim2.new(1,-36,0,25);h.ZIndex=52;local c=text(card,x.Content or "",12,Fluent.CurrentTheme.SubText);c.Position=UDim2.fromOffset(18,55);c.Size=UDim2.new(1,-36,0,65);c.ZIndex=52
  local row=Instance.new("Frame");row.BackgroundTransparency=1;row.Position=UDim2.new(0,18,1,-55);row.Size=UDim2.new(1,-36,0,38);row.ZIndex=52;row.Parent=card;local rl=Instance.new("UIListLayout");rl.FillDirection=Enum.FillDirection.Horizontal;rl.HorizontalAlignment=Enum.HorizontalAlignment.Right;rl.Padding=UDim.new(0,8);rl.Parent=row
  for _,b in ipairs(x.Buttons or {{Title="Close"}}) do local z=button(row,b.Title or "Close",36);z.Size=UDim2.fromOffset(95,36);z.ZIndex=53;z.MouseButton1Click:Connect(function() safe(b.Callback);overlay:Destroy() end) end
  return overlay
 end
 return w
end

function Fluent:Notify(o)
 o=o or {};local holder=self._notifyHolder
 if not holder or not holder.Parent then holder=Instance.new("Frame");holder.BackgroundTransparency=1;holder.AnchorPoint=Vector2.new(1,1);holder.Position=UDim2.new(1,-18,1,-18);holder.Size=UDim2.fromOffset(330,450);holder.Parent=parentGui();local l=Instance.new("UIListLayout");l.VerticalAlignment=Enum.VerticalAlignment.Bottom;l.Padding=UDim.new(0,8);l.Parent=holder;self._notifyHolder=holder end
 local c=self.CurrentTheme[o.Type or "Info"] or self.CurrentTheme.Info;local f=Instance.new("Frame");f.BackgroundColor3=self.CurrentTheme.Surface;f.Size=UDim2.new(1,0,0,75);f.Parent=holder;corner(f,10);stroke(f,c,.15);local t=text(f,o.Title or "SmoothFluent",14);t.Position=UDim2.fromOffset(14,9);t.Size=UDim2.new(1,-25,0,20);t.Font=Enum.Font.GothamBold;local b=text(f,o.Content or "",11,Fluent.CurrentTheme.SubText);b.Position=UDim2.fromOffset(14,32);b.Size=UDim2.new(1,-25,0,35)
 task.delay(o.Duration or 4,function() if f.Parent then tween(f,.18,{BackgroundTransparency=1});task.wait(.2);f:Destroy() end end);return f
end
return Fluent
