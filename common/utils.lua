function DisableControls()
    DisableControlAction(1, 14, true)
    DisableControlAction(1, 15, true)
    DisableControlAction(1, 26, true)
    DisableControlAction(1, 30, true)
    DisableControlAction(1, 31, true)
    DisableControlAction(1, 32, true)
    DisableControlAction(1, 33, true)
    DisableControlAction(1, 34, true)
    DisableControlAction(1, 35, true)
    DisableControlAction(1, 36, true)
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 202, true)
    DisablePlayerFiring(PlayerPedId(),true)
end

function Clipboard(Text)
    -- Responsável por abrir uma box message pra que possa ser possível copiar o texto de debug - geralmente vRP.Prompt
    -- Adapte pra sua framework.
    print(Text)
end