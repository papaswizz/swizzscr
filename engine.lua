vkeys = require 'vkeys'
sampev = require 'lib.samp.events'
imgui = require 'imgui'
encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local engineOn = imgui.ImBool(false)
local engineOff = imgui.ImBool(true)
local sw, sh = getScreenResolution()

update_state = false
local script_vers = 1
local script_vers_text = '1.00'
local scipt_url = ''
local scipt_path = thisScript().path
local update_url = 'https://raw.githubusercontent.com/papaswizz/swizzscr/main/updatesw.ini'
local update_path = getWorkingDirectory() .. 'updatesw.ini' -- ссылку

sampAddChatMessage('Hi', -1)

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('em', img)
    sampRegisterChatCommand('eng', engine)
    
    imgui.Process = false

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == distatus.STATUS_ENDDOWNLOADDATA then 
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage('Есть обновление! Версия ' .. updateIni.info.vers_text)
                update_state = true 
            end
        end
    end)

    engine = 0
    while true do
        wait(0)
        car = storeCarCharIsInNoSave(PLAYER_PED)

        if main_window_state.v == false then
            imgui.Process = false
        end

            if engine == 1 then
                switchCarEngine(car, true)


            end
            if not sampIsChatInputActive and isKeyDown(0x43) then
                setVirtualKeyDown(0x01, true)
                wait(20)
                setVirtualKeyDown(0x01, false)
                wait(100)
            end
                
    end
end

function engine()
    if engine == 0 then
        engine = 1
    else 
        engine = 0
    end
end

function imgui.OnDrawFrame()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Небольшой помощник', main_window_state)
    imgui.Text('WTF')
    if imgui.Button(u8'Закрыть машину') then 
        sampSendChat('/lock')
    end
    if imgui.Checkbox(u8'Двигатель включен', engineOn) then
        sampAddChatMessage('При посадке в авто, двигатель будет включен', -1)
        engine = 1
    end
    if imgui.Checkbox(u8'Двигатель выключен', engineOff) then
        sampAddChatMessage('При посадке в авто, двигатель будет выключен', -1)
        engine = 0
    end

    imgui.End()
end




function img()
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end