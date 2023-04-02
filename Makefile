data/introduction/gusto.rda : code/ch1-GetGustoData.sh
	$<

figures/PowerPlot.tiff : code/ch1-PowerPlot.R
	$<

figures/ScalePlot.tiff : code/ch1-ScalePlot.R
	$<

figures/reviewFigure.tiff : code/ch1-ReviewPlot.R
	$<

figures/riskBenefit.tiff : code/ch1-RiskBenefit.R
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
	references.bib \
	data/introduction/gusto.rda \
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

environment :
	R -e "renv::restore()"
