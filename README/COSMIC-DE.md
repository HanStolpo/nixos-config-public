
Window navigation with stacked windows
---------------------------------------

There is no way to have alternate windows navigation for the tabs in a stack,
e.g. having navigate left/right not select next previous tab but below are
some hints for dealing with it appropriately.

1. Super+U — Focus(Out), the real answer. It focuses the stack as a group
   (you'll see the whole stack highlighted). Every tab-cycling branch in
   handle_focus is guarded by group_focused == false, so once the group is
   focused, Super+Left/Right/Up/Down treat the entire stack as a single window
   and go straight to its neighbors. Super+I (Focus(In)) drops you back into
   the active tab.
2. Up/Down never cycle tabs. Stacks are horizontal tab bars, so vertical focus
   escapes to the neighbor immediately. Only Left/Right are intercepted.
3. Hold Super while traversing. The stack remembers which tab was active when
   you first pressed the modifier; if you keep Super held and walk Left/Right
   through the stack and out the far side (or leave via Up/Down), it restores
   the originally-active tab. So tapping Super+Left repeatedly passes through a
   stack without permanently disturbing its tab selection — it costs extra
   keypresses but doesn't lose state.

