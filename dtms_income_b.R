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
fit_mib <- dtms_fit(data=estdata_m,
                    formula=to~from+eth_bi+time+I(time^2)+cc_cons+inc_bimi
                    +alc_cons+sm_cons+pa_cons+ob_cons)

## Fit women adjusted
fit_wib <- dtms_fit(data=estdata_w,
                    formula=to~from+eth_bi+time+I(time^2)+cc_cons+inc_bimi
                    +alc_cons+sm_cons+pa_cons+ob_cons)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_mb <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_mb
cc_gm_mb <- mean(estdata_m$cc_cons[estdata_m$intbloc==0], na.rm = TRUE)
cc_gm_mb
alc_mlinb <- mean(estdata_m$alc_cons[estdata_m$inc_bimi==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mlinb 
alc_mhinb <- mean(estdata_m$alc_cons[estdata_m$inc_bimi==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhinb
sm_mlinb <- mean(estdata_m$sm_cons[estdata_m$inc_bimi==0 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mlinb
sm_mhinb <- mean(estdata_m$sm_cons[estdata_m$inc_bimi==1 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mhinb
pa_mlinb <- mean(estdata_m$pa_cons[estdata_m$inc_bimi==0 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mlinb
pa_mhinb <- mean(estdata_m$pa_cons[estdata_m$inc_bimi==1 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mhinb
ob_mlinb <- mean(estdata_m$ob_cons[estdata_m$inc_bimi==0 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mlinb
ob_mhinb <- mean(estdata_m$ob_cons[estdata_m$inc_bimi==1 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mhinb

## Female
## Time-constant variables
eth_gm_fb <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_fb
cc_gm_fb <- mean(estdata_w$cc_cons[estdata_w$intbloc==0], na.rm = TRUE)
cc_gm_fb
alc_flinb <- mean(estdata_w$alc_cons[estdata_w$inc_bimi==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_flinb 
alc_fhinb <- mean(estdata_w$alc_cons[estdata_w$inc_bimi==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhinb
sm_flinb <- mean(estdata_w$sm_cons[estdata_w$inc_bimi==0 & estdata_w$intbloc==0], na.rm = TRUE)
sm_flinb 
sm_fhinb <- mean(estdata_w$sm_cons[estdata_w$inc_bimi==1 & estdata_w$intbloc==0], na.rm = TRUE)
sm_fhinb
pa_flinb <- mean(estdata_w$pa_cons[estdata_w$inc_bimi==0 & estdata_w$intbloc==0], na.rm = TRUE)
pa_flinb 
pa_fhinb <- mean(estdata_w$pa_cons[estdata_w$inc_bimi==1 & estdata_w$intbloc==0], na.rm = TRUE)
pa_fhinb
ob_flinb <- mean(estdata_w$ob_cons[estdata_w$inc_bimi==0 & estdata_w$intbloc==0], na.rm = TRUE)
ob_flinb 
ob_fhinb <- mean(estdata_w$ob_cons[estdata_w$inc_bimi==1 & estdata_w$intbloc==0], na.rm = TRUE)
ob_fhinb

## Predict probabilities ##############################################

## Reference scenario lower SES male
prob_s0_lminb <- dtms_transitions(dtms=simple,
                                  model=fit_mib,
                                  controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                                pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                  ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=0, alc_cons=0, sm_cons=sm_mlinb, 
                                               pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                 ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=0, alc_cons=alc_mlinb, sm_cons=0, 
                                               pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                 ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                               pa_cons=0, ob_cons=ob_mlinb),
                                 ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                               pa_cons=pa_mlinb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=0, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=1, alc_cons=0, sm_cons=sm_mhinb, 
                                               pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                 ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=1, alc_cons=alc_mhinb, sm_cons=0, 
                                               pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                 ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                               pa_cons=0, ob_cons=ob_mhinb),
                                 ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                               pa_cons=pa_mhinb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_minb <- dtms_transitions(dtms=simple,
                                 model=fit_mib,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               inc_bimi=1, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hminb <- dtms_transitions(dtms=simple,
                                      model=fit_mib,
                                      controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                    inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                                    pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                      ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfinb <- dtms_transitions(dtms=simple,
                                  model=fit_wib,
                                  controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                                pa_cons=pa_flinb, ob_cons=ob_flinb),
                                  ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=0, alc_cons=0, sm_cons=sm_flinb, 
                                               pa_cons=pa_flinb, ob_cons=ob_flinb),
                                 ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=0, alc_cons=alc_flinb, sm_cons=0, 
                                               pa_cons=pa_flinb, ob_cons=ob_flinb),
                                 ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                               pa_cons=0, ob_cons=ob_flinb),
                                 ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                               pa_cons=pa_flinb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=0, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=1, alc_cons=0, sm_cons=sm_fhinb, 
                                               pa_cons=pa_fhinb, ob_cons=ob_fhinb),
                                 ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=1, alc_cons=alc_fhinb, sm_cons=0, 
                                               pa_cons=pa_fhinb, ob_cons=ob_fhinb),
                                 ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                               pa_cons=0, ob_cons=ob_fhinb),
                                 ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                               pa_cons=pa_fhinb, ob_cons=0),
                                 ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_finb <- dtms_transitions(dtms=simple,
                                 model=fit_wib,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               inc_bimi=1, alc_cons=0, sm_cons=0, 
                                               pa_cons=0, ob_cons=0),
                                 ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfinb <- dtms_transitions(dtms=simple,
                                      model=fit_wib,
                                      controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                    inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                                    pa_cons=pa_fhinb, ob_cons=ob_fhinb),
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
s0_minb <- dtms_expectancy(probs=prob_s0_lminb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_minb <- dtms_expectancy(probs=prob_a1_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_minb <- dtms_expectancy(probs=prob_a2_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_minb <- dtms_expectancy(probs=prob_a3_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_minb <- dtms_expectancy(probs=prob_a4_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_minb <- dtms_expectancy(probs=prob_aj_minb,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_minb <- dtms_expectancy(probs=prob_b1_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_minb <- dtms_expectancy(probs=prob_b2_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_minb <- dtms_expectancy(probs=prob_b3_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_minb <- dtms_expectancy(probs=prob_b4_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_minb <- dtms_expectancy(probs=prob_bj_minb,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_minb <- dtms_expectancy(probs=prob_sfinal_hminb,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_finb <- dtms_expectancy(probs=prob_s0_lfinb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_finb <- dtms_expectancy(probs=prob_a1_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_finb <- dtms_expectancy(probs=prob_a2_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_finb <- dtms_expectancy(probs=prob_a3_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_finb <- dtms_expectancy(probs=prob_a4_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_finb <- dtms_expectancy(probs=prob_aj_finb,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_finb <- dtms_expectancy(probs=prob_b1_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_finb <- dtms_expectancy(probs=prob_b2_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_finb <- dtms_expectancy(probs=prob_b3_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_finb <- dtms_expectancy(probs=prob_b4_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_finb <- dtms_expectancy(probs=prob_bj_finb,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_finb <- dtms_expectancy(probs=prob_sfinal_hfinb,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lminb <- a1_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
g_smk_lminb <- a2_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
g_act_lminb <- a3_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
g_obs_lminb <- a4_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lminb <- aj_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hminb <- b1_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
g_smk_hminb <- b2_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
g_act_hminb <- b3_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
g_obs_hminb <- b4_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hminb <- bj_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_minb <- sfinal_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_minb <- b1_minb["start:Nondisabled_840","Nondisabled"] - a1_minb["start:Nondisabled_840","Nondisabled"]
d_smk_minb <- b2_minb["start:Nondisabled_840","Nondisabled"] - a2_minb["start:Nondisabled_840","Nondisabled"]
d_act_minb <- b3_minb["start:Nondisabled_840","Nondisabled"] - a3_minb["start:Nondisabled_840","Nondisabled"]
d_obs_minb <- b4_minb["start:Nondisabled_840","Nondisabled"] - a4_minb["start:Nondisabled_840","Nondisabled"]
residual_minb <- bj_minb["start:Nondisabled_840","Nondisabled"] - aj_minb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmin_tb <- a1_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
g_smk_lmin_tb <- a2_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
g_act_lmin_tb <- a3_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
g_obs_lmin_tb <- a4_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmin_tb <- aj_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmin_tb <- b1_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
g_smk_hmin_tb <- b2_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
g_act_hmin_tb <- b3_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
g_obs_hmin_tb <- b4_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmin_tb <- bj_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_min_tb <- sfinal_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_min_tb <- b1_minb["start:Nondisabled_840","TOTAL"] - a1_minb["start:Nondisabled_840","TOTAL"]
d_smk_min_tb <- b2_minb["start:Nondisabled_840","TOTAL"] - a2_minb["start:Nondisabled_840","TOTAL"]
d_act_min_tb <- b3_minb["start:Nondisabled_840","TOTAL"] - a3_minb["start:Nondisabled_840","TOTAL"]
d_obs_min_tb <- b4_minb["start:Nondisabled_840","TOTAL"] - a4_minb["start:Nondisabled_840","TOTAL"]
residual_min_tb <- bj_minb["start:Nondisabled_840","TOTAL"] - aj_minb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_minb <- ((total_gap_minb - d_alc_minb)/total_gap_minb)*100
alc_cont_min_tb <- ((total_gap_min_tb - d_alc_min_tb)/total_gap_min_tb)*100
smk_cont_minb <- ((total_gap_minb - d_smk_minb)/total_gap_minb)*100
smk_cont_min_tb <- ((total_gap_min_tb - d_smk_min_tb)/total_gap_min_tb)*100
act_cont_minb <- ((total_gap_minb - d_act_minb)/total_gap_minb)*100
act_cont_min_tb <- ((total_gap_min_tb - d_act_min_tb)/total_gap_min_tb)*100
obs_cont_minb <- ((total_gap_minb - d_obs_minb)/total_gap_minb)*100
obs_cont_min_tb <- ((total_gap_min_tb - d_obs_min_tb)/total_gap_min_tb)*100
joint_cont_minb <- ((total_gap_minb - residual_minb)/total_gap_minb)*100
joint_cont_min_tb <- ((total_gap_min_tb - residual_min_tb)/total_gap_min_tb)*100

## Bootstrap function male
bootfun_mib <- function(data,dtms) {
  fit_mib <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+inc_bimi
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_mb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_mb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_mlinb <- mean(data$alc_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhinb <- mean(data$alc_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  sm_mlinb <- mean(data$sm_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  sm_mhinb <- mean(data$sm_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  pa_mlinb <- mean(data$pa_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  pa_mhinb <- mean(data$pa_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  ob_mlinb <- mean(data$ob_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  ob_mhinb <- mean(data$ob_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lminb <- dtms_transitions(dtms=dtms,
                                    model=fit_mib,
                                    controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                  inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                                  pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                    ci=TRUE)
  prob_a1_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=0, alc_cons=0, sm_cons=sm_mlinb, 
                                                 pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                   ci=TRUE)
  prob_a2_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=0, alc_cons=alc_mlinb, sm_cons=0, 
                                                 pa_cons=pa_mlinb, ob_cons=ob_mlinb),
                                   ci=TRUE)
  prob_a3_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                                 pa_cons=0, ob_cons=ob_mlinb),
                                   ci=TRUE)
  prob_a4_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=0, alc_cons=alc_mlinb, sm_cons=sm_mlinb, 
                                                 pa_cons=pa_mlinb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=1, alc_cons=0, sm_cons=sm_mhinb, 
                                                 pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                   ci=TRUE)
  prob_b2_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=1, alc_cons=alc_mhinb, sm_cons=0, 
                                                 pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                   ci=TRUE)
  prob_b3_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                                 pa_cons=0, ob_cons=ob_mhinb),
                                   ci=TRUE)
  prob_b4_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                                 pa_cons=pa_mhinb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_minb <- dtms_transitions(dtms=dtms,
                                   model=fit_mib,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 inc_bimi=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hminb <- dtms_transitions(dtms=dtms,
                                        model=fit_mib,
                                        controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                      inc_bimi=1, alc_cons=alc_mhinb, sm_cons=sm_mhinb, 
                                                      pa_cons=pa_mhinb, ob_cons=ob_mhinb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_minb <- dtms_expectancy(probs=prob_s0_lminb,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_minb <- dtms_expectancy(probs=prob_a1_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_minb <- dtms_expectancy(probs=prob_a2_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_minb <- dtms_expectancy(probs=prob_a3_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_minb <- dtms_expectancy(probs=prob_a4_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_minb <- dtms_expectancy(probs=prob_aj_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_minb <- dtms_expectancy(probs=prob_b1_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_minb <- dtms_expectancy(probs=prob_b2_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_minb <- dtms_expectancy(probs=prob_b3_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_minb <- dtms_expectancy(probs=prob_b4_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_minb <- dtms_expectancy(probs=prob_bj_minb,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_minb <- dtms_expectancy(probs=prob_sfinal_hminb,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lminb <- a1_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  g_smk_lminb <- a2_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  g_act_lminb <- a3_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  g_obs_lminb <- a4_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  g_joint_lminb <- aj_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  g_alc_hminb <- b1_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
  g_smk_hminb <- b2_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
  g_act_hminb <- b3_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
  g_obs_hminb <- b4_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
  g_joint_hminb <- bj_minb["start:Nondisabled_840","Nondisabled"] - sfinal_minb["start:Nondisabled_840","Nondisabled"]
  total_gap_minb <- sfinal_minb["start:Nondisabled_840","Nondisabled"] - s0_minb["start:Nondisabled_840","Nondisabled"]
  d_alc_minb <- b1_minb["start:Nondisabled_840","Nondisabled"] - a1_minb["start:Nondisabled_840","Nondisabled"]
  d_smk_minb <- b2_minb["start:Nondisabled_840","Nondisabled"] - a2_minb["start:Nondisabled_840","Nondisabled"]
  d_act_minb <- b3_minb["start:Nondisabled_840","Nondisabled"] - a3_minb["start:Nondisabled_840","Nondisabled"]
  d_obs_minb <- b4_minb["start:Nondisabled_840","Nondisabled"] - a4_minb["start:Nondisabled_840","Nondisabled"]
  residual_minb <- bj_minb["start:Nondisabled_840","Nondisabled"] - aj_minb["start:Nondisabled_840","Nondisabled"]
  g_alc_lmin_tb <- a1_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  g_smk_lmin_tb <- a2_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  g_act_lmin_tb <- a3_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  g_obs_lmin_tb <- a4_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  g_joint_lmin_tb <- aj_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  g_alc_hmin_tb <- b1_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
  g_smk_hmin_tb <- b2_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
  g_act_hmin_tb <- b3_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
  g_obs_hmin_tb <- b4_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
  g_joint_hmin_tb <- bj_minb["start:Nondisabled_840","TOTAL"] - sfinal_minb["start:Nondisabled_840","TOTAL"]
  total_gap_min_tb <- sfinal_minb["start:Nondisabled_840","TOTAL"] - s0_minb["start:Nondisabled_840","TOTAL"]
  d_alc_min_tb <- b1_minb["start:Nondisabled_840","TOTAL"] - a1_minb["start:Nondisabled_840","TOTAL"]
  d_smk_min_tb <- b2_minb["start:Nondisabled_840","TOTAL"] - a2_minb["start:Nondisabled_840","TOTAL"]
  d_act_min_tb <- b3_minb["start:Nondisabled_840","TOTAL"] - a3_minb["start:Nondisabled_840","TOTAL"]
  d_obs_min_tb <- b4_minb["start:Nondisabled_840","TOTAL"] - a4_minb["start:Nondisabled_840","TOTAL"]
  residual_min_tb <- bj_minb["start:Nondisabled_840","TOTAL"] - aj_minb["start:Nondisabled_840","TOTAL"]
  alc_cont_minb <- ((total_gap_minb - d_alc_minb)/total_gap_minb)*100
  alc_cont_min_tb <- ((total_gap_min_tb - d_alc_min_tb)/total_gap_min_tb)*100
  smk_cont_minb <- ((total_gap_minb - d_smk_minb)/total_gap_minb)*100
  smk_cont_min_tb <- ((total_gap_min_tb - d_smk_min_tb)/total_gap_min_tb)*100
  act_cont_minb <- ((total_gap_minb - d_act_minb)/total_gap_minb)*100
  act_cont_min_tb <- ((total_gap_min_tb - d_act_min_tb)/total_gap_min_tb)*100
  obs_cont_minb <- ((total_gap_minb - d_obs_minb)/total_gap_minb)*100
  obs_cont_min_tb <- ((total_gap_min_tb - d_obs_min_tb)/total_gap_min_tb)*100
  joint_cont_minb <- ((total_gap_minb - residual_minb)/total_gap_minb)*100
  joint_cont_min_tb <- ((total_gap_min_tb - residual_min_tb)/total_gap_min_tb)*100
  rbind(s0_minb,a1_minb,a2_minb,a3_minb,a4_minb,aj_minb,b1_minb,b2_minb,b3_minb,b4_minb,bj_minb,sfinal_minb,
        g_alc_lminb,g_smk_lminb,g_act_lminb,g_obs_lminb,g_joint_lminb,
        g_alc_hminb,g_smk_hminb,g_act_hminb,g_obs_hminb,g_joint_hminb,
        total_gap_minb,d_alc_minb,d_smk_minb,d_act_minb,d_obs_minb,residual_minb,
        g_alc_lmin_tb,g_smk_lmin_tb,g_act_lmin_tb,g_obs_lmin_tb,g_joint_lmin_tb,
        g_alc_hmin_tb,g_smk_hmin_tb,g_act_hmin_tb,g_obs_hmin_tb,g_joint_hmin_tb,
        total_gap_min_tb,d_alc_min_tb,d_smk_min_tb,d_act_min_tb,d_obs_min_tb,residual_min_tb,
        alc_cont_minb,alc_cont_min_tb,smk_cont_minb,smk_cont_min_tb,act_cont_minb,act_cont_min_tb,obs_cont_minb,obs_cont_min_tb,joint_cont_minb,joint_cont_min_tb)
}
## Bootstrap results male
bootresults_mib <- dtms_boot(data=estdata_m,
                             dtms=simple,
                             fun=bootfun_mib,
                             idvar="id",
                             rep=10000,
                             method="block",
                             parallel=TRUE,
                             cores=3)
summary(bootresults_mib)
save(bootresults_mib,file="Results-bootstrap-mibc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfinb <- a1_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
g_smk_lfinb <- a2_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
g_act_lfinb <- a3_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
g_obs_lfinb <- a4_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfinb <- aj_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfinb <- b1_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
g_smk_hfinb <- b2_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
g_act_hfinb <- b3_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
g_obs_hfinb <- b4_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfinb <- bj_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_finb <- sfinal_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_finb <- b1_finb["start:Nondisabled_840","Nondisabled"] - a1_finb["start:Nondisabled_840","Nondisabled"]
d_smk_finb <- b2_finb["start:Nondisabled_840","Nondisabled"] - a2_finb["start:Nondisabled_840","Nondisabled"]
d_act_finb <- b3_finb["start:Nondisabled_840","Nondisabled"] - a3_finb["start:Nondisabled_840","Nondisabled"]
d_obs_finb <- b4_finb["start:Nondisabled_840","Nondisabled"] - a4_finb["start:Nondisabled_840","Nondisabled"]
residual_finb <- bj_finb["start:Nondisabled_840","Nondisabled"] - aj_finb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfin_tb <- a1_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
g_smk_lfin_tb <- a2_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
g_act_lfin_tb <- a3_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
g_obs_lfin_tb <- a4_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfin_tb <- aj_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfin_tb <- b1_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
g_smk_hfin_tb <- b2_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
g_act_hfin_tb <- b3_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
g_obs_hfin_tb <- b4_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfin_tb <- bj_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_fin_tb <- sfinal_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fin_tb <- b1_finb["start:Nondisabled_840","TOTAL"] - a1_finb["start:Nondisabled_840","TOTAL"]
d_smk_fin_tb <- b2_finb["start:Nondisabled_840","TOTAL"] - a2_finb["start:Nondisabled_840","TOTAL"]
d_act_fin_tb <- b3_finb["start:Nondisabled_840","TOTAL"] - a3_finb["start:Nondisabled_840","TOTAL"]
d_obs_fin_tb <- b4_finb["start:Nondisabled_840","TOTAL"] - a4_finb["start:Nondisabled_840","TOTAL"]
residual_fin_tb <- bj_finb["start:Nondisabled_840","TOTAL"] - aj_finb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_finb <- ((total_gap_finb - d_alc_finb)/total_gap_finb)*100
alc_cont_fin_tb <- ((total_gap_fin_tb - d_alc_fin_tb)/total_gap_fin_tb)*100
smk_cont_finb <- ((total_gap_finb - d_smk_finb)/total_gap_finb)*100
smk_cont_fin_tb <- ((total_gap_fin_tb - d_smk_fin_tb)/total_gap_fin_tb)*100
act_cont_finb <- ((total_gap_finb - d_act_finb)/total_gap_finb)*100
act_cont_fin_tb <- ((total_gap_fin_tb - d_act_fin_tb)/total_gap_fin_tb)*100
obs_cont_finb <- ((total_gap_finb - d_obs_finb)/total_gap_finb)*100
obs_cont_fin_tb <- ((total_gap_fin_tb - d_obs_fin_tb)/total_gap_fin_tb)*100
joint_cont_finb <- ((total_gap_finb - residual_finb)/total_gap_finb)*100
joint_cont_fin_tb <- ((total_gap_fin_tb - residual_fin_tb)/total_gap_fin_tb)*100

## Bootstrap function female
bootfun_fib <- function(data,dtms) {
  fit_wib <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+inc_bimi
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_fb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_fb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_flinb <- mean(data$alc_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhinb <- mean(data$alc_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  sm_flinb <- mean(data$sm_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  sm_fhinb <- mean(data$sm_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  pa_flinb <- mean(data$pa_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  pa_fhinb <- mean(data$pa_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  ob_flinb <- mean(data$ob_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  ob_fhinb <- mean(data$ob_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lfinb <- dtms_transitions(dtms=dtms,
                                    model=fit_wib,
                                    controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                  inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                                  pa_cons=pa_flinb, ob_cons=ob_flinb),
                                    ci=TRUE)
  prob_a1_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=0, alc_cons=0, sm_cons=sm_flinb, 
                                                 pa_cons=pa_flinb, ob_cons=ob_flinb),
                                   ci=TRUE)
  prob_a2_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=0, alc_cons=alc_flinb, sm_cons=0, 
                                                 pa_cons=pa_flinb, ob_cons=ob_flinb),
                                   ci=TRUE)
  prob_a3_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                                 pa_cons=0, ob_cons=ob_flinb),
                                   ci=TRUE)
  prob_a4_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=0, alc_cons=alc_flinb, sm_cons=sm_flinb, 
                                                 pa_cons=pa_flinb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=1, alc_cons=0, sm_cons=sm_fhinb, 
                                                 pa_cons=pa_fhinb, ob_cons=ob_fhinb),
                                   ci=TRUE)
  prob_b2_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=1, alc_cons=alc_fhinb, sm_cons=0, 
                                                 pa_cons=pa_fhinb, ob_cons=ob_fhinb),
                                   ci=TRUE)
  prob_b3_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                                 pa_cons=0, ob_cons=ob_fhinb),
                                   ci=TRUE)
  prob_b4_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                                 pa_cons=pa_fhinb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_finb <- dtms_transitions(dtms=dtms,
                                   model=fit_wib,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 inc_bimi=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hfinb <- dtms_transitions(dtms=dtms,
                                        model=fit_wib,
                                        controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                      inc_bimi=1, alc_cons=alc_fhinb, sm_cons=sm_fhinb, 
                                                      pa_cons=pa_fhinb, ob_cons=ob_fhinb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_finb <- dtms_expectancy(probs=prob_s0_lfinb,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_finb <- dtms_expectancy(probs=prob_a1_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_finb <- dtms_expectancy(probs=prob_a2_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_finb <- dtms_expectancy(probs=prob_a3_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_finb <- dtms_expectancy(probs=prob_a4_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_finb <- dtms_expectancy(probs=prob_aj_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_finb <- dtms_expectancy(probs=prob_b1_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_finb <- dtms_expectancy(probs=prob_b2_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_finb <- dtms_expectancy(probs=prob_b3_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_finb <- dtms_expectancy(probs=prob_b4_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_finb <- dtms_expectancy(probs=prob_bj_finb,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_finb <- dtms_expectancy(probs=prob_sfinal_hfinb,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfinb <- a1_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  g_smk_lfinb <- a2_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  g_act_lfinb <- a3_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  g_obs_lfinb <- a4_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  g_joint_lfinb <- aj_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  g_alc_hfinb <- b1_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
  g_smk_hfinb <- b2_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
  g_act_hfinb <- b3_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
  g_obs_hfinb <- b4_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
  g_joint_hfinb <- bj_finb["start:Nondisabled_840","Nondisabled"] - sfinal_finb["start:Nondisabled_840","Nondisabled"]
  total_gap_finb <- sfinal_finb["start:Nondisabled_840","Nondisabled"] - s0_finb["start:Nondisabled_840","Nondisabled"]
  d_alc_finb <- b1_finb["start:Nondisabled_840","Nondisabled"] - a1_finb["start:Nondisabled_840","Nondisabled"]
  d_smk_finb <- b2_finb["start:Nondisabled_840","Nondisabled"] - a2_finb["start:Nondisabled_840","Nondisabled"]
  d_act_finb <- b3_finb["start:Nondisabled_840","Nondisabled"] - a3_finb["start:Nondisabled_840","Nondisabled"]
  d_obs_finb <- b4_finb["start:Nondisabled_840","Nondisabled"] - a4_finb["start:Nondisabled_840","Nondisabled"]
  residual_finb <- bj_finb["start:Nondisabled_840","Nondisabled"] - aj_finb["start:Nondisabled_840","Nondisabled"]
  g_alc_lfin_tb <- a1_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  g_smk_lfin_tb <- a2_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  g_act_lfin_tb <- a3_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  g_obs_lfin_tb <- a4_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  g_joint_lfin_tb <- aj_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  g_alc_hfin_tb <- b1_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
  g_smk_hfin_tb <- b2_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
  g_act_hfin_tb <- b3_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
  g_obs_hfin_tb <- b4_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
  g_joint_hfin_tb <- bj_finb["start:Nondisabled_840","TOTAL"] - sfinal_finb["start:Nondisabled_840","TOTAL"]
  total_gap_fin_tb <- sfinal_finb["start:Nondisabled_840","TOTAL"] - s0_finb["start:Nondisabled_840","TOTAL"]
  d_alc_fin_tb <- b1_finb["start:Nondisabled_840","TOTAL"] - a1_finb["start:Nondisabled_840","TOTAL"]
  d_smk_fin_tb <- b2_finb["start:Nondisabled_840","TOTAL"] - a2_finb["start:Nondisabled_840","TOTAL"]
  d_act_fin_tb <- b3_finb["start:Nondisabled_840","TOTAL"] - a3_finb["start:Nondisabled_840","TOTAL"]
  d_obs_fin_tb <- b4_finb["start:Nondisabled_840","TOTAL"] - a4_finb["start:Nondisabled_840","TOTAL"]
  residual_fin_tb <- bj_finb["start:Nondisabled_840","TOTAL"] - aj_finb["start:Nondisabled_840","TOTAL"]
  alc_cont_finb <- ((total_gap_finb - d_alc_finb)/total_gap_finb)*100
  alc_cont_fin_tb <- ((total_gap_fin_tb - d_alc_fin_tb)/total_gap_fin_tb)*100
  smk_cont_finb <- ((total_gap_finb - d_smk_finb)/total_gap_finb)*100
  smk_cont_fin_tb <- ((total_gap_fin_tb - d_smk_fin_tb)/total_gap_fin_tb)*100
  act_cont_finb <- ((total_gap_finb - d_act_finb)/total_gap_finb)*100
  act_cont_fin_tb <- ((total_gap_fin_tb - d_act_fin_tb)/total_gap_fin_tb)*100
  obs_cont_finb <- ((total_gap_finb - d_obs_finb)/total_gap_finb)*100
  obs_cont_fin_tb <- ((total_gap_fin_tb - d_obs_fin_tb)/total_gap_fin_tb)*100
  joint_cont_finb <- ((total_gap_finb - residual_finb)/total_gap_finb)*100
  joint_cont_fin_tb <- ((total_gap_fin_tb - residual_fin_tb)/total_gap_fin_tb)*100
  rbind(s0_finb,a1_finb,a2_finb,a3_finb,a4_finb,aj_finb,b1_finb,b2_finb,b3_finb,b4_finb,bj_finb,sfinal_finb,
        g_alc_lfinb,g_smk_lfinb,g_act_lfinb,g_obs_lfinb,g_joint_lfinb,
        g_alc_hfinb,g_smk_hfinb,g_act_hfinb,g_obs_hfinb,g_joint_hfinb,
        total_gap_finb,d_alc_finb,d_smk_finb,d_act_finb,d_obs_finb,residual_finb,
        g_alc_lfin_tb,g_smk_lfin_tb,g_act_lfin_tb,g_obs_lfin_tb,g_joint_lfin_tb,
        g_alc_hfin_tb,g_smk_hfin_tb,g_act_hfin_tb,g_obs_hfin_tb,g_joint_hfin_tb,
        total_gap_fin_tb,d_alc_fin_tb,d_smk_fin_tb,d_act_fin_tb,d_obs_fin_tb,residual_fin_tb,
        alc_cont_finb,alc_cont_fin_tb,smk_cont_finb,smk_cont_fin_tb,act_cont_finb,act_cont_fin_tb,obs_cont_finb,obs_cont_fin_tb,joint_cont_finb,joint_cont_fin_tb)
}
## Bootstrap results female
bootresults_fib <- dtms_boot(data=estdata_w,
                             dtms=simple,
                             fun=bootfun_fib,
                             idvar="id",
                             rep=10000,
                             method="block",
                             parallel=TRUE,
                             cores=3)
summary(bootresults_fib)
save(bootresults_fib,file="Results-bootstrap-fibc-10000.Rda")

## Print estimates
s0_minb
a1_minb
a2_minb
a3_minb
a4_minb
aj_minb
b1_minb
b2_minb
b3_minb
b4_minb
bj_minb
sfinal_minb
g_alc_lminb
g_smk_lminb
g_act_lminb
g_obs_lminb
g_joint_lminb
g_alc_hminb
g_smk_hminb
g_act_hminb
g_obs_hminb
g_joint_hminb
total_gap_minb
d_alc_minb
d_smk_minb
d_act_minb
d_obs_minb
residual_minb
g_alc_lmin_tb
g_smk_lmin_tb
g_act_lmin_tb
g_obs_lmin_tb
g_joint_lmin_tb
g_alc_hmin_tb
g_smk_hmin_tb
g_act_hmin_tb
g_obs_hmin_tb
g_joint_hmin_tb
total_gap_min_tb
d_alc_min_tb
d_smk_min_tb
d_act_min_tb
d_obs_min_tb
residual_min_tb
alc_cont_minb
alc_cont_min_tb
smk_cont_minb
smk_cont_min_tb
act_cont_minb
act_cont_min_tb
obs_cont_minb
obs_cont_min_tb
joint_cont_minb
joint_cont_min_tb

s0_finb
a1_finb
a2_finb
a3_finb
a4_finb
aj_finb
b1_finb
b2_finb
b3_finb
b4_finb
bj_finb
sfinal_finb
g_alc_lfinb
g_smk_lfinb
g_act_lfinb
g_obs_lfinb
g_joint_lfinb
g_alc_hfinb
g_smk_hfinb
g_act_hfinb
g_obs_hfinb
g_joint_hfinb
total_gap_finb
d_alc_finb
d_smk_finb
d_act_finb
d_obs_finb
residual_finb
g_alc_lfin_tb
g_smk_lfin_tb
g_act_lfin_tb
g_obs_lfin_tb
g_joint_lfin_tb
g_alc_hfin_tb
g_smk_hfin_tb
g_act_hfin_tb
g_obs_hfin_tb
g_joint_hfin_tb
total_gap_fin_tb
d_alc_fin_tb
d_smk_fin_tb
d_act_fin_tb
d_obs_fin_tb
residual_fin_tb
alc_cont_finb
alc_cont_fin_tb
smk_cont_finb
smk_cont_fin_tb
act_cont_finb
act_cont_fin_tb
obs_cont_finb
obs_cont_fin_tb
joint_cont_finb
joint_cont_fin_tb
