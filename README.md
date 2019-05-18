# BetterYSort

Can be used in place of Godot's built-in `YSort` in order to support customizing the y-value used to sort on nodes. 

An example use-case is for a `Path2D` node which is the direct child of a `YSort`. In this case you would likely want to use the global y-position of the `Path2D`'s child `PathFollow2D` as the sort value.

Supports nesting multiple `BetterYSort` nodes for organization. All child `BetterYSort` nodes are flattened into the top-level `BetterYSort` when the `_ready()` method is called on the base node.

Credit to u/Shianiawhite for the initial implementation (https://www.reddit.com/r/godot/comments/apul4s/is_zindex_the_only_drawing_order_option_for/)
