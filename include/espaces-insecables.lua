-- Version HTML : espaces insécables de la typographie française.
-- Dans le source, on tape une espace ordinaire avant « : ; ! ? % » et à
-- l'intérieur des guillemets « ». Ce filtre la remplace par une espace
-- insécable, pour que la ponctuation ne passe jamais seule à la ligne :
--   - espace fine insécable (U+202F) avant ; ! ? % » et après « ;
--   - espace insécable (U+00A0) avant :.
-- Le code (Code, CodeBlock, RawInline, RawBlock) n'est jamais modifié.
-- Dans le PDF, babel-french s'en charge déjà : le filtre ne fait rien.

if not quarto.doc.is_format("html") then
  return {}
end

local FINE = "\u{202F}"
local INSECABLE = "\u{00A0}"

local function premier(s) return pandoc.text.sub(s, 1, 1) end
local function dernier(s) return pandoc.text.sub(s, -1) end

local function blanc(el)
  return el and (el.t == "Space" or el.t == "SoftBreak")
end

function Inlines(inlines)
  for i = 1, #inlines do
    if blanc(inlines[i]) then
      local suivant, precedent = inlines[i + 1], inlines[i - 1]
      if suivant and suivant.t == "Str" then
        local c = premier(suivant.text)
        if c == ":" then
          inlines[i] = pandoc.Str(INSECABLE)
        elseif c == ";" or c == "!" or c == "?" or c == "%" or c == "»" then
          inlines[i] = pandoc.Str(FINE)
        end
      end
      if blanc(inlines[i]) and precedent and precedent.t == "Str"
          and dernier(precedent.text) == "«" then
        inlines[i] = pandoc.Str(FINE)
      end
    end
  end
  return inlines
end
