# ===================================================================================================================
# Setup for simulation scenarios (chapter 4)
# ===================================================================================================================
ids = $(shell seq 1 724)
dd = $(addprefix scenario_, $(ids))
directories = $(addprefix data/simulation/, $(dd))
simulation_files = $(addsuffix /settings.rds, $(directories))

# ===================================================================================================================
# Fetch data
# ===================================================================================================================
data/introduction/gusto.rda : code/ch1-GetGustoData.sh
	$<

data/simulation/%.csv :
	wget -O $@ https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/$@

data/framework/%.rds : code/GetRawData.R
	$< $@

$(simulation_files) : code/GetRawData.R
	$< $@

# ===================================================================================================================
# Make figures
# ===================================================================================================================
figures/%.pdf :
	wget -O $@ https://github.com/rekkasa/phd_thesis/raw/large-files/$@

figures/hypertensionGuidelines.png :
	wget -O figures/hypertensionGuidelines.png \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/figures/hypertensionGuidelines.png

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

figures/ch3-NegativeControlsRiskStratified_ccae.tiff : code/ch3-NegativeControlsRiskStratifiedPlot.R \
	data/framework/negativeControls_ccae.rds
	$< ccae

figures/ch3-NegativeControlsRiskStratified_mdcd.tiff : code/ch3-NegativeControlsRiskStratifiedPlot.R \
	data/framework/negativeControls_mdcd.rds
	$< mdcd

figures/ch3-NegativeControlsRiskStratified_mdcr.tiff : code/ch3-NegativeControlsRiskStratifiedPlot.R \
	data/framework/negativeControls_mdcr.rds
	$< mdcr

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

figures/ch4-rmse_moderate_base.pdf : code/ch4-PlotRmse.R\
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
	$< moderate 4250 0.75 base FALSE

figures/ch4-rmse_moderate_sample_size.pdf : code/ch4-PlotRmse.R\
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
	$< moderate 17000 0.75 sample_size FALSE

figures/ch4-rmse_moderate_auc.pdf : code/ch4-PlotRmse.R\
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
	$< moderate 4250 0.85 auc FALSE

figures/ch4-rmse_high_base.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_433/settings.rds \
	data/simulation/scenario_434/settings.rds \
	data/simulation/scenario_435/settings.rds \
	data/simulation/scenario_505/settings.rds \
	data/simulation/scenario_506/settings.rds \
	data/simulation/scenario_507/settings.rds \
	data/simulation/scenario_577/settings.rds \
	data/simulation/scenario_578/settings.rds \
	data/simulation/scenario_579/settings.rds \
	data/simulation/scenario_613/settings.rds \
	data/simulation/scenario_614/settings.rds \
	data/simulation/scenario_615/settings.rds
	$< high 4250 0.75 base FALSE

figures/ch4-rmse_high_sample_size.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_457/settings.rds \
	data/simulation/scenario_458/settings.rds \
	data/simulation/scenario_459/settings.rds \
	data/simulation/scenario_529/settings.rds \
	data/simulation/scenario_530/settings.rds \
	data/simulation/scenario_531/settings.rds \
	data/simulation/scenario_601/settings.rds \
	data/simulation/scenario_602/settings.rds \
	data/simulation/scenario_603/settings.rds \
	data/simulation/scenario_637/settings.rds \
	data/simulation/scenario_638/settings.rds \
	data/simulation/scenario_639/settings.rds
	$< high 17000 0.75 sample_size FALSE

figures/ch4-rmse_high_auc.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIds.csv \
	data/simulation/scenario_441/settings.rds \
	data/simulation/scenario_442/settings.rds \
	data/simulation/scenario_443/settings.rds \
	data/simulation/scenario_513/settings.rds \
	data/simulation/scenario_514/settings.rds \
	data/simulation/scenario_515/settings.rds \
	data/simulation/scenario_585/settings.rds \
	data/simulation/scenario_586/settings.rds \
	data/simulation/scenario_587/settings.rds \
	data/simulation/scenario_621/settings.rds \
	data/simulation/scenario_622/settings.rds \
	data/simulation/scenario_623/settings.rds
	$< high 4250 0.85 auc FALSE

