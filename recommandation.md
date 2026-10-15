# Recommandation : rendu Markdown OpenCode

`sudo-tee/opencode.nvim` fonctionne avec rendu Treesitter natif. Ajouter
`MeanderingProgrammer/render-markdown.nvim` reste optionnel.

## Intérêt

- rend mieux titres, listes, tableaux et blocs de code dans `opencode_output`;
- améliore lisibilité des réponses longues et des revues de diff.

## Coût

- ajoute une dépendance Neovim;
- ajoute rendu pendant streaming des réponses.

## Configuration proposée

```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    anti_conceal = { enabled = false },
    file_types = { "markdown", "opencode_output" },
  },
  ft = { "markdown", "opencode_output" },
}
```

## Validation et retrait

Après ajout, ouvrir une réponse OpenCode avec Markdown, listes et blocs de code.
Si rendu gêne streaming ou lisibilité, supprimer cette spec : OpenCode conserve
son rendu Treesitter natif.
