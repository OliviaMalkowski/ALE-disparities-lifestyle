install.packages("remotes")
remotes::install_github("christiandudel/dtms")
## Load packages ######################################################
library(dtms)
library(haven)
library(tidyverse)
intermediate <- read_dta("P:/projects/PEP/OMalkowski/Active life expectancy/intermediate2.dta")

## Look at data
head(intermediate)
## States
intermediate$state2 |> unique()
## Number of units
intermediate$STUDYID |> unique() |> length()
## Number of observations
dim(intermediate)

## Define dtms ########################################################

## Define model: Absorbing and transient states, time scale
simple<-dtms(transient=c("Nondisabled","Disabled"),
             absorbing="Dead",
             timescale=840:1319)

## Reshape ############################################################

## Reshape to transition format
estdata<-dtms_format(data=intermediate,
                     dtms=simple,
                     idvar="STUDYID",
                     timevar="newage",
                     statevar="state2")

## Look at reshaped data
head(estdata)
## Missing values?
estdata$to |> table(useNA="always")

## Cleaning ###########################################################

## Clean
estdata <- dtms_clean(data=estdata,
                      dtms=simple)
## Summary of data
summary(estdata)

## Sample splits ######################################################

estdata_m <- estdata %>% filter(sex_cons==0)
estdata_w <- estdata %>% filter(sex_cons==1)

## Fit men adjusted
fit_mab <- dtms_fit(data=estdata_m,
                    formula=to~from+eth_bi+time+I(time^2)+cc_cons+adi_cons
                    +alc_cons+sm_cons+pa_cons+ob_cons)

## Fit women adjusted
fit_wab <- dtms_fit(data=estdata_w,
                    formula=to~from+eth_bi+time+I(time^2)+cc_cons+adi_cons
                    +alc_cons+sm_cons+pa_cons+ob_cons)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_mb <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_mb