figures/ch4-rmse_interaction_positive.pdf : code/ch4-PlotRmseInteractions.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsInteractions.csv \
	data/simulation/scenario_649/settings.rds \
	data/simulation/scenario_650/settings.rds \
	data/simulation/scenario_651/settings.rds \
	data/simulation/scenario_652/settings.rds \
	data/simulation/scenario_653/settings.rds \
	data/simulation/scenario_654/settings.rds \
	data/simulation/scenario_655/settings.rds \
	data/simulation/scenario_656/settings.rds \
	data/simulation/scenario_657/settings.rds \
	data/simulation/scenario_658/settings.rds \
	data/simulation/scenario_659/settings.rds \
	data/simulation/scenario_660/settings.rds
	$< positive

figures/ch4-rmse_interaction_negative.pdf : code/ch4-PlotRmseInteractions.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsInteractions.csv \
	data/simulation/scenario_661/settings.rds \
	data/simulation/scenario_662/settings.rds \
	data/simulation/scenario_663/settings.rds \
	data/simulation/scenario_664/settings.rds \
	data/simulation/scenario_665/settings.rds \
	data/simulation/scenario_666/settings.rds \
	data/simulation/scenario_667/settings.rds \
	data/simulation/scenario_668/settings.rds \
	data/simulation/scenario_669/settings.rds \
	data/simulation/scenario_670/settings.rds \
	data/simulation/scenario_671/settings.rds \
	data/simulation/scenario_672/settings.rds
	$< negative

figures/ch4-rmse_interaction_combined.pdf : code/ch4-PlotRmseInteractions.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsInteractions.csv \
	data/simulation/scenario_673/settings.rds \
	data/simulation/scenario_674/settings.rds \
	data/simulation/scenario_675/settings.rds \
	data/simulation/scenario_676/settings.rds
	$< combined

figures/ch4-rmse_moderate_base_sensitivity.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsSensitivity.csv \
	data/simulation/scenario_677/settings.rds \
	data/simulation/scenario_678/settings.rds \
	data/simulation/scenario_679/settings.rds \
	data/simulation/scenario_681/settings.rds \
	data/simulation/scenario_682/settings.rds \
	data/simulation/scenario_683/settings.rds \
	data/simulation/scenario_685/settings.rds \
	data/simulation/scenario_686/settings.rds \
	data/simulation/scenario_687/settings.rds \
	data/simulation/scenario_689/settings.rds \
	data/simulation/scenario_690/settings.rds \
	data/simulation/scenario_691/settings.rds
	$< moderate 4250 0.75 base TRUE 

figures/ch4-rmse_moderate_sample_size_sensitivity.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsSensitivity.csv \
	data/simulation/scenario_693/settings.rds \
	data/simulation/scenario_694/settings.rds \
	data/simulation/scenario_695/settings.rds \
	data/simulation/scenario_697/settings.rds \
	data/simulation/scenario_698/settings.rds \
	data/simulation/scenario_699/settings.rds \
	data/simulation/scenario_701/settings.rds \
	data/simulation/scenario_702/settings.rds \
	data/simulation/scenario_703/settings.rds \
	data/simulation/scenario_705/settings.rds \
	data/simulation/scenario_706/settings.rds \
	data/simulation/scenario_707/settings.rds
	$< moderate 17000 0.75 sample_size TRUE 

figures/ch4-rmse_moderate_auc_sensitivity.pdf : code/ch4-PlotRmse.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	code/ch4-Absolute.R\
	data/simulation/rmse.csv\
	data/simulation/analysisIdsSensitivity.csv \
	data/simulation/scenario_709/settings.rds \
	data/simulation/scenario_710/settings.rds \
	data/simulation/scenario_711/settings.rds \
	data/simulation/scenario_713/settings.rds \
	data/simulation/scenario_714/settings.rds \
	data/simulation/scenario_715/settings.rds \
	data/simulation/scenario_717/settings.rds \
	data/simulation/scenario_718/settings.rds \
	data/simulation/scenario_719/settings.rds \
	data/simulation/scenario_721/settings.rds \
	data/simulation/scenario_722/settings.rds \
	data/simulation/scenario_723/settings.rds
	$< moderate 4250 0.85 auc TRUE 

figures/ch4-discrimination_moderate_base.pdf : code/ch4-DiscriminationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/discrimination.csv\
	data/simulation/analysisIds.csv
	$< moderate 4250 0.75 base

