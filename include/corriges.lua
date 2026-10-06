-- Version PDF : déplace les réponses (blocs ::: {.corrige}, écrits par
-- exercices(), hide() et unhide() dans _common.R) vers l'annexe « Corrigés »
-- (bloc ::: {#corriges} de corriges.qmd), groupées par chapitre. Chaque
-- réponse reprend le titre de sa question (« Question 3.1 ») avec un lien vers
-- elle. En HTML, le filtre ne fait rien : les réponses restent sous les
-- questions.

if not quarto.doc.is_format("latex") then
  return {}
end

function Pandoc(doc)
  local chapitre, question = nil, nil
  local numero = 0
  local groupes = {}   -- { { titre = ..., reponses = { {question, blocs} } } }

  doc = doc:walk({
    traverse = "topdown",
    Header = function(h)
      if h.level == 1 then
        if not h.classes:includes("unnumbered") then numero = numero + 1 end
        chapitre = { titre = pandoc.utils.stringify(h.content), numero = numero,
                     reponses = {} }
      elseif h.level == 3 then
        question = h
      end
    end,
    Div = function(d)
      if not d.classes:includes("corrige") then return nil end
      if chapitre and #chapitre.reponses == 0 then table.insert(groupes, chapitre) end
      table.insert(chapitre.reponses, { question = question, blocs = d.content })
      return {}, false
    end,
  })

  local annexe = pandoc.Blocks({})
  for _, g in ipairs(groupes) do
    annexe:insert(pandoc.Header(2, "Chapitre " .. g.numero .. " : " .. g.titre,
                                pandoc.Attr("", { "unnumbered" })))
    for _, r in ipairs(g.reponses) do
      local titre = pandoc.utils.stringify(r.question.content)
      annexe:insert(pandoc.Header(4,
        { pandoc.Link(titre, "#" .. r.question.identifier) },
        pandoc.Attr("corrige-" .. r.question.identifier, { "unnumbered" })))
      annexe:extend(r.blocs)
    end
  end

  return doc:walk({
    Div = function(d)
      if d.identifier == "corriges" then
        d.content = annexe
        return d
      end
    end,
  })
end
