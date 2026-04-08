
# alteration of egg::tag_facet so that it does not remove
# the facet strips from ggplots
# 2023-01-12

panel_labeller <-
  function(p,
           open = "",
           close = ")",
           tag_pool = letters,
           x = -Inf,
           y = Inf,
           hjust = -0.8,
           vjust = 1.5,
           fontface = 1,
           family = "",
           ...) {
    gb <- ggplot_build(p)
    lay <- gb$layout$layout
    tags <-
      cbind(
        lay,
        label = paste0(open, tag_pool[lay$PANEL], close),
        x = x,
        y = y
      )
    p + geom_text(
      data = tags,
      aes_string(x = "x", y = "y", label = "label"),
      ...,
      hjust = hjust,
      vjust = vjust,
      fontface = fontface,
      col = "gray60",
      size = 3,
      family = family,
      inherit.aes = FALSE
    )
  }