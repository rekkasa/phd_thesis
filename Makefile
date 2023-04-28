# ===================================================================================================================
# Fetch data
# ===================================================================================================================
data/introduction/gusto.rda : code/ch1-GetGustoData.sh
	$<

figures/hypertensionGuidelines.png :
	wget -O figures/hypertensionGuidelines.png \
		https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/figures/hypertensionGuidelines.png

figures/%.pdf :
	wget -O $@ https://github.com/rekkasa/phd_thesis/raw/large-files/$@

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

data/framework/negativeControls_ccae.rds : code/GetRawData.R
	$< negativeControls_ccae.rds framework

data/framework/negativeControls_mdcd.rds : code/GetRawData.R
	$< negativeControls_mdcd.rds framework

data/framework/negativeControls_mdcr.rds : code/GetRawData.R
	$< negativeControls_mdcr.rds framework

data/simulation/%.csv :
	wget -O $@ https://raw.githubusercontent.com/rekkasa/phd_thesis/large-files/$@

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

data/simulation/scenario_433/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_433
data/simulation/scenario_434/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_434
data/simulation/scenario_435/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_435
data/simulation/scenario_505/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_505
data/simulation/scenario_506/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_506
data/simulation/scenario_507/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_507
data/simulation/scenario_577/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_577
data/simulation/scenario_578/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_578
data/simulation/scenario_579/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_579
data/simulation/scenario_613/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_613
data/simulation/scenario_614/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_614
data/simulation/scenario_615/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_615

data/simulation/scenario_441/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_441
data/simulation/scenario_442/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_442
data/simulation/scenario_443/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_443
data/simulation/scenario_513/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_513
data/simulation/scenario_514/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_514
data/simulation/scenario_515/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_515
data/simulation/scenario_585/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_585
data/simulation/scenario_586/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_586
data/simulation/scenario_587/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_587
data/simulation/scenario_621/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_621
data/simulation/scenario_622/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_622
data/simulation/scenario_623/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_623

data/simulation/scenario_457/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_457
data/simulation/scenario_458/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_458
data/simulation/scenario_459/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_459
data/simulation/scenario_529/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_529
data/simulation/scenario_530/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_530
data/simulation/scenario_531/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_531
data/simulation/scenario_601/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_601
data/simulation/scenario_602/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_602
data/simulation/scenario_603/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_603
data/simulation/scenario_637/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_637
data/simulation/scenario_638/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_638
data/simulation/scenario_639/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_639

data/simulation/scenario_649/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_649
data/simulation/scenario_650/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_650
data/simulation/scenario_651/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_651
data/simulation/scenario_652/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_652
data/simulation/scenario_653/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_653
data/simulation/scenario_654/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_654
data/simulation/scenario_655/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_655
data/simulation/scenario_656/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_656
data/simulation/scenario_657/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_657
data/simulation/scenario_658/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_658
data/simulation/scenario_659/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_659
data/simulation/scenario_660/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_660

data/simulation/scenario_661/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_661
data/simulation/scenario_662/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_662
data/simulation/scenario_663/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_663
data/simulation/scenario_664/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_664
data/simulation/scenario_665/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_665
data/simulation/scenario_666/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_666
data/simulation/scenario_667/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_667
data/simulation/scenario_668/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_668
data/simulation/scenario_669/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_669
data/simulation/scenario_670/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_670
data/simulation/scenario_671/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_671
data/simulation/scenario_672/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_672

data/simulation/scenario_673/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_673
data/simulation/scenario_674/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_674
data/simulation/scenario_675/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_675
data/simulation/scenario_676/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_676

data/simulation/scenario_677/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_677
data/simulation/scenario_678/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_678
data/simulation/scenario_679/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_679
data/simulation/scenario_681/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_681
data/simulation/scenario_682/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_682
data/simulation/scenario_683/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_683
data/simulation/scenario_685/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_685
data/simulation/scenario_686/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_686
data/simulation/scenario_687/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_687
data/simulation/scenario_689/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_689
data/simulation/scenario_690/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_690
data/simulation/scenario_691/settings.rds : code/GetRawData.R
	$< settings.rds simulation scenario_691

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
	$< moderate 4250 0.75 base FALSE

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
	$< moderate 17000 0.75 sample_size FALSE

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
	$< moderate 4250 0.85 auc FALSE

figures/ch4-rmse_high_base.tiff : code/ch4-PlotRmse.R\
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

figures/ch4-rmse_high_sample_size.tiff : code/ch4-PlotRmse.R\
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

figures/ch4-rmse_high_auc.tiff : code/ch4-PlotRmse.R\
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

figures/ch4-rmse_moderate_base_sensitivity.tiff : code/ch4-PlotRmse.R\
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
	ch3_appendix.qmd \
	ch4_appendix.qmd \
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
	figures/ch4-rmse_moderate_base.tiff \
	figures/ch4-rmse_moderate_sample_size.tiff \
	figures/ch4-rmse_moderate_auc.tiff \
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
	figures/ch5-PositiveSlnb.pdf
	bash -c "quarto render";


.PHONY:
thesis :
	quarto render

environment :
	R -e "renv::restore()"
