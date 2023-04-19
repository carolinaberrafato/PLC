-- Definindo as variáveis de HP dos Pokemons
local pikachuHP = 800
local raichuHP = 1000

-- Definindo as listas de ataques dos Pokemons
local ataques = {
    { nome = "Choque do Trovão", dano = 50 },
    { nome = "Calda de Ferro", dano = 100 },
    { nome = "Investida Trovão", dano = 150 },
    { nome = "Trovão", dano = 200 }
}

-- Função para escolher um ataque randomicamente
local function escolherAtaque()
    return ataques[math.random(#ataques)]
end

-- Função que simula a batalha entre Pikachu e Raichu
local function batalha()
    local vezDoPikachu = true

    while pikachuHP > 0 and raichuHP > 0 do
        coroutine.yield() -- Pausa a execução da coroutine

        -- Escolhe o ataque do Pokemon da vez
        local pokemon, ataque = nil, nil
        if vezDoPikachu then
            pokemon = "Pikachu"
            ataque = escolherAtaque()
        else
            pokemon = "Raichu"
            ataque = escolherAtaque()
        end

        -- Calcula o dano do ataque e atualiza o HP do Pokemon atacado
        local dano = ataque.dano
        if vezDoPikachu then
            raichuHP = raichuHP - dano
        else
            pikachuHP = pikachuHP - dano
        end

        if pikachuHP <= 0 then
            pikachuHP = 0
        elseif raichuHP <= 0 then
            raichuHP = 0
        end
        -- Exibe as informações da jogada
        print(pokemon .. " usou " .. ataque.nome .. " e causou " .. dano .. " de dano!")
        print("Pikachu: " .. pikachuHP .. " / Raichu: " .. raichuHP .. "\n")

        -- Alterna a vez do Pokemon
        vezDoPikachu = not vezDoPikachu
    end

    -- Retorna o vencedor da batalha
    if pikachuHP <= 0 then
        return  print("Raichu venceu!")
    else
        return print("Pikachu venceu!")
    end
end

-- Cria a coroutine da batalha e inicia a execução
local batalhaCoroutine = coroutine.create(batalha)
while coroutine.status(batalhaCoroutine) ~= "dead" do
    coroutine.resume(batalhaCoroutine)
end
