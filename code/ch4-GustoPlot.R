#!/usr/bin/env Rscript

library(tidyverse)
library(rms)
library(SmoothHte)

maxRisk <- .25

load("data/introduction/gusto.rda")
gusto <- gusto %>%
  tibble() %>%
  filter(tx != "SK+tPA") %>%
  rename(
    "outcome" = "day30",
    "treatment" = "tpa"
  )

prediction <- lrm(
  outcome ~ treatment + age + Killip + pmin(sysbp, 120) + lsp(pulse, 50) + pmi + miloc,
  data = gusto,
  maxit = 99
)

riskLinearPredictor <- predict(
  prediction,
  newdata = gusto %>%
    mutate(treatment = 0) %>%
    data.frame()
)

gusto <- gusto %>%
  mutate(
    riskLinearPredictor = riskLinearPredictor
  )
bootstrapData <- readr::read_csv("data/simulation/bootstrapData.csv")

constantModel <- fitModelBasedHte(
  data     = gusto,
  settings = createModelBasedSettings(type = "treatment")
)

stratified <- fitStratifiedHte(
  data     = gusto,
  settings = createStratifiedSettings()
)

linearModel <- fitModelBasedHte(
  data     = gusto,
  settings = createModelBasedSettings()
)

rcs3Model <- fitRcsHte(
  data     = gusto,
  settings = createRcsSettings()
)

scale_custom <- list(
  scale_color_manual(
    values = c(
      "#63AAC0",
      "#969A97",
      "#F99B45",
      "#D95980"
    ),
    breaks = c(
      "Constant treatment effect",
      "Stratified",
      "Linear interaction",
      "RCS 3 knots"
    )
  ),
  scale_fill_manual(
    values = c(
      "#63AAC0",
      "#F99B45",
      "#D95980"
    ),
    breaks = c(
      "Constant treatment effect",
      "Linear interaction",
      "RCS 3 knots"
    )
  ),
  scale_linetype_manual(
    values = c("dashed", "solid", "solid"),
    breaks = c(
      "Constant treatment effect",
      "Linear interaction",
      "RCS 3 knots"
    ),
    guide = "none"
  )
)

plot <- ggplot() +
  geom_pointrange(
    data = bootstrapData %>%
      filter(method == "stratified") %>%
      bind_cols(
        tibble(value = stratified$data$estimate)
      ),
    aes(
      x     = risk,
      y     = value,
      ymin  = lower,
      ymax  = upper,
      color = "Stratified"
    ),
    key_glyph = "rect",
    fatten = .4
  ) +
  geom_errorbarh(
    data = bootstrapData %>%
      filter(method == "stratified") %>%
      bind_cols(
        tibble(value = stratified$data$estimate)
      ),
    size = .4,
    inherit.aes = FALSE,
    aes(
      y = value,
      xmin = lowerRisk,
      xmax = upperRisk,
      height = 0,
      color = "Stratified"
    )
  ) +
  stat_function(
    data = data.frame(
      x     = c(.001, maxRisk),
      label = "Constant treatment effect"
    ),
    aes(
      x     = x,
      color = label,
      linetype = label
    ),
    size = .95,
    alpha = 1,
    fun  = predictBenefitModelBasedHte,
    args = list(
      modelBasedFit = constantModel
    )
  ) +
  geom_ribbon(
    data = bootstrapData %>%
      filter(method == "constant") %>%
      rename("x" = "risk") %>%
      mutate(label = "Constant treatment effect"),
    aes(ymin = lower, ymax = upper, x = x, fill = label),
    alpha = .1,
    color = NA,
    outline.type = "full",
    show.legend = FALSE
  ) +
  stat_function(
    data = data.frame(
      x = c(.001, maxRisk),
      label = "Linear interaction"
    ),
    aes(
      x     = x,
      linetype = label,
      color = label
    ),
    size = .95,
    fun  = predictBenefitModelBasedHte,
    args = list(
      modelBasedFit = linearModel
    )
  ) +
  geom_ribbon(
    data = bootstrapData %>%
      filter(method == "linear") %>%
      rename("x" = "risk") %>%
      mutate(label = "Linear interaction"),
    aes(ymin = lower, ymax = upper, x = x, fill = label),
    alpha = .1,
    color = NA,
    outline.type = "full",
    show.legend = FALSE
  ) +
  stat_function(
    data = data.frame(
      x = c(.001, maxRisk),
      label = "RCS 3 knots"
    ),
    aes(
      x     = x,
      color = label,
      linetype = label
    ),
    size = .95,
    fun  = predictSmoothBenefit,
    args = list(
      smoothFit = rcs3Model
    )
  ) +
  geom_ribbon(
    data = bootstrapData %>%
      filter(method == "rcs") %>%
      rename("x" = "risk") %>%
      mutate(label = "RCS 3 knots"),
    aes(ymin = lower, ymax = upper, x = x, fill = label),
    alpha = .1,
    color = NA,
    outline.type = "full",
    show.legend = FALSE
  ) +
  scale_custom +
  xlab("Baseline risk") +
  ylab("Predicted benefit") +
  theme(
    legend.title = element_blank(),
    axis.text.x = ggplot2::element_text(size = 12),
    axis.text.y = ggplot2::element_text(size = 12),
    axis.title = ggplot2::element_text(size = 14),
    legend.text = element_text(size = 10),
    legend.position = c(.17, .85),
    legend.box.background = ggplot2::element_blank(),
    legend.background = ggplot2::element_rect(fill = "#F0F2F3"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1)
  )

ggplot2::ggsave(
  file.path("figures", "ch4-Gusto.tiff"),
  plot = plot,
  height = 6.5,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
