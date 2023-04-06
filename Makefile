# ===================================================================================================================
# Fetch data
# ===================================================================================================================
data/introduction/gusto.rda : code/ch1-GetGustoData.sh
	$<

figures/hypertensionGuidelines.png :
	wget -O figures/hypertensionGuidelines.png \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/figures/hypertensionGuidelines.png

figures/reviewDiagram.pdf :
	wget -O figures/reviewDiagram.pdf \
		https://github.com/rekkasa/phd_thesis/raw/large-files/figures/reviewDiagram.pdf

figures/ch5-PositiveSlnb.pdf :
	wget -O figures/ch5-PositiveSlnb.pdf \
		https://github.com/rekkasa/phd_thesis/raw/large-files/figures/ch5-PositiveSlnb.pdf

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

data/simulation/discrimination.csv :
	wget -O data/simulation/discrimination.csv \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/data/simulation/discrimination.csv

data/simulation/calibration.csv :
	wget -O data/simulation/calibration.csv \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/data/simulation/calibration.csv

data/simulation/bootstrapData.csv :
	wget -O data/simulation/bootstrapData.csv \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/data/simulation/bootstrapData.csv

data/simulation/scenario_217/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_217
data/simulation/scenario_218/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_218
data/simulation/scenario_219/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_219
data/simulation/scenario_289/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_289

data/simulation/scenario_290/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_290
data/simulation/scenario_291/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_291
data/simulation/scenario_361/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_361
data/simulation/scenario_362/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_362
data/simulation/scenario_363/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_363
data/simulation/scenario_397/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_397
data/simulation/scenario_398/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_398
data/simulation/scenario_399/settings.rds :code/GetRawData.R
	$< settings.rds simulation scenario_399

data/simulation/scenario_241/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_241
data/simulation/scenario_242/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_242
data/simulation/scenario_243/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_243
data/simulation/scenario_313/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_313
data/simulation/scenario_314/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_314
data/simulation/scenario_315/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_315
data/simulation/scenario_385/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_385
data/simulation/scenario_386/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_386
data/simulation/scenario_387/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_387
data/simulation/scenario_421/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_421
data/simulation/scenario_422/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_422
data/simulation/scenario_423/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_423


data/simulation/scenario_225/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_225
data/simulation/scenario_226/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_226
data/simulation/scenario_227/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_227
data/simulation/scenario_297/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_297
data/simulation/scenario_298/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_298
data/simulation/scenario_299/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_299
data/simulation/scenario_369/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_369
data/simulation/scenario_370/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_370
data/simulation/scenario_371/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_371
data/simulation/scenario_405/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_405
data/simulation/scenario_406/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_406
data/simulation/scenario_407/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_407
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

figures/ch4-rmse_moderate_base.tiff : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_217/settings.rds \
	data/simulation/scenario_218/settings.rds \
	data/simulation/scenario_219/settings.rds \
	data/simulation/scenario_289/settings.rds \
	data/simulation/scenario_290/settings.rds \
	data/simulation/scenario_291/settings.rds \
	data/simulation/scenario_361/settings.rds \
	data/simulation/scenario_362/settings.rds \
	data/simulation/scenario_363/settings.rds \
	data/simulation/scenario_397/settings.rds \
	data/simulation/scenario_398/settings.rds \
	data/simulation/scenario_399/settings.rds
	$< moderate 4250 0.75 base

figures/ch4-rmse_moderate_sample_size.tiff : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_241/settings.rds \
	data/simulation/scenario_242/settings.rds \
	data/simulation/scenario_243/settings.rds \
	data/simulation/scenario_313/settings.rds \
	data/simulation/scenario_314/settings.rds \
	data/simulation/scenario_315/settings.rds \
	data/simulation/scenario_385/settings.rds \
	data/simulation/scenario_386/settings.rds \
	data/simulation/scenario_387/settings.rds \
	data/simulation/scenario_421/settings.rds \
	data/simulation/scenario_422/settings.rds \
	data/simulation/scenario_423/settings.rds
	$< moderate 17000 0.75 sample_size

figures/ch4-rmse_moderate_auc.tiff : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_225/settings.rds \
	data/simulation/scenario_226/settings.rds \
	data/simulation/scenario_227/settings.rds \
	data/simulation/scenario_297/settings.rds \
	data/simulation/scenario_298/settings.rds \
	data/simulation/scenario_299/settings.rds \
	data/simulation/scenario_369/settings.rds \
	data/simulation/scenario_370/settings.rds \
	data/simulation/scenario_371/settings.rds \
	data/simulation/scenario_405/settings.rds \
	data/simulation/scenario_406/settings.rds \
	data/simulation/scenario_407/settings.rds 
	$< moderate 4250 0.85 auc

figures/ch4-discrimination_moderate_base.tiff : code/ch4-DiscriminationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/discrimination.csv\
	data/simulation/analysisIds.csv
	$< moderate 4250 0.75 base

figures/ch4-calibration_moderate_base.tiff : code/ch4-CalibrationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/calibration.csv
	$< moderate 4250 0.75 base

figures/ch4-Gusto.tiff : code/ch4-GustoPlot.R\
	data/introduction/gusto.rda\
	data/simulation/bootstrapData.csv
	$<

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
	figures/ch3-AbsoluteResultsSafety.tiff \
	figures/ch4-rmse_moderate_base.tiff \
	figures/ch4-rmse_moderate_sample_size.tiff \
	figures/ch4-rmse_moderate_auc.tiff \
	figures/ch4-discrimination_moderate_base.tiff \
	figures/ch4-calibration_moderate_base.tiff \
	figures/ch4-Gusto.tiff \
	figures/ch5-PositiveSlnb.pdf
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render

environment :
	R -e "renv::restore()"