cc_gm_mb <- mean(estdata_m$cc_cons[estdata_m$intbloc==0], na.rm = TRUE)
cc_gm_mb
alc_mladb <- mean(estdata_m$alc_cons[estdata_m$adi_cons==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mladb 
alc_mhadb <- mean(estdata_m$alc_cons[estdata_m$adi_cons==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhadb
sm_mladb <- mean(estdata_m$sm_cons[estdata_m$adi_cons==0 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mladb
sm_mhadb <- mean(estdata_m$sm_cons[estdata_m$adi_cons==1 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mhadb
pa_mladb <- mean(estdata_m$pa_cons[estdata_m$adi_cons==0 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mladb
pa_mhadb <- mean(estdata_m$pa_cons[estdata_m$adi_cons==1 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mhadb
ob_mladb <- mean(estdata_m$ob_cons[estdata_m$adi_cons==0 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mladb
ob_mhadb <- mean(estdata_m$ob_cons[estdata_m$adi_cons==1 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mhadb

## Female
## Time-constant variables
eth_gm_fb <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_fb
cc_gm_fb <- mean(estdata_w$cc_cons[estdata_w$intbloc==0], na.rm = TRUE)
cc_gm_fb
alc_fladb <- mean(estdata_w$alc_cons[estdata_w$adi_cons==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fladb 
alc_fhadb <- mean(estdata_w$alc_cons[estdata_w$adi_cons==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhadb
sm_fladb <- mean(estdata_w$sm_cons[estdata_w$adi_cons==0 & estdata_w$intbloc==0], na.rm = TRUE)
sm_fladb 
sm_fhadb <- mean(estdata_w$sm_cons[estdata_w$adi_cons==1 & estdata_w$intbloc==0], na.rm = TRUE)
sm_fhadb
pa_fladb <- mean(estdata_w$pa_cons[estdata_w$adi_cons==0 & estdata_w$intbloc==0], na.rm = TRUE)
pa_fladb 
pa_fhadb <- mean(estdata_w$pa_cons[estdata_w$adi_cons==1 & estdata_w$intbloc==0], na.rm = TRUE)
pa_fhadb
ob_fladb <- mean(estdata_w$ob_cons[estdata_w$adi_cons==0 & estdata_w$intbloc==0], na.rm = TRUE)
ob_fladb 
ob_fhadb <- mean(estdata_w$ob_cons[estdata_w$adi_cons==1 & estdata_w$intbloc==0], na.rm = TRUE)
ob_fhadb

## Predict probabilities ##############################################

## Reference scenario lower SES male
prob_s0_lmadb <- dtms_transitions(dtms=simple,
                                  model=fit_mab,
                                  controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                                pa_cons=pa_mladb, ob_cons=ob_mladb),
                                  ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=0, alc_cons=0, sm_cons=sm_mladb, 
                                               pa_cons=pa_mladb, ob_cons=ob_mladb),
                                 ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=0, alc_cons=alc_mladb, sm_cons=0, 
                                               pa_cons=pa_mladb, ob_cons=ob_mladb),
                                 ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                               pa_cons=0, ob_cons=ob_mladb),
                                 ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                               pa_cons=pa_mladb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=0, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=1, alc_cons=0, sm_cons=sm_mhadb, 
                                               pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                 ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=1, alc_cons=alc_mhadb, sm_cons=0, 
                                               pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                 ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                               pa_cons=0, ob_cons=ob_mhadb),
                                 ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                               pa_cons=pa_mhadb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_madb <- dtms_transitions(dtms=simple,
                                 model=fit_mab,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               adi_cons=1, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hmadb <- dtms_transitions(dtms=simple,
                                      model=fit_mab,
                                      controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                    adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                                    pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                      ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfadb <- dtms_transitions(dtms=simple,
                                  model=fit_wab,
                                  controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                                pa_cons=pa_fladb, ob_cons=ob_fladb),
                                  ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=0, alc_cons=0, sm_cons=sm_fladb, 
                                               pa_cons=pa_fladb, ob_cons=ob_fladb),
                                 ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=0, alc_cons=alc_fladb, sm_cons=0, 
                                               pa_cons=pa_fladb, ob_cons=ob_fladb),
                                 ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                               pa_cons=0, ob_cons=ob_fladb),
                                 ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                               pa_cons=pa_fladb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=0, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=1, alc_cons=0, sm_cons=sm_fhadb, 
                                               pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                 ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=1, alc_cons=alc_fhadb, sm_cons=0, 
                                               pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                 ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                               pa_cons=0, ob_cons=ob_fhadb),
                                 ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                               pa_cons=pa_fhadb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_fadb <- dtms_transitions(dtms=simple,
                                 model=fit_wab,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               adi_cons=1, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfadb <- dtms_transitions(dtms=simple,
                                      model=fit_wab,
                                      controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                    adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                                    pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                      ci=TRUE)

## Starting distribution ##############################################

limited <- c("Nondisabled")

## Male
Sm <- dtms_start(dtms=simple,
                 data=estdata_m,
                 start_state=limited)
## Female
Sw <- dtms_start(dtms=simple,
                 data=estdata_w,
                 start_state=limited)

## Expectancies #######################################################

## Reference scenario lower SES male
s0_madb <- dtms_expectancy(probs=prob_s0_lmadb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_madb <- dtms_expectancy(probs=prob_a1_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_madb <- dtms_expectancy(probs=prob_a2_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_madb <- dtms_expectancy(probs=prob_a3_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_madb <- dtms_expectancy(probs=prob_a4_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_madb <- dtms_expectancy(probs=prob_aj_madb,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_madb <- dtms_expectancy(probs=prob_b1_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_madb <- dtms_expectancy(probs=prob_b2_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_madb <- dtms_expectancy(probs=prob_b3_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_madb <- dtms_expectancy(probs=prob_b4_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_madb <- dtms_expectancy(probs=prob_bj_madb,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_madb <- dtms_expectancy(probs=prob_sfinal_hmadb,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_fadb <- dtms_expectancy(probs=prob_s0_lfadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_fadb <- dtms_expectancy(probs=prob_a1_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_fadb <- dtms_expectancy(probs=prob_a2_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_fadb <- dtms_expectancy(probs=prob_a3_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_fadb <- dtms_expectancy(probs=prob_a4_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_fadb <- dtms_expectancy(probs=prob_aj_fadb,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_fadb <- dtms_expectancy(probs=prob_b1_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_fadb <- dtms_expectancy(probs=prob_b2_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_fadb <- dtms_expectancy(probs=prob_b3_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_fadb <- dtms_expectancy(probs=prob_b4_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_fadb <- dtms_expectancy(probs=prob_bj_fadb,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_fadb <- dtms_expectancy(probs=prob_sfinal_hfadb,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmadb <- a1_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
g_smk_lmadb <- a2_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
g_act_lmadb <- a3_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
g_obs_lmadb <- a4_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmadb <- aj_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmadb <- b1_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
g_smk_hmadb <- b2_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
g_act_hmadb <- b3_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
g_obs_hmadb <- b4_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmadb <- bj_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_madb <- sfinal_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_madb <- b1_madb["start:Nondisabled_840","Nondisabled"] - a1_madb["start:Nondisabled_840","Nondisabled"]
d_smk_madb <- b2_madb["start:Nondisabled_840","Nondisabled"] - a2_madb["start:Nondisabled_840","Nondisabled"]
d_act_madb <- b3_madb["start:Nondisabled_840","Nondisabled"] - a3_madb["start:Nondisabled_840","Nondisabled"]
d_obs_madb <- b4_madb["start:Nondisabled_840","Nondisabled"] - a4_madb["start:Nondisabled_840","Nondisabled"]
residual_madb <- bj_madb["start:Nondisabled_840","Nondisabled"] - aj_madb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmad_tb <- a1_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
g_smk_lmad_tb <- a2_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
g_act_lmad_tb <- a3_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
g_obs_lmad_tb <- a4_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmad_tb <- aj_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmad_tb <- b1_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
g_smk_hmad_tb <- b2_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
g_act_hmad_tb <- b3_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
g_obs_hmad_tb <- b4_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmad_tb <- bj_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_mad_tb <- sfinal_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_mad_tb <- b1_madb["start:Nondisabled_840","TOTAL"] - a1_madb["start:Nondisabled_840","TOTAL"]
d_smk_mad_tb <- b2_madb["start:Nondisabled_840","TOTAL"] - a2_madb["start:Nondisabled_840","TOTAL"]
d_act_mad_tb <- b3_madb["start:Nondisabled_840","TOTAL"] - a3_madb["start:Nondisabled_840","TOTAL"]
d_obs_mad_tb <- b4_madb["start:Nondisabled_840","TOTAL"] - a4_madb["start:Nondisabled_840","TOTAL"]
residual_mad_tb <- bj_madb["start:Nondisabled_840","TOTAL"] - aj_madb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_madb <- ((total_gap_madb - d_alc_madb)/total_gap_madb)*100
alc_cont_mad_tb <- ((total_gap_mad_tb - d_alc_mad_tb)/total_gap_mad_tb)*100
smk_cont_madb <- ((total_gap_madb - d_smk_madb)/total_gap_madb)*100
smk_cont_mad_tb <- ((total_gap_mad_tb - d_smk_mad_tb)/total_gap_mad_tb)*100
act_cont_madb <- ((total_gap_madb - d_act_madb)/total_gap_madb)*100
act_cont_mad_tb <- ((total_gap_mad_tb - d_act_mad_tb)/total_gap_mad_tb)*100
obs_cont_madb <- ((total_gap_madb - d_obs_madb)/total_gap_madb)*100
obs_cont_mad_tb <- ((total_gap_mad_tb - d_obs_mad_tb)/total_gap_mad_tb)*100
joint_cont_madb <- ((total_gap_madb - residual_madb)/total_gap_madb)*100
joint_cont_mad_tb <- ((total_gap_mad_tb - residual_mad_tb)/total_gap_mad_tb)*100

## Bootstrap function male
bootfun_mab <- function(data,dtms) {
  fit_mab <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+adi_cons
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_mb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_mb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_mladb <- mean(data$alc_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhadb <- mean(data$alc_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  sm_mladb <- mean(data$sm_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  sm_mhadb <- mean(data$sm_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  pa_mladb <- mean(data$pa_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  pa_mhadb <- mean(data$pa_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  ob_mladb <- mean(data$ob_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  ob_mhadb <- mean(data$ob_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lmadb <- dtms_transitions(dtms=dtms,
                                    model=fit_mab,
                                    controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                  adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                                  pa_cons=pa_mladb, ob_cons=ob_mladb),
                                    ci=TRUE)
  prob_a1_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=0, alc_cons=0, sm_cons=sm_mladb, 
                                                 pa_cons=pa_mladb, ob_cons=ob_mladb),
                                   ci=TRUE)
  prob_a2_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=0, alc_cons=alc_mladb, sm_cons=0, 
                                                 pa_cons=pa_mladb, ob_cons=ob_mladb),
                                   ci=TRUE)
  prob_a3_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                                 pa_cons=0, ob_cons=ob_mladb),
                                   ci=TRUE)
  prob_a4_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=0, alc_cons=alc_mladb, sm_cons=sm_mladb, 
                                                 pa_cons=pa_mladb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=1, alc_cons=0, sm_cons=sm_mhadb, 
                                                 pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                   ci=TRUE)
  prob_b2_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=1, alc_cons=alc_mhadb, sm_cons=0, 
                                                 pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                   ci=TRUE)
  prob_b3_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                                 pa_cons=0, ob_cons=ob_mhadb),
                                   ci=TRUE)
  prob_b4_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                                 pa_cons=pa_mhadb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_madb <- dtms_transitions(dtms=dtms,
                                   model=fit_mab,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 adi_cons=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hmadb <- dtms_transitions(dtms=dtms,
                                        model=fit_mab,
                                        controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                      adi_cons=1, alc_cons=alc_mhadb, sm_cons=sm_mhadb, 
                                                      pa_cons=pa_mhadb, ob_cons=ob_mhadb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_madb <- dtms_expectancy(probs=prob_s0_lmadb,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_madb <- dtms_expectancy(probs=prob_a1_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_madb <- dtms_expectancy(probs=prob_a2_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_madb <- dtms_expectancy(probs=prob_a3_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_madb <- dtms_expectancy(probs=prob_a4_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_madb <- dtms_expectancy(probs=prob_aj_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_madb <- dtms_expectancy(probs=prob_b1_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_madb <- dtms_expectancy(probs=prob_b2_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_madb <- dtms_expectancy(probs=prob_b3_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_madb <- dtms_expectancy(probs=prob_b4_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_madb <- dtms_expectancy(probs=prob_bj_madb,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_madb <- dtms_expectancy(probs=prob_sfinal_hmadb,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lmadb <- a1_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  g_smk_lmadb <- a2_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  g_act_lmadb <- a3_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  g_obs_lmadb <- a4_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  g_joint_lmadb <- aj_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  g_alc_hmadb <- b1_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
  g_smk_hmadb <- b2_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
  g_act_hmadb <- b3_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
  g_obs_hmadb <- b4_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
  g_joint_hmadb <- bj_madb["start:Nondisabled_840","Nondisabled"] - sfinal_madb["start:Nondisabled_840","Nondisabled"]
  total_gap_madb <- sfinal_madb["start:Nondisabled_840","Nondisabled"] - s0_madb["start:Nondisabled_840","Nondisabled"]
  d_alc_madb <- b1_madb["start:Nondisabled_840","Nondisabled"] - a1_madb["start:Nondisabled_840","Nondisabled"]
  d_smk_madb <- b2_madb["start:Nondisabled_840","Nondisabled"] - a2_madb["start:Nondisabled_840","Nondisabled"]
  d_act_madb <- b3_madb["start:Nondisabled_840","Nondisabled"] - a3_madb["start:Nondisabled_840","Nondisabled"]
  d_obs_madb <- b4_madb["start:Nondisabled_840","Nondisabled"] - a4_madb["start:Nondisabled_840","Nondisabled"]
  residual_madb <- bj_madb["start:Nondisabled_840","Nondisabled"] - aj_madb["start:Nondisabled_840","Nondisabled"]
  g_alc_lmad_tb <- a1_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  g_smk_lmad_tb <- a2_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  g_act_lmad_tb <- a3_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  g_obs_lmad_tb <- a4_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  g_joint_lmad_tb <- aj_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  g_alc_hmad_tb <- b1_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
  g_smk_hmad_tb <- b2_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
  g_act_hmad_tb <- b3_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
  g_obs_hmad_tb <- b4_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
  g_joint_hmad_tb <- bj_madb["start:Nondisabled_840","TOTAL"] - sfinal_madb["start:Nondisabled_840","TOTAL"]
  total_gap_mad_tb <- sfinal_madb["start:Nondisabled_840","TOTAL"] - s0_madb["start:Nondisabled_840","TOTAL"]
  d_alc_mad_tb <- b1_madb["start:Nondisabled_840","TOTAL"] - a1_madb["start:Nondisabled_840","TOTAL"]
  d_smk_mad_tb <- b2_madb["start:Nondisabled_840","TOTAL"] - a2_madb["start:Nondisabled_840","TOTAL"]
  d_act_mad_tb <- b3_madb["start:Nondisabled_840","TOTAL"] - a3_madb["start:Nondisabled_840","TOTAL"]
  d_obs_mad_tb <- b4_madb["start:Nondisabled_840","TOTAL"] - a4_madb["start:Nondisabled_840","TOTAL"]
  residual_mad_tb <- bj_madb["start:Nondisabled_840","TOTAL"] - aj_madb["start:Nondisabled_840","TOTAL"]
  alc_cont_madb <- ((total_gap_madb - d_alc_madb)/total_gap_madb)*100
  alc_cont_mad_tb <- ((total_gap_mad_tb - d_alc_mad_tb)/total_gap_mad_tb)*100
  smk_cont_madb <- ((total_gap_madb - d_smk_madb)/total_gap_madb)*100
  smk_cont_mad_tb <- ((total_gap_mad_tb - d_smk_mad_tb)/total_gap_mad_tb)*100
  act_cont_madb <- ((total_gap_madb - d_act_madb)/total_gap_madb)*100
  act_cont_mad_tb <- ((total_gap_mad_tb - d_act_mad_tb)/total_gap_mad_tb)*100
  obs_cont_madb <- ((total_gap_madb - d_obs_madb)/total_gap_madb)*100
  obs_cont_mad_tb <- ((total_gap_mad_tb - d_obs_mad_tb)/total_gap_mad_tb)*100
  joint_cont_madb <- ((total_gap_madb - residual_madb)/total_gap_madb)*100
  joint_cont_mad_tb <- ((total_gap_mad_tb - residual_mad_tb)/total_gap_mad_tb)*100
  rbind(s0_madb,a1_madb,a2_madb,a3_madb,a4_madb,aj_madb,b1_madb,b2_madb,b3_madb,b4_madb,bj_madb,sfinal_madb,
        g_alc_lmadb,g_smk_lmadb,g_act_lmadb,g_obs_lmadb,g_joint_lmadb,
        g_alc_hmadb,g_smk_hmadb,g_act_hmadb,g_obs_hmadb,g_joint_hmadb,
        total_gap_madb,d_alc_madb,d_smk_madb,d_act_madb,d_obs_madb,residual_madb,
        g_alc_lmad_tb,g_smk_lmad_tb,g_act_lmad_tb,g_obs_lmad_tb,g_joint_lmad_tb,
        g_alc_hmad_tb,g_smk_hmad_tb,g_act_hmad_tb,g_obs_hmad_tb,g_joint_hmad_tb,
        total_gap_mad_tb,d_alc_mad_tb,d_smk_mad_tb,d_act_mad_tb,d_obs_mad_tb,residual_mad_tb,
        alc_cont_madb,alc_cont_mad_tb,smk_cont_madb,smk_cont_mad_tb,act_cont_madb,act_cont_mad_tb,obs_cont_madb,obs_cont_mad_tb,joint_cont_madb,joint_cont_mad_tb)
}
## Bootstrap results male
bootresults_mab <- dtms_boot(data=estdata_m,
                             dtms=simple,
                             fun=bootfun_mab,
                             idvar="id",
                             rep=10000,
                             method="block",
                             parallel=TRUE,
                             cores=3)
summary(bootresults_mab)
save(bootresults_mab,file="Results-bootstrap-mabc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfadb <- a1_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
g_smk_lfadb <- a2_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
g_act_lfadb <- a3_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
g_obs_lfadb <- a4_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfadb <- aj_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfadb <- b1_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
g_smk_hfadb <- b2_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
g_act_hfadb <- b3_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
g_obs_hfadb <- b4_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfadb <- bj_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_fadb <- sfinal_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fadb <- b1_fadb["start:Nondisabled_840","Nondisabled"] - a1_fadb["start:Nondisabled_840","Nondisabled"]
d_smk_fadb <- b2_fadb["start:Nondisabled_840","Nondisabled"] - a2_fadb["start:Nondisabled_840","Nondisabled"]
d_act_fadb <- b3_fadb["start:Nondisabled_840","Nondisabled"] - a3_fadb["start:Nondisabled_840","Nondisabled"]
d_obs_fadb <- b4_fadb["start:Nondisabled_840","Nondisabled"] - a4_fadb["start:Nondisabled_840","Nondisabled"]
residual_fadb <- bj_fadb["start:Nondisabled_840","Nondisabled"] - aj_fadb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfad_tb <- a1_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
g_smk_lfad_tb <- a2_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
g_act_lfad_tb <- a3_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
g_obs_lfad_tb <- a4_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfad_tb <- aj_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfad_tb <- b1_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
g_smk_hfad_tb <- b2_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
g_act_hfad_tb <- b3_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
g_obs_hfad_tb <- b4_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfad_tb <- bj_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_fad_tb <- sfinal_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fad_tb <- b1_fadb["start:Nondisabled_840","TOTAL"] - a1_fadb["start:Nondisabled_840","TOTAL"]
d_smk_fad_tb <- b2_fadb["start:Nondisabled_840","TOTAL"] - a2_fadb["start:Nondisabled_840","TOTAL"]
d_act_fad_tb <- b3_fadb["start:Nondisabled_840","TOTAL"] - a3_fadb["start:Nondisabled_840","TOTAL"]
d_obs_fad_tb <- b4_fadb["start:Nondisabled_840","TOTAL"] - a4_fadb["start:Nondisabled_840","TOTAL"]
residual_fad_tb <- bj_fadb["start:Nondisabled_840","TOTAL"] - aj_fadb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_fadb <- ((total_gap_fadb - d_alc_fadb)/total_gap_fadb)*100
alc_cont_fad_tb <- ((total_gap_fad_tb - d_alc_fad_tb)/total_gap_fad_tb)*100
smk_cont_fadb <- ((total_gap_fadb - d_smk_fadb)/total_gap_fadb)*100
smk_cont_fad_tb <- ((total_gap_fad_tb - d_smk_fad_tb)/total_gap_fad_tb)*100
act_cont_fadb <- ((total_gap_fadb - d_act_fadb)/total_gap_fadb)*100
act_cont_fad_tb <- ((total_gap_fad_tb - d_act_fad_tb)/total_gap_fad_tb)*100
obs_cont_fadb <- ((total_gap_fadb - d_obs_fadb)/total_gap_fadb)*100
obs_cont_fad_tb <- ((total_gap_fad_tb - d_obs_fad_tb)/total_gap_fad_tb)*100
joint_cont_fadb <- ((total_gap_fadb - residual_fadb)/total_gap_fadb)*100
joint_cont_fad_tb <- ((total_gap_fad_tb - residual_fad_tb)/total_gap_fad_tb)*100

## Bootstrap function female
bootfun_fab <- function(data,dtms) {
  fit_wab <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+adi_cons
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_fb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_fb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_fladb <- mean(data$alc_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhadb <- mean(data$alc_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  sm_fladb <- mean(data$sm_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  sm_fhadb <- mean(data$sm_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  pa_fladb <- mean(data$pa_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  pa_fhadb <- mean(data$pa_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  ob_fladb <- mean(data$ob_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  ob_fhadb <- mean(data$ob_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lfadb <- dtms_transitions(dtms=dtms,
                                    model=fit_wab,
                                    controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                  adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                                  pa_cons=pa_fladb, ob_cons=ob_fladb),
                                    ci=TRUE)
  prob_a1_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=0, alc_cons=0, sm_cons=sm_fladb, 
                                                 pa_cons=pa_fladb, ob_cons=ob_fladb),
                                   ci=TRUE)
  prob_a2_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=0, alc_cons=alc_fladb, sm_cons=0, 
                                                 pa_cons=pa_fladb, ob_cons=ob_fladb),
                                   ci=TRUE)
  prob_a3_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                                 pa_cons=0, ob_cons=ob_fladb),
                                   ci=TRUE)
  prob_a4_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=0, alc_cons=alc_fladb, sm_cons=sm_fladb, 
                                                 pa_cons=pa_fladb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=1, alc_cons=0, sm_cons=sm_fhadb, 
                                                 pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                   ci=TRUE)
  prob_b2_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=1, alc_cons=alc_fhadb, sm_cons=0, 
                                                 pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                   ci=TRUE)
  prob_b3_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                                 pa_cons=0, ob_cons=ob_fhadb),
                                   ci=TRUE)
  prob_b4_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                                 pa_cons=pa_fhadb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_fadb <- dtms_transitions(dtms=dtms,
                                   model=fit_wab,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 adi_cons=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hfadb <- dtms_transitions(dtms=dtms,
                                        model=fit_wab,
                                        controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                      adi_cons=1, alc_cons=alc_fhadb, sm_cons=sm_fhadb, 
                                                      pa_cons=pa_fhadb, ob_cons=ob_fhadb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_fadb <- dtms_expectancy(probs=prob_s0_lfadb,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_fadb <- dtms_expectancy(probs=prob_a1_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_fadb <- dtms_expectancy(probs=prob_a2_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_fadb <- dtms_expectancy(probs=prob_a3_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_fadb <- dtms_expectancy(probs=prob_a4_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_fadb <- dtms_expectancy(probs=prob_aj_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_fadb <- dtms_expectancy(probs=prob_b1_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_fadb <- dtms_expectancy(probs=prob_b2_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_fadb <- dtms_expectancy(probs=prob_b3_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_fadb <- dtms_expectancy(probs=prob_b4_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_fadb <- dtms_expectancy(probs=prob_bj_fadb,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_fadb <- dtms_expectancy(probs=prob_sfinal_hfadb,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfadb <- a1_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  g_smk_lfadb <- a2_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  g_act_lfadb <- a3_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  g_obs_lfadb <- a4_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  g_joint_lfadb <- aj_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  g_alc_hfadb <- b1_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
  g_smk_hfadb <- b2_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
  g_act_hfadb <- b3_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
  g_obs_hfadb <- b4_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
  g_joint_hfadb <- bj_fadb["start:Nondisabled_840","Nondisabled"] - sfinal_fadb["start:Nondisabled_840","Nondisabled"]
  total_gap_fadb <- sfinal_fadb["start:Nondisabled_840","Nondisabled"] - s0_fadb["start:Nondisabled_840","Nondisabled"]
  d_alc_fadb <- b1_fadb["start:Nondisabled_840","Nondisabled"] - a1_fadb["start:Nondisabled_840","Nondisabled"]
  d_smk_fadb <- b2_fadb["start:Nondisabled_840","Nondisabled"] - a2_fadb["start:Nondisabled_840","Nondisabled"]
  d_act_fadb <- b3_fadb["start:Nondisabled_840","Nondisabled"] - a3_fadb["start:Nondisabled_840","Nondisabled"]
  d_obs_fadb <- b4_fadb["start:Nondisabled_840","Nondisabled"] - a4_fadb["start:Nondisabled_840","Nondisabled"]
  residual_fadb <- bj_fadb["start:Nondisabled_840","Nondisabled"] - aj_fadb["start:Nondisabled_840","Nondisabled"]
  g_alc_lfad_tb <- a1_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  g_smk_lfad_tb <- a2_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  g_act_lfad_tb <- a3_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  g_obs_lfad_tb <- a4_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  g_joint_lfad_tb <- aj_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  g_alc_hfad_tb <- b1_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
  g_smk_hfad_tb <- b2_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
  g_act_hfad_tb <- b3_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
  g_obs_hfad_tb <- b4_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
  g_joint_hfad_tb <- bj_fadb["start:Nondisabled_840","TOTAL"] - sfinal_fadb["start:Nondisabled_840","TOTAL"]
  total_gap_fad_tb <- sfinal_fadb["start:Nondisabled_840","TOTAL"] - s0_fadb["start:Nondisabled_840","TOTAL"]
  d_alc_fad_tb <- b1_fadb["start:Nondisabled_840","TOTAL"] - a1_fadb["start:Nondisabled_840","TOTAL"]
  d_smk_fad_tb <- b2_fadb["start:Nondisabled_840","TOTAL"] - a2_fadb["start:Nondisabled_840","TOTAL"]
  d_act_fad_tb <- b3_fadb["start:Nondisabled_840","TOTAL"] - a3_fadb["start:Nondisabled_840","TOTAL"]
  d_obs_fad_tb <- b4_fadb["start:Nondisabled_840","TOTAL"] - a4_fadb["start:Nondisabled_840","TOTAL"]
  residual_fad_tb <- bj_fadb["start:Nondisabled_840","TOTAL"] - aj_fadb["start:Nondisabled_840","TOTAL"]
  alc_cont_fadb <- ((total_gap_fadb - d_alc_fadb)/total_gap_fadb)*100
  alc_cont_fad_tb <- ((total_gap_fad_tb - d_alc_fad_tb)/total_gap_fad_tb)*100
  smk_cont_fadb <- ((total_gap_fadb - d_smk_fadb)/total_gap_fadb)*100
  smk_cont_fad_tb <- ((total_gap_fad_tb - d_smk_fad_tb)/total_gap_fad_tb)*100
  act_cont_fadb <- ((total_gap_fadb - d_act_fadb)/total_gap_fadb)*100
  act_cont_fad_tb <- ((total_gap_fad_tb - d_act_fad_tb)/total_gap_fad_tb)*100
  obs_cont_fadb <- ((total_gap_fadb - d_obs_fadb)/total_gap_fadb)*100
  obs_cont_fad_tb <- ((total_gap_fad_tb - d_obs_fad_tb)/total_gap_fad_tb)*100
  joint_cont_fadb <- ((total_gap_fadb - residual_fadb)/total_gap_fadb)*100
  joint_cont_fad_tb <- ((total_gap_fad_tb - residual_fad_tb)/total_gap_fad_tb)*100
  rbind(s0_fadb,a1_fadb,a2_fadb,a3_fadb,a4_fadb,aj_fadb,b1_fadb,b2_fadb,b3_fadb,b4_fadb,bj_fadb,sfinal_fadb,
        g_alc_lfadb,g_smk_lfadb,g_act_lfadb,g_obs_lfadb,g_joint_lfadb,
        g_alc_hfadb,g_smk_hfadb,g_act_hfadb,g_obs_hfadb,g_joint_hfadb,
        total_gap_fadb,d_alc_fadb,d_smk_fadb,d_act_fadb,d_obs_fadb,residual_fadb,
        g_alc_lfad_tb,g_smk_lfad_tb,g_act_lfad_tb,g_obs_lfad_tb,g_joint_lfad_tb,
        g_alc_hfad_tb,g_smk_hfad_tb,g_act_hfad_tb,g_obs_hfad_tb,g_joint_hfad_tb,
        total_gap_fad_tb,d_alc_fad_tb,d_smk_fad_tb,d_act_fad_tb,d_obs_fad_tb,residual_fad_tb,
        alc_cont_fadb,alc_cont_fad_tb,smk_cont_fadb,smk_cont_fad_tb,act_cont_fadb,act_cont_fad_tb,obs_cont_fadb,obs_cont_fad_tb,joint_cont_fadb,joint_cont_fad_tb)
}
## Bootstrap results female
bootresults_fab <- dtms_boot(data=estdata_w,
                             dtms=simple,
                             fun=bootfun_fab,
                             idvar="id",
                             rep=10000,
                             method="block",
                             parallel=TRUE,
                             cores=3)
summary(bootresults_fab)
save(bootresults_fab,file="Results-bootstrap-fabc-10000.Rda")

## Print estimates
s0_madb
a1_madb
a2_madb
a3_madb
a4_madb
aj_madb
b1_madb
b2_madb
b3_madb
b4_madb
bj_madb
sfinal_madb
g_alc_lmadb
g_smk_lmadb
g_act_lmadb
g_obs_lmadb
g_joint_lmadb
g_alc_hmadb
g_smk_hmadb
g_act_hmadb
g_obs_hmadb
g_joint_hmadb
total_gap_madb
d_alc_madb
d_smk_madb
d_act_madb
d_obs_madb
residual_madb
g_alc_lmad_tb
g_smk_lmad_tb
g_act_lmad_tb
g_obs_lmad_tb
g_joint_lmad_tb
g_alc_hmad_tb
g_smk_hmad_tb
g_act_hmad_tb
g_obs_hmad_tb
g_joint_hmad_tb
total_gap_mad_tb
d_alc_mad_tb
d_smk_mad_tb
d_act_mad_tb
d_obs_mad_tb
residual_mad_tb
alc_cont_madb
alc_cont_mad_tb
smk_cont_madb
smk_cont_mad_tb
act_cont_madb
act_cont_mad_tb
obs_cont_madb
obs_cont_mad_tb
joint_cont_madb
joint_cont_mad_tb

s0_fadb
a1_fadb
a2_fadb
a3_fadb
a4_fadb
aj_fadb
b1_fadb
b2_fadb
b3_fadb
b4_fadb
bj_fadb
sfinal_fadb
g_alc_lfadb
g_smk_lfadb
g_act_lfadb
g_obs_lfadb
g_joint_lfadb
g_alc_hfadb
g_smk_hfadb
g_act_hfadb
g_obs_hfadb
g_joint_hfadb
total_gap_fadb
d_alc_fadb
d_smk_fadb
d_act_fadb
d_obs_fadb
residual_fadb
g_alc_lfad_tb
g_smk_lfad_tb
g_act_lfad_tb
g_obs_lfad_tb
g_joint_lfad_tb
g_alc_hfad_tb
g_smk_hfad_tb
g_act_hfad_tb
g_obs_hfad_tb
g_joint_hfad_tb
total_gap_fad_tb
d_alc_fad_tb
d_smk_fad_tb
d_act_fad_tb
d_obs_fad_tb
residual_fad_tb
alc_cont_fadb
alc_cont_fad_tb
smk_cont_fadb
smk_cont_fad_tb
act_cont_fadb
act_cont_fad_tb
obs_cont_fadb
obs_cont_fad_tb
joint_cont_fadb
joint_cont_fad_tb
