# ===================================================================================================================
# Fetch data
# ===================================================================================================================
data/introduction/gusto.rda : code/ch1-GetGustoData.sh
	$<

figures/hypertensionGuidelines.png :
	wget -O figures/hypertensionGuidelines.png \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/figures/figures/hypertensionGuidelines.png

figures/reviewDiagram.pdf :
	wget -O figures/reviewDiagram.pdf \
		https://github.com/rekkasa/phd_thesis/raw/figures/figures/reviewDiagram.pdf

figures/ch3-Framework.pdf :
	wget -O figures/ch3-Framework.pdf \
		https://github.com/rekkasa/phd_thesis/raw/large-files/figures/ch3-Framework.pdf

data/framework/map_exposures.rds : code/GetRawData.R
	$< map_exposures.rds framework

data/framework/map_outcomes.rds : code/GetRawData.R
	$< map_outcomes.rds framework

data/framework/psDensity_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< psDensity_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/psDensity_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< psDensity_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/psDensity_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< psDensity_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/balance_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< balance_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/balance_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< balance_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/balance_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds : code/GetRawData.R
	$< balance_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds framework

data/framework/mappedOverallResultsNegativeControls.rds : code/GetRawData.R
	$< mappedOverallResultsNegativeControls.rds framework

data/framework/mappedOverallRelativeResults.rds : code/GetRawData.R
	$< mappedOverallRelativeResults.rds framework

data/framework/mappedOverallAbsoluteResults.rds : code/GetRawData.R
	$< mappedOverallAbsoluteResults.rds framework

data/simulation/analysisIds.csv :
	wget -O data/simulation/analysisIds.csv \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/data/simulation/analysisIds.csv

data/simulation/rmse.csv :
	wget -O data/simulation/rmse.csv \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/data/simulation/rmse.csv

# ===================================================================================================================
# Make figures
# ===================================================================================================================
figures/PowerPlot.tiff : code/ch1-PowerPlot.R
	$<

figures/ScalePlot.tiff : code/ch1-ScalePlot.R
	$<

figures/reviewFigure.tiff : code/ch1-ReviewPlot.R
	$<

figures/riskBenefit.tiff : code/ch1-RiskBenefit.R
	$<

figures/ch3-PsDensity.tiff : code/ch3-PsDensityPlot.R \
	data/framework/map_exposures.rds \
	data/framework/psDensity_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds \
	data/framework/psDensity_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds \
	data/framework/psDensity_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds
	$< 

figures/ch3-CovariateBalance.tiff : code/ch3-CovariateBalancePlot.R \
	data/framework/map_exposures.rds \
	data/framework/balance_ccae_730_analysis_ccae_ps_strat_acute_myocardial_infarction_15_1_2_2.rds \
	data/framework/balance_mdcd_730_analysis_mdcd_ps_strat_acute_myocardial_infarction_15_1_2_2.rds \
	data/framework/balance_mdcr_730_analysis_mdcr_ps_strat_acute_myocardial_infarction_15_1_2_2.rds
	$< 

figures/ch3-NegativeControlsOverall.tiff : code/ch3-NegativeControlsOverallPlot.R \
	data/framework/mappedOverallResultsNegativeControls.rds
	$<

figures/ch3-RelativeResultsMain.tiff : code/ch3-CombinedRelativeMain.R \
	data/framework/map_exposures.rds \
	data/framework/map_outcomes.rds \
	data/framework/mappedOverallRelativeResults.rds 
	$< acute_myocardial_infarction main

figures/ch3-AbsoluteResultsMain.tiff : code/ch3-CombinedAbsoluteMain.R \
	data/framework/map_exposures.rds \
	data/framework/map_outcomes.rds \
	data/framework/mappedOverallAbsoluteResults.rds 
	$< acute_myocardial_infarction main

figures/ch3-RelativeResultsSafety.tiff : code/ch3-CombinedRelativeSafety.R \
	data/framework/map_exposures.rds \
	data/framework/map_outcomes.rds \
	data/framework/mappedOverallRelativeResults.rds 
	$< acute_myocardial_infarction main

figures/ch3-AbsoluteResultsSafety.tiff : code/ch3-CombinedAbsoluteSafety.R \
	data/framework/map_exposures.rds \
	data/framework/map_outcomes.rds \
	data/framework/mappedOverallAbsoluteResults.rds 
	$< acute_myocardial_infarction main

figures/rmse_moderate_base.tiff : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/processed/analysisIds.csv
	$< moderate 4250 0.75 base

# ===================================================================================================================
# Make thesis
# ===================================================================================================================
_book/Baseline-risk-in-medical-decision-making.pdf : _quarto.yml \
	preamble.tex \
	index.qmd \
	ch1_introduction.qmd \
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
	figures/riskBenefit.tiff \
	figures/ch3-PsDensity.tiff \
	figures/ch3-Framework.pdf \
	figures/ch3-CovariateBalance.tiff \
	figures/ch3-NegativeControlsOverall.tiff \
	figures/ch3-RelativeResultsMain.tiff \
	figures/ch3-AbsoluteResultsMain.tiff \
	figures/ch3-RelativeResultsSafety.tiff \
	figures/ch3-AbsoluteResultsSafety.tiff
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render

environment :
	R -e "renv::restore()"
