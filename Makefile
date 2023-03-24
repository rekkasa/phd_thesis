figures/PowerPlot.tiff : code/PowerPlot.R
	$<

figures/ScalePlot.tiff : code/ScalePlot.R
	$<

figures/reviewFigure.tiff : code/ReviewPlot.R
	$<

figures/reviewDiagram.pdf : code/GetReviewDiagram.sh
	$<

figures/riskBenefit.tiff : code/RiskBenefit.R
	$<

figures/hypertensionGuidelines.png :
	wget -O figures/hypertensionGuidelines.png \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/figures/figures/hypertensionGuidelines.png

figures/reviewDiagram.pdf :
	wget -O figures/reviewDiagram.pdf \
		https://github.com/rekkasa/phd_thesis/raw/figures/figures/reviewDiagram.pdf

_book/Baseline-risk-in-medical-decision-making.pdf : _quarto.yml \
	preamble.tex \
	index.qmd \
	intro.qmd \
	ch2_review.qmd \
	ch3_framework.qmd \
	ch4_simulation.qmd \
	ch5_melanoma.qmd \
	ch6_covid.qmd \
	ch7_osteoporosis.qmd \
	ch8_discussion.qmd \
	figures/hypertensionGuidelines.png \
	figures/PowerPlot.tiff \
	figures/reviewFigure.tiff \
	figures/ScalePlot.tiff \
	figures/reviewDiagram.pdf\
	figures/riskBenefit.tiff
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render
