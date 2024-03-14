local amount = 4
local ammanettato = false
local failed = false
local done = 0
local liberato = false
local currentPrompt
local created = false


Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)
        if Citizen.InvokeNative(0x3AA24CCC0D451379, PlayerPedId()) then

            if not ammanettato then
                ammanettato = true
                liberato = false
            end

        elseif not Citizen.InvokeNative(0x3AA24CCC0D451379, PlayerPedId()) then
            if ammanettato then
                ammanettato = false
                liberato = true
                failed = false
                if currentPrompt ~= nil then
                    PromptDelete(currentPrompt)
                    currentPrompt = nil
                    created = false
                end
            end
        end

        if ammanettato then
            if not failed then
                if created == false and not liberato then
                    setup2({hint = 'Slegati'})
                end
                if IsControlJustPressed(0, 0xCEFD9220) then
                    
                    for i = 1, amount do
        
                        if exports["zm_minigame"]:CreateSkillbar(1, "medium") then
                            done = done +1 
                        else 
                            failed = true
                            PromptDelete(currentPrompt)
                            Citizen.Wait(500)
                            currentPrompt = nil
                            created = false
                            break
                        end
                        Citizen.Wait(500)
                    end

                    if done >= amount and not failed then
                        liberato = true
                        failed = false
                        if currentPrompt ~= nil then
                            PromptDelete(currentPrompt)
                            currentPrompt = nil
                            created = false
                        end
                    end
                end
            end
        end


        
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not liberato then
            DisableControlAction(0, 0x295175BF, true)
        else

            Citizen.Wait(500)
        end
    end
end)


function setup2(prompts)
        if currentPrompt == nil then
            if created == false then
                local str = prompts.hint or ''
                local prompt = Citizen.InvokeNative(0x04F97DE45A519419, Citizen.ReturnResultAnyway())
                PromptSetControlAction(prompt, 0xCEFD9220)
                str = CreateVarString(10, 'LITERAL_STRING', str)
                PromptSetText(prompt, str)
                PromptSetEnabled(prompt, 1)
                PromptSetVisible(prompt, 1)
                PromptSetStandardMode(prompt, 1)
                PromptRegisterEnd(prompt)
                currentPrompt = prompt
                created = true
            end
        end

end