figures/ch4-calibration_moderate_base.pdf : code/ch4-CalibrationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/calibration.csv
	$< moderate 4250 0.75 base

figures/ch4-Gusto.tiff : code/ch4-GustoPlot.R\
	data/introduction/gusto.rda\
	data/simulation/bootstrapData.csv
	$<


figures/ch4-Selected_model_adaptive_base.tiff : code/ch4-SelectedModelAdaptive.R\
	data/simulation/analysisIds.csv\
	data/simulation/adaptiveModel.csv
	$< moderate 4250 0.75 base

figures/ch4-Selected_model_adaptive_sample_size.tiff : code/ch4-SelectedModelAdaptive.R\
	data/simulation/analysisIds.csv\
	data/simulation/adaptiveModel.csv
	$< moderate 17000 0.75 sample_size

figures/ch4-Selected_model_adaptive_auc.tiff : code/ch4-SelectedModelAdaptive.R\
	data/simulation/analysisIds.csv\
	data/simulation/adaptiveModel.csv
	$< moderate 4250 0.85 auc

figures/ch4-discrimination_moderate_sample_size.pdf : code/ch4-DiscriminationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/discrimination.csv\
	data/simulation/analysisIds.csv
	$< moderate 17000 0.75 sample_size

figures/ch4-discrimination_moderate_auc.pdf : code/ch4-DiscriminationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/discrimination.csv\
	data/simulation/analysisIds.csv
	$< moderate 4250 0.85 auc

figures/ch4-calibration_moderate_sample_size.pdf : code/ch4-CalibrationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/calibration.csv
	$< moderate 17000 0.75 sample_size

figures/ch4-calibration_moderate_auc.pdf : code/ch4-CalibrationBase.R\
	code/ch4-CreateManuscriptPlots.R\
	code/ch4-PlotResult.R\
	data/simulation/calibration.csv
	$< moderate 4250 0.85 auc
# ===================================================================================================================
# Make thesis
# ===================================================================================================================
_book/Beyond-the-average-treatment-effect.pdf : _quarto.yml \
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
	ch3_appendix.qmd \
	ch4_appendix.qmd \
	summary.qmd \
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
	figures/ch3-SupplementaryFigure1.pdf \
	figures/ch3-SupplementaryFigure2.pdf \
	figures/ch3-SupplementaryFigure3.pdf \
	figures/ch3-SupplementaryFigure4.pdf \
	figures/ch3-SupplementaryFigure5.pdf \
	figures/ch3-SupplementaryFigure6.pdf \
	figures/ch3-SupplementaryFigure7.pdf \
	figures/ch3-SupplementaryFigure8.pdf \
	figures/ch3-SupplementaryFigure9.pdf \
	figures/ch3-SupplementaryFigure10.pdf \
	figures/ch3-SupplementaryFigure11.pdf \
	figures/ch4-rmse_moderate_base.pdf \
	figures/ch4-rmse_moderate_sample_size.pdf \
	figures/ch4-rmse_moderate_auc.pdf \
	figures/ch4-discrimination_moderate_base.pdf \
	figures/ch4-calibration_moderate_base.pdf \
	figures/ch4-Gusto.tiff \
	figures/ch4-Selected_model_adaptive_base.tiff \
	figures/ch4-Selected_model_adaptive_sample_size.tiff \
	figures/ch4-Selected_model_adaptive_auc.tiff \
	figures/ch4-discrimination_moderate_sample_size.pdf \
	figures/ch4-discrimination_moderate_auc.pdf \
	figures/ch4-calibration_moderate_sample_size.pdf \
	figures/ch4-calibration_moderate_auc.pdf \
	figures/ch4-rmse_interaction_positive.pdf \
	figures/ch4-rmse_interaction_negative.pdf \
	figures/ch4-rmse_interaction_combined.pdf \
	figures/ch4-rmse_moderate_base_sensitivity.pdf \
	figures/ch4-rmse_moderate_sample_size_sensitivity.pdf \
	figures/ch4-rmse_moderate_auc_sensitivity.pdf \
	figures/ch5-PositiveSlnb.pdf \
	figures/ch6-Figure1.pdf \
	figures/ch6-Figure2.pdf \
	figures/ch6-Figure3.pdf
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render

environment :
	R -e "renv::restore()"
