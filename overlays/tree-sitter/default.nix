final: prev:
{
  tree-sitter = prev.pkgs-unstable.tree-sitter.override {
      extraGrammars = {
        tree-sitter-d2 = prev.lib.importJSON ./tree-sitter-d2.json;
        #tree-sitter-nix = prev.lib.importJSON ./tree-sitter-nix.json;
      };
    };
}
