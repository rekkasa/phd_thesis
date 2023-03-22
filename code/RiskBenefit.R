#!/usr/bin/env Rscript

library(dplyr)

load("data/introduction/gusto.rda")

gusto <- gusto %>%
  dplyr::tibble() %>%
  dplyr::filter(tx != "SK+tPA") %>%
  dplyr::rename(
    "outcome" = "day30",
    "treatment" = "tpa"
  )

prediction <- glm(
  outcome ~ treatment + age + Killip + pmin(sysbp, 120) + pulse + pmi + miloc,
  data = gusto,
  family = "binomial"
)

riskLinearPredictor <- predict(
  prediction,
  newdata = gusto %>%
    dplyr::mutate(treatment = 0) %>%
    data.frame()
)

smoothSettings <- SmoothHte::createStratifiedSettings()



gusto <- gusto %>%
  dplyr::mutate(riskLinearPredictor = riskLinearPredictor)

stratifiedData <- SmoothHte::fitStratifiedHte(gusto, smoothSettings)

p1 <- stratifiedData$data %>%
  dplyr::mutate(
    estimate = 100 * estimate,
    lower = 100 * lower,
    upper = 100 * upper,
    meanRisk = 100 * meanRisk,
    riskStratum = factor(
      riskStratum,
      levels = 1:4,
      labels = paste0("Q", 1:4)
    )
  ) %>%
  ggplot2::ggplot(
    ggplot2::aes(
      x = riskStratum,
      y = meanRisk
    )
  ) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::scale_y_reverse(limits = c(25, 0)) +
  ggplot2::ylab(label = "Average predicted risk (%)") +
  ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_blank(),
    axis.ticks.x = ggplot2::element_blank(),
    # plot.background = ggplot2::element_rect(fill = "#F1F3F8"),
    plot.background = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
    legend.position = c(.23, .82),
    legend.title = ggplot2::element_blank(),
    legend.box.background = ggplot2::element_rect(color = "black"),
    legend.background = ggplot2::element_rect(fill = "#F1F3F8")
  )

p2 <- stratifiedData$data %>%
  dplyr::mutate(
    estimate = 100 * estimate,
    lower = 100 * lower,
    upper = 100 * upper,
    meanRisk = 100 * meanRisk,
    riskStratum = factor(
      riskStratum,
      levels = 1:4,
      labels = paste0("Q", 1:4)
    )
  ) %>%
  ggplot2::ggplot() +
  ggplot2::geom_pointrange(
    ggplot2::aes(
      x = riskStratum,
      y = estimate,
      ymin = lower,
      ymax = upper,
      color = "Stratified"
    ),
    key_glyph = "rect",
    fatten = .4
  ) +
  ggplot2::scale_y_continuous(
    limits = c(-.5, 5),
    labels = scales::label_number(accuracy = .1)
  ) +
  ggplot2::geom_hline(yintercept = 0, linetype = 2) +
  ggplot2::theme(
    legend.position = "none",
    # plot.background = ggplot2::element_rect(fill = "#F1F3F8"),
    plot.background = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
    legend.title = ggplot2::element_blank(),
    legend.box.background = ggplot2::element_rect(color = "black"),
    legend.background = ggplot2::element_rect(fill = "#F1F3F8")
  )

p <- gridExtra::grid.arrange(p1, p2, ncol = 1)

ggplot2::ggsave(
  "figures/riskBenefit.tiff",
  plot = p,
  height = 4,
  width = 6,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F0F2F3"
)
