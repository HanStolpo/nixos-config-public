final: prev:
{
  tree-sitter = prev.tree-sitter.override {
      extraGrammars = {
        tree-sitter-d2 = prev.lib.importJSON ./tree-sitter-d2.json;
      };
    };
}