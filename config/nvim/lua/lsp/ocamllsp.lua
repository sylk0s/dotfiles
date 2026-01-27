local root_files = {
  'dune-project',
  '.git',
  "*.opam",
  "esy.json",
  "package.json",
  "dune-workspace"
}

return {
  name = 'ocamllsp',
  cmd = { 'ocamllsp' },
  root_markers = root_files,
--  capabilities = require('user.lsp').make_client_capabilities(),
  filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
  settings = {
    config = {
      extendedHover = { enable = true },
      codelens = { enable = true },
      duneDiagnostics = { enable = false },
      inlayHints = { enable = true },
      syntaxDocumentation = { enable = true },
    },
  },
}
