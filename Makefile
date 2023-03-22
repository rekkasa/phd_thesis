figures/PowerPlot.tiff : code/PowerPlot.R
	$<

figures/ScalePlot.tiff : code/ScalePlot.R
	$<

figures/reviewFigure.tiff : code/ReviewPlot.R
	$<

figures/reviewDiagram.pdf : code/GetReviewDiagram.sh
	$<

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
	figures/PowerPlot.tiff \
	figures/reviewFigure.tiff \
	figures/ScalePlot.tiff \
	figures/reviewDiagram.pdf
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render
