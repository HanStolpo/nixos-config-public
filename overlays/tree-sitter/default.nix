final: prev:
let
  d2-grammar-src = prev.fetchgit (removeAttrs (prev.lib.importJSON ./tree-sitter-d2.json) [ "date" "path" ]);
in
{
  tree-sitter-grammars = prev.tree-sitter-grammars // {
    tree-sitter-d2 = prev.tree-sitter.buildGrammar {
      language = "d2";
      version = "0.0.0";
      src = d2-grammar-src;
    };
  };
}
