local antiDivulgacao = {}

antiDivulgacao.config = {
    mensagemSubstituta = "DRAGON SOULS ATS - O MELHOR SERVIDOR 7.92 DA ATUALIDADE! VENHA JOGAR CONOSCO!",
    mostrarAviso = true,
    mensagemAviso = "Sua mensagem foi bloqueada por conter conteúdo proibido.",
    logarTentativas = true
}

antiDivulgacao.palavrasBloqueadas = {
    "ddns", "com", "br", "online", "org", "net", 
    "http", "https", "www", "sytes",
    "killermamonas", "normandierpg", "ilusion pex", "pysco",
    "aurera", "rubinot", "ilusion", "illusion", "kaldrox",
    "demolidores", "luxot", "rexia", "gunzodus", "auroria",
    "cyleria", "canob", "unline", "aiolosot", "oxygenot",
    "blacktalon", "noxiousot", "otmadness", "furiaot",
    "retrotibia", "netunia", "icewar", "evolunia", "natala",
    "karma", "arinar", "primot", "fast", "rezoria",
    "baiaksp", "brazzinum", "pbotwars", "amonot", "mazeot",
    "holiday", "redbaiak", "baiakworld", "nostalther",
    "baiakao", "taleon", "vantoria", "marlboro", "mythibia",
    "thornia", "slaynville", "necroxia", "taleonaura",
    "limbo", "baiakeria", "heroserv", "giveria", "oldlucera",
    "glabela", "underwar", "baiakeros", "middleearth",
    "drakonia", "spiderot", "valdraken", "vestia", "tibiara",
    "alastera", "kimeraot", "balrogot", "mexas", "antiga",
    "elderan", "modukot", "exordionlegacy", "jobot", "dura",
    "treasura", "valeriaot", "oasis", "falumirot",
    "vendettaots", "realots", "geniumot", "aqueleot",
    "vanyria", "dragot", "galanaxot", "armada", "cyntara",
    "zinxot", "alphaot", "arcananemesis", "arcananmsis", 
    "arcana nemesis", "script", "scripts", "tyr"
}

function antiDivulgacao.normalizarTexto(texto)
    if not texto then return "" end
    texto = texto:lower()
    local acentos = {
        ["á"] = "a", ["à"] = "a", ["ã"] = "a", ["â"] = "a", ["ä"] = "a",
        ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
        ["í"] = "i", ["ì"] = "i", ["î"] = "i", ["ï"] = "i",
        ["ó"] = "o", ["ò"] = "o", ["õ"] = "o", ["ô"] = "o", ["ö"] = "o",
        ["ú"] = "u", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
        ["ç"] = "c", ["ñ"] = "n"
    }
    for acento, normal in pairs(acentos) do
        texto = texto:gsub(acento, normal)
    end
    return texto
end

function antiDivulgacao.verificarTexto(texto)
    if not texto or texto == "" then
        return false, nil
    end
    local textoNormalizado = antiDivulgacao.normalizarTexto(texto)
    for _, palavra in ipairs(antiDivulgacao.palavrasBloqueadas) do
        if textoNormalizado:find(palavra, 1, true) then
            return true, palavra
        end
    end
    return false, nil
end

function checkMessage(texto, isStaff)
    if isStaff then
        return false, ""
    end
    
    local contemPalavra, palavra = antiDivulgacao.verificarTexto(texto)
    
    if contemPalavra then
        return true, antiDivulgacao.config.mensagemSubstituta
    end
    
    return false, ""
end

return antiDivulgacao
