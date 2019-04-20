local player = require 'ac.player'
local japi = require 'jass.japi'
register_japi[[

    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native SetHeroLevels takes code f returns nothing 
    native TeleportCaptain takes real x, real y returns nothing
    native GetUnitGoldCost takes integer unitid returns integer

	native DzAPI_Map_SaveServerValue        takes player whichPlayer, string key, string value returns boolean
    native DzAPI_Map_GetServerValue         takes player whichPlayer, string key returns string
    native DzAPI_Map_Ladder_SetStat         takes player whichPlayer, string key, string value returns nothing
    native DzAPI_Map_IsRPGLadder            takes nothing returns boolean
    native DzAPI_Map_GetGameStartTime       takes nothing returns integer
    native DzAPI_Map_Stat_SetStat           takes player whichPlayer, string key, string value returns nothing
    native DzAPI_Map_GetMatchType      		takes nothing returns integer
    native DzAPI_Map_Ladder_SetPlayerStat   takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_GetServerValueErrorCode takes player whichPlayer returns integer
    native DzAPI_Map_GetLadderLevel         takes player whichPlayer returns integer
	native DzAPI_Map_IsRedVIP               takes player whichPlayer returns boolean
	native DzAPI_Map_IsBlueVIP              takes player whichPlayer returns boolean
	native DzAPI_Map_GetLadderRank          takes player whichPlayer returns integer
	native DzAPI_Map_GetMapLevelRank        takes player whichPlayer returns integer
	native DzAPI_Map_GetGuildName           takes player whichPlayer returns string
	native DzAPI_Map_GetGuildRole           takes player whichPlayer returns integer
	native DzAPI_Map_GetMapLevel            takes player whichPlayer returns integer
	native DzAPI_Map_MissionComplete        takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_GetActivityData        takes nothing returns string
	native DzAPI_Map_IsRPGLobby             takes nothing returns boolean
	native DzAPI_Map_GetMapConfig           takes string key returns string
	native DzAPI_Map_HasMallItem            takes player whichPlayer, string key returns boolean

]]

--返回通用型 返回的是字符串型
function player.__index:Map_GetServerValue(key)
    local handle = self.handle
    return japi.DzAPI_Map_GetServerValue(handle,key)
end

--存档通用型 只能存入字符串型
function player.__index:Map_SaveServerValue(key,value)
    local handle = self.handle
    japi.DzAPI_Map_SaveServerValue(handle,tostring(key),tostring(value))
    
end

--获取全局存档 返回字符串型
function ac.Map_GetMapConfig(key)
    return japi.DzAPI_Map_GetMapConfig(key)
end

--获取玩家地图等级
function player.__index:Map_GetMapLevel()
    local handle = self.handle
    return japi.DzAPI_Map_GetMapLevel(handle)
end

--获取玩家地图排名
function player.__index:Map_GetMapLevelRank()
    local handle = self.handle
    return japi.DzAPI_Map_GetMapLevelRank(handle)
end

--设置玩家的房间显示
function player.__index:Map_Stat_SetStat(Key,value)
    local handle = self.handle
    value = tostring(value)
    japi.DzAPI_Map_Stat_SetStat(handle,Key,value)
end

--删除存档 清除掉后无法还原
    --type 大写的 I,S,R,B
function player.__index:Map_FlushStoredMission(Key,type)
    local handle = self.handle
    local key = type..Key
    japi.DzAPI_Map_SaveServerValue(handle,key,nil)
end

--判断玩家是否有商城道具
function player.__index:Map_HasMallItem(key)
    local handle = self.handle
    return japi.DzAPI_Map_HasMallItem(handle,key)
    --测试时，默认都为空
    -- return false
end

--判断玩家服务器存档是否读取成功
function player.__index:GetServerValueErrorCode()
    if japi.DzAPI_Map_GetServerValueErrorCode(self.handle) == 0 then
        return true
    else
        return false
    end
end


--===================================================
--                  下面的一般用不到
--  读取和保存都是字符串类型的，下面函数只是转换了一下类型
--===================================================



--获取整数存档
function player.__index:Map_GetStoredInteger(Key)
    local handle = self.handle
    local key = 'I'..Key
    local value = japi.DzAPI_Map_GetServerValue(handle,key)
    return tonumber(value)
end

--获取字符串存档
function player.__index:Map_GetStoredString(Key)
    local handle = self.handle
    local key = 'S'..Key
    local value = japi.DzAPI_Map_GetServerValue(handle,key)
    return value
end

--获取浮点型存档
function player.__index:Map_GetStoreReal(Key)
    local handle = self.handle
    local key = 'R'..Key
    local value = japi.DzAPI_Map_GetServerValue(handle,key)
    return tonumber(value)
end

--获取布尔型存档
function player.__index:Map_GetStoreBoolean(Key)
    local handle = self.handle
    local key = 'B'..Key
    local value = japi.DzAPI_Map_GetServerValue(handle,key)
    value = tonumber(value)

    if value == 1 then
        return true
    elseif value == 0 then
        return false
    end
end


--存档 保存整数
function player.__index:Map_StoreInteger(Key,value)
    local handle = self.handle
    local key = 'I'..Key  --需要在Key前面补个I
    japi.DzAPI_Map_SaveServerValue(handle,key,tostring(value))
end


--存档 布尔
function player.__index:Map_StoreBoolean(Key,value)
    local handle = self.handle
    local key = 'B'..Key  --需要在Key前面补个B
    if value then
        japi.DzAPI_Map_SaveServerValue(handle,key,'1')
    else
        japi.DzAPI_Map_SaveServerValue(handle,key,'0')
    end
end

--存档 保存浮点型
function player.__index:Map_StoreReal(Key,value)
    local handle = self.handle
    local key = 'R'..Key  --需要在Key前面补个R
    japi.DzAPI_Map_SaveServerValue(handle,key,tostring(value))
end

--存档 保存字符串
function player.__index:Map_StoreString(Key,value)
    local handle = self.handle
    local key = 'S'..Key  --需要在Key前面补个S
    japi.DzAPI_Map_SaveServerValue(handle,key,value)
end
