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
fit_meb <- dtms_fit(data=estdata_m,
                   formula=to~from+eth_bi+time+I(time^2)+cc_cons+edu_cons_bi
                   +alc_cons+sm_cons+pa_cons+ob_cons)

## Fit women adjusted
fit_web <- dtms_fit(data=estdata_w,
                   formula=to~from+eth_bi+time+I(time^2)+cc_cons+edu_cons_bi
                   +alc_cons+sm_cons+pa_cons+ob_cons)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_mb <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_mb
cc_gm_mb <- mean(estdata_m$cc_cons[estdata_m$intbloc==0], na.rm = TRUE)
cc_gm_mb
alc_mledb <- mean(estdata_m$alc_cons[estdata_m$edu_cons_bi==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mledb 
alc_mhedb <- mean(estdata_m$alc_cons[estdata_m$edu_cons_bi==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhedb
sm_mledb <- mean(estdata_m$sm_cons[estdata_m$edu_cons_bi==0 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mledb
sm_mhedb <- mean(estdata_m$sm_cons[estdata_m$edu_cons_bi==1 & estdata_m$intbloc==0], na.rm = TRUE)
sm_mhedb
pa_mledb <- mean(estdata_m$pa_cons[estdata_m$edu_cons_bi==0 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mledb
pa_mhedb <- mean(estdata_m$pa_cons[estdata_m$edu_cons_bi==1 & estdata_m$intbloc==0], na.rm = TRUE)
pa_mhedb
ob_mledb <- mean(estdata_m$ob_cons[estdata_m$edu_cons_bi==0 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mledb
ob_mhedb <- mean(estdata_m$ob_cons[estdata_m$edu_cons_bi==1 & estdata_m$intbloc==0], na.rm = TRUE)
ob_mhedb

## Female
## Time-constant variables
eth_gm_fb <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_fb
cc_gm_fb <- mean(estdata_w$cc_cons[estdata_w$intbloc==0], na.rm = TRUE)
cc_gm_fb
alc_fledb <- mean(estdata_w$alc_cons[estdata_w$edu_cons_bi==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fledb 
alc_fhedb <- mean(estdata_w$alc_cons[estdata_w$edu_cons_bi==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhedb
sm_fledb <- mean(estdata_w$sm_cons[estdata_w$edu_cons_bi==0 & estdata_w$intbloc==0], na.rm = TRUE)
sm_fledb 
sm_fhedb <- mean(estdata_w$sm_cons[estdata_w$edu_cons_bi==1 & estdata_w$intbloc==0], na.rm = TRUE)
sm_fhedb
pa_fledb <- mean(estdata_w$pa_cons[estdata_w$edu_cons_bi==0 & estdata_w$intbloc==0], na.rm = TRUE)
pa_fledb 
pa_fhedb <- mean(estdata_w$pa_cons[estdata_w$edu_cons_bi==1 & estdata_w$intbloc==0], na.rm = TRUE)
pa_fhedb
ob_fledb <- mean(estdata_w$ob_cons[estdata_w$edu_cons_bi==0 & estdata_w$intbloc==0], na.rm = TRUE)
ob_fledb 
ob_fhedb <- mean(estdata_w$ob_cons[estdata_w$edu_cons_bi==1 & estdata_w$intbloc==0], na.rm = TRUE)
ob_fhedb

## Predict probabilities ##############################################

## Reference scenario lower SES male
prob_s0_lmedb <- dtms_transitions(dtms=simple,
                                 model=fit_meb,
                                 controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                               edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                               pa_cons=pa_mledb, ob_cons=ob_mledb),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=0, alc_cons=0, sm_cons=sm_mledb, 
                                              pa_cons=pa_mledb, ob_cons=ob_mledb),
                                ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=0, 
                                              pa_cons=pa_mledb, ob_cons=ob_mledb),
                                ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                              pa_cons=0, ob_cons=ob_mledb),
                                ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                              pa_cons=pa_mledb, ob_cons=0),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=0, alc_cons=0, sm_cons=0, 
                                              pa_cons=0, ob_cons=0),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=1, alc_cons=0, sm_cons=sm_mhedb, 
                                              pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=0, 
                                              pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                              pa_cons=0, ob_cons=ob_mhedb),
                                ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                              pa_cons=pa_mhedb, ob_cons=0),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_medb <- dtms_transitions(dtms=simple,
                                model=fit_meb,
                                controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                              edu_cons_bi=1, alc_cons=0, sm_cons=0, 
                                              pa_cons=0, ob_cons=0),
                                ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hmedb <- dtms_transitions(dtms=simple,
                                     model=fit_meb,
                                     controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                   edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                                   pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                     ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfedb <- dtms_transitions(dtms=simple,
                                 model=fit_web,
                                 controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                               edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                               pa_cons=pa_fledb, ob_cons=ob_fledb),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=0, alc_cons=0, sm_cons=sm_fledb, 
                                              pa_cons=pa_fledb, ob_cons=ob_fledb),
                                ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=0, 
                                              pa_cons=pa_fledb, ob_cons=ob_fledb),
                                ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                              pa_cons=0, ob_cons=ob_fledb),
                                ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                              pa_cons=pa_fledb, ob_cons=0),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=0, alc_cons=0, sm_cons=0, 
                                              pa_cons=0, ob_cons=0),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=1, alc_cons=0, sm_cons=sm_fhedb, 
                                              pa_cons=pa_fhedb, ob_cons=ob_fhedb),
                                ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=0, 
                                              pa_cons=pa_fhedb, ob_cons=ob_fhedb),
                                ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                              pa_cons=0, ob_cons=ob_fhedb),
                                ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                              pa_cons=pa_fhedb, ob_cons=0),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_fedb <- dtms_transitions(dtms=simple,
                                model=fit_web,
                                controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                              edu_cons_bi=1, alc_cons=0, sm_cons=0, 
                                              pa_cons=0, ob_cons=0),
                                ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfedb <- dtms_transitions(dtms=simple,
                                     model=fit_web,
                                     controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                   edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                                   pa_cons=pa_fhedb, ob_cons=ob_fhedb),
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
s0_medb <- dtms_expectancy(probs=prob_s0_lmedb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_medb <- dtms_expectancy(probs=prob_a1_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_medb <- dtms_expectancy(probs=prob_a2_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_medb <- dtms_expectancy(probs=prob_a3_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_medb <- dtms_expectancy(probs=prob_a4_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_medb <- dtms_expectancy(probs=prob_aj_medb,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_medb <- dtms_expectancy(probs=prob_b1_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_medb <- dtms_expectancy(probs=prob_b2_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_medb <- dtms_expectancy(probs=prob_b3_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_medb <- dtms_expectancy(probs=prob_b4_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_medb <- dtms_expectancy(probs=prob_bj_medb,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_medb <- dtms_expectancy(probs=prob_sfinal_hmedb,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_fedb <- dtms_expectancy(probs=prob_s0_lfedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_fedb <- dtms_expectancy(probs=prob_a1_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_fedb <- dtms_expectancy(probs=prob_a2_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_fedb <- dtms_expectancy(probs=prob_a3_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_fedb <- dtms_expectancy(probs=prob_a4_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_fedb <- dtms_expectancy(probs=prob_aj_fedb,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_fedb <- dtms_expectancy(probs=prob_b1_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_fedb <- dtms_expectancy(probs=prob_b2_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_fedb <- dtms_expectancy(probs=prob_b3_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_fedb <- dtms_expectancy(probs=prob_b4_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_fedb <- dtms_expectancy(probs=prob_bj_fedb,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_fedb <- dtms_expectancy(probs=prob_sfinal_hfedb,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmedb <- a1_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
g_smk_lmedb <- a2_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
g_act_lmedb <- a3_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
g_obs_lmedb <- a4_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmedb <- aj_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmedb <- b1_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
g_smk_hmedb <- b2_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
g_act_hmedb <- b3_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
g_obs_hmedb <- b4_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmedb <- bj_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_medb <- sfinal_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_medb <- b1_medb["start:Nondisabled_840","Nondisabled"] - a1_medb["start:Nondisabled_840","Nondisabled"]
d_smk_medb <- b2_medb["start:Nondisabled_840","Nondisabled"] - a2_medb["start:Nondisabled_840","Nondisabled"]
d_act_medb <- b3_medb["start:Nondisabled_840","Nondisabled"] - a3_medb["start:Nondisabled_840","Nondisabled"]
d_obs_medb <- b4_medb["start:Nondisabled_840","Nondisabled"] - a4_medb["start:Nondisabled_840","Nondisabled"]
residual_medb <- bj_medb["start:Nondisabled_840","Nondisabled"] - aj_medb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmed_tb <- a1_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
g_smk_lmed_tb <- a2_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
g_act_lmed_tb <- a3_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
g_obs_lmed_tb <- a4_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmed_tb <- aj_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmed_tb <- b1_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
g_smk_hmed_tb <- b2_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
g_act_hmed_tb <- b3_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
g_obs_hmed_tb <- b4_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmed_tb <- bj_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_med_tb <- sfinal_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_med_tb <- b1_medb["start:Nondisabled_840","TOTAL"] - a1_medb["start:Nondisabled_840","TOTAL"]
d_smk_med_tb <- b2_medb["start:Nondisabled_840","TOTAL"] - a2_medb["start:Nondisabled_840","TOTAL"]
d_act_med_tb <- b3_medb["start:Nondisabled_840","TOTAL"] - a3_medb["start:Nondisabled_840","TOTAL"]
d_obs_med_tb <- b4_medb["start:Nondisabled_840","TOTAL"] - a4_medb["start:Nondisabled_840","TOTAL"]
residual_med_tb <- bj_medb["start:Nondisabled_840","TOTAL"] - aj_medb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_medb <- ((total_gap_medb - d_alc_medb)/total_gap_medb)*100
alc_cont_med_tb <- ((total_gap_med_tb - d_alc_med_tb)/total_gap_med_tb)*100
smk_cont_medb <- ((total_gap_medb - d_smk_medb)/total_gap_medb)*100
smk_cont_med_tb <- ((total_gap_med_tb - d_smk_med_tb)/total_gap_med_tb)*100
act_cont_medb <- ((total_gap_medb - d_act_medb)/total_gap_medb)*100
act_cont_med_tb <- ((total_gap_med_tb - d_act_med_tb)/total_gap_med_tb)*100
obs_cont_medb <- ((total_gap_medb - d_obs_medb)/total_gap_medb)*100
obs_cont_med_tb <- ((total_gap_med_tb - d_obs_med_tb)/total_gap_med_tb)*100
joint_cont_medb <- ((total_gap_medb - residual_medb)/total_gap_medb)*100
joint_cont_med_tb <- ((total_gap_med_tb - residual_med_tb)/total_gap_med_tb)*100

## Bootstrap function male
bootfun_meb <- function(data,dtms) {
  fit_meb <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+edu_cons_bi
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_mb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_mb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_mledb <- mean(data$alc_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhedb <- mean(data$alc_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  sm_mledb <- mean(data$sm_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  sm_mhedb <- mean(data$sm_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  pa_mledb <- mean(data$pa_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  pa_mhedb <- mean(data$pa_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  ob_mledb <- mean(data$ob_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  ob_mhedb <- mean(data$ob_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lmedb <- dtms_transitions(dtms=dtms,
                                    model=fit_meb,
                                    controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                  edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                                  pa_cons=pa_mledb, ob_cons=ob_mledb),
                                    ci=TRUE)
  prob_a1_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=0, alc_cons=0, sm_cons=sm_mledb, 
                                                 pa_cons=pa_mledb, ob_cons=ob_mledb),
                                   ci=TRUE)
  prob_a2_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=0, 
                                                 pa_cons=pa_mledb, ob_cons=ob_mledb),
                                   ci=TRUE)
  prob_a3_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                                 pa_cons=0, ob_cons=ob_mledb),
                                   ci=TRUE)
  prob_a4_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=0, alc_cons=alc_mledb, sm_cons=sm_mledb, 
                                                 pa_cons=pa_mledb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=1, alc_cons=0, sm_cons=sm_mhedb, 
                                                 pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                   ci=TRUE)
  prob_b2_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=0, 
                                                 pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                   ci=TRUE)
  prob_b3_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                                 pa_cons=0, ob_cons=ob_mhedb),
                                   ci=TRUE)
  prob_b4_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                                 pa_cons=pa_mhedb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_medb <- dtms_transitions(dtms=dtms,
                                   model=fit_meb,
                                   controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                 edu_cons_bi=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hmedb <- dtms_transitions(dtms=dtms,
                                        model=fit_meb,
                                        controls=list(eth_bi=eth_gm_mb, time=840:1319, cc_cons=cc_gm_mb,
                                                      edu_cons_bi=1, alc_cons=alc_mhedb, sm_cons=sm_mhedb, 
                                                      pa_cons=pa_mhedb, ob_cons=ob_mhedb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_medb <- dtms_expectancy(probs=prob_s0_lmedb,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_medb <- dtms_expectancy(probs=prob_a1_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_medb <- dtms_expectancy(probs=prob_a2_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_medb <- dtms_expectancy(probs=prob_a3_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_medb <- dtms_expectancy(probs=prob_a4_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_medb <- dtms_expectancy(probs=prob_aj_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_medb <- dtms_expectancy(probs=prob_b1_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_medb <- dtms_expectancy(probs=prob_b2_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_medb <- dtms_expectancy(probs=prob_b3_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_medb <- dtms_expectancy(probs=prob_b4_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_medb <- dtms_expectancy(probs=prob_bj_medb,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_medb <- dtms_expectancy(probs=prob_sfinal_hmedb,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lmedb <- a1_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  g_smk_lmedb <- a2_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  g_act_lmedb <- a3_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  g_obs_lmedb <- a4_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  g_joint_lmedb <- aj_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  g_alc_hmedb <- b1_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
  g_smk_hmedb <- b2_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
  g_act_hmedb <- b3_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
  g_obs_hmedb <- b4_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
  g_joint_hmedb <- bj_medb["start:Nondisabled_840","Nondisabled"] - sfinal_medb["start:Nondisabled_840","Nondisabled"]
  total_gap_medb <- sfinal_medb["start:Nondisabled_840","Nondisabled"] - s0_medb["start:Nondisabled_840","Nondisabled"]
  d_alc_medb <- b1_medb["start:Nondisabled_840","Nondisabled"] - a1_medb["start:Nondisabled_840","Nondisabled"]
  d_smk_medb <- b2_medb["start:Nondisabled_840","Nondisabled"] - a2_medb["start:Nondisabled_840","Nondisabled"]
  d_act_medb <- b3_medb["start:Nondisabled_840","Nondisabled"] - a3_medb["start:Nondisabled_840","Nondisabled"]
  d_obs_medb <- b4_medb["start:Nondisabled_840","Nondisabled"] - a4_medb["start:Nondisabled_840","Nondisabled"]
  residual_medb <- bj_medb["start:Nondisabled_840","Nondisabled"] - aj_medb["start:Nondisabled_840","Nondisabled"]
  g_alc_lmed_tb <- a1_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  g_smk_lmed_tb <- a2_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  g_act_lmed_tb <- a3_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  g_obs_lmed_tb <- a4_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  g_joint_lmed_tb <- aj_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  g_alc_hmed_tb <- b1_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
  g_smk_hmed_tb <- b2_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
  g_act_hmed_tb <- b3_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
  g_obs_hmed_tb <- b4_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
  g_joint_hmed_tb <- bj_medb["start:Nondisabled_840","TOTAL"] - sfinal_medb["start:Nondisabled_840","TOTAL"]
  total_gap_med_tb <- sfinal_medb["start:Nondisabled_840","TOTAL"] - s0_medb["start:Nondisabled_840","TOTAL"]
  d_alc_med_tb <- b1_medb["start:Nondisabled_840","TOTAL"] - a1_medb["start:Nondisabled_840","TOTAL"]
  d_smk_med_tb <- b2_medb["start:Nondisabled_840","TOTAL"] - a2_medb["start:Nondisabled_840","TOTAL"]
  d_act_med_tb <- b3_medb["start:Nondisabled_840","TOTAL"] - a3_medb["start:Nondisabled_840","TOTAL"]
  d_obs_med_tb <- b4_medb["start:Nondisabled_840","TOTAL"] - a4_medb["start:Nondisabled_840","TOTAL"]
  residual_med_tb <- bj_medb["start:Nondisabled_840","TOTAL"] - aj_medb["start:Nondisabled_840","TOTAL"]
  alc_cont_medb <- ((total_gap_medb - d_alc_medb)/total_gap_medb)*100
  alc_cont_med_tb <- ((total_gap_med_tb - d_alc_med_tb)/total_gap_med_tb)*100
  smk_cont_medb <- ((total_gap_medb - d_smk_medb)/total_gap_medb)*100
  smk_cont_med_tb <- ((total_gap_med_tb - d_smk_med_tb)/total_gap_med_tb)*100
  act_cont_medb <- ((total_gap_medb - d_act_medb)/total_gap_medb)*100
  act_cont_med_tb <- ((total_gap_med_tb - d_act_med_tb)/total_gap_med_tb)*100
  obs_cont_medb <- ((total_gap_medb - d_obs_medb)/total_gap_medb)*100
  obs_cont_med_tb <- ((total_gap_med_tb - d_obs_med_tb)/total_gap_med_tb)*100
  joint_cont_medb <- ((total_gap_medb - residual_medb)/total_gap_medb)*100
  joint_cont_med_tb <- ((total_gap_med_tb - residual_med_tb)/total_gap_med_tb)*100
  rbind(s0_medb,a1_medb,a2_medb,a3_medb,a4_medb,aj_medb,b1_medb,b2_medb,b3_medb,b4_medb,bj_medb,sfinal_medb,
        g_alc_lmedb,g_smk_lmedb,g_act_lmedb,g_obs_lmedb,g_joint_lmedb,
        g_alc_hmedb,g_smk_hmedb,g_act_hmedb,g_obs_hmedb,g_joint_hmedb,
        total_gap_medb,d_alc_medb,d_smk_medb,d_act_medb,d_obs_medb,residual_medb,
        g_alc_lmed_tb,g_smk_lmed_tb,g_act_lmed_tb,g_obs_lmed_tb,g_joint_lmed_tb,
        g_alc_hmed_tb,g_smk_hmed_tb,g_act_hmed_tb,g_obs_hmed_tb,g_joint_hmed_tb,
        total_gap_med_tb,d_alc_med_tb,d_smk_med_tb,d_act_med_tb,d_obs_med_tb,residual_med_tb,
        alc_cont_medb,alc_cont_med_tb,smk_cont_medb,smk_cont_med_tb,act_cont_medb,act_cont_med_tb,obs_cont_medb,obs_cont_med_tb,joint_cont_medb,joint_cont_med_tb)
}
## Bootstrap results male
bootresults_meb <- dtms_boot(data=estdata_m,
                            dtms=simple,
                            fun=bootfun_meb,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_meb)
save(bootresults_meb,file="Results-bootstrap-mebc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfedb <- a1_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
g_smk_lfedb <- a2_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
g_act_lfedb <- a3_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
g_obs_lfedb <- a4_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfedb <- aj_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfedb <- b1_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
g_smk_hfedb <- b2_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
g_act_hfedb <- b3_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
g_obs_hfedb <- b4_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfedb <- bj_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES)
total_gap_fedb <- sfinal_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fedb <- b1_fedb["start:Nondisabled_840","Nondisabled"] - a1_fedb["start:Nondisabled_840","Nondisabled"]
d_smk_fedb <- b2_fedb["start:Nondisabled_840","Nondisabled"] - a2_fedb["start:Nondisabled_840","Nondisabled"]
d_act_fedb <- b3_fedb["start:Nondisabled_840","Nondisabled"] - a3_fedb["start:Nondisabled_840","Nondisabled"]
d_obs_fedb <- b4_fedb["start:Nondisabled_840","Nondisabled"] - a4_fedb["start:Nondisabled_840","Nondisabled"]
residual_fedb <- bj_fedb["start:Nondisabled_840","Nondisabled"] - aj_fedb["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfed_tb <- a1_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
g_smk_lfed_tb <- a2_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
g_act_lfed_tb <- a3_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
g_obs_lfed_tb <- a4_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfed_tb <- aj_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfed_tb <- b1_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
g_smk_hfed_tb <- b2_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
g_act_hfed_tb <- b3_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
g_obs_hfed_tb <- b4_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfed_tb <- bj_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES)
total_gap_fed_tb <- sfinal_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fed_tb <- b1_fedb["start:Nondisabled_840","TOTAL"] - a1_fedb["start:Nondisabled_840","TOTAL"]
d_smk_fed_tb <- b2_fedb["start:Nondisabled_840","TOTAL"] - a2_fedb["start:Nondisabled_840","TOTAL"]
d_act_fed_tb <- b3_fedb["start:Nondisabled_840","TOTAL"] - a3_fedb["start:Nondisabled_840","TOTAL"]
d_obs_fed_tb <- b4_fedb["start:Nondisabled_840","TOTAL"] - a4_fedb["start:Nondisabled_840","TOTAL"]
residual_fed_tb <- bj_fedb["start:Nondisabled_840","TOTAL"] - aj_fedb["start:Nondisabled_840","TOTAL"]

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_fedb <- ((total_gap_fedb - d_alc_fedb)/total_gap_fedb)*100
alc_cont_fed_tb <- ((total_gap_fed_tb - d_alc_fed_tb)/total_gap_fed_tb)*100
smk_cont_fedb <- ((total_gap_fedb - d_smk_fedb)/total_gap_fedb)*100
smk_cont_fed_tb <- ((total_gap_fed_tb - d_smk_fed_tb)/total_gap_fed_tb)*100
act_cont_fedb <- ((total_gap_fedb - d_act_fedb)/total_gap_fedb)*100
act_cont_fed_tb <- ((total_gap_fed_tb - d_act_fed_tb)/total_gap_fed_tb)*100
obs_cont_fedb <- ((total_gap_fedb - d_obs_fedb)/total_gap_fedb)*100
obs_cont_fed_tb <- ((total_gap_fed_tb - d_obs_fed_tb)/total_gap_fed_tb)*100
joint_cont_fedb <- ((total_gap_fedb - residual_fedb)/total_gap_fedb)*100
joint_cont_fed_tb <- ((total_gap_fed_tb - residual_fed_tb)/total_gap_fed_tb)*100

## Bootstrap function female
bootfun_feb <- function(data,dtms) {
  fit_web <- dtms_fit(data=data,
                      formula=to~from+eth_bi+time+I(time^2)+cc_cons+edu_cons_bi
                      +alc_cons+sm_cons+pa_cons+ob_cons)
  eth_gm_fb <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  cc_gm_fb <- mean(data$cc_cons[data$intbloc==0], na.rm = TRUE)
  alc_fledb <- mean(data$alc_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhedb <- mean(data$alc_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  sm_fledb <- mean(data$sm_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  sm_fhedb <- mean(data$sm_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  pa_fledb <- mean(data$pa_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  pa_fhedb <- mean(data$pa_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  ob_fledb <- mean(data$ob_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  ob_fhedb <- mean(data$ob_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  prob_s0_lfedb <- dtms_transitions(dtms=dtms,
                                    model=fit_web,
                                    controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                  edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                                  pa_cons=pa_fledb, ob_cons=ob_fledb),
                                    ci=TRUE)
  prob_a1_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=0, alc_cons=0, sm_cons=sm_fledb, 
                                                 pa_cons=pa_fledb, ob_cons=ob_fledb),
                                   ci=TRUE)
  prob_a2_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=0, 
                                                 pa_cons=pa_fledb, ob_cons=ob_fledb),
                                   ci=TRUE)
  prob_a3_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                                 pa_cons=0, ob_cons=ob_fledb),
                                   ci=TRUE)
  prob_a4_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=0, alc_cons=alc_fledb, sm_cons=sm_fledb, 
                                                 pa_cons=pa_fledb, ob_cons=0),
                                   ci=TRUE)
  prob_aj_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=0, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_b1_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=1, alc_cons=0, sm_cons=sm_fhedb, 
                                                 pa_cons=pa_fhedb, ob_cons=ob_fhedb),
                                   ci=TRUE)
  prob_b2_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=0, 
                                                 pa_cons=pa_fhedb, ob_cons=ob_fhedb),
                                   ci=TRUE)
  prob_b3_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                                 pa_cons=0, ob_cons=ob_fhedb),
                                   ci=TRUE)
  prob_b4_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                                 pa_cons=pa_fhedb, ob_cons=0),
                                   ci=TRUE)
  prob_bj_fedb <- dtms_transitions(dtms=dtms,
                                   model=fit_web,
                                   controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                 edu_cons_bi=1, alc_cons=0, sm_cons=0, 
                                                 pa_cons=0, ob_cons=0),
                                   ci=TRUE)
  prob_sfinal_hfedb <- dtms_transitions(dtms=dtms,
                                        model=fit_web,
                                        controls=list(eth_bi=eth_gm_fb, time=840:1319, cc_cons=cc_gm_fb,
                                                      edu_cons_bi=1, alc_cons=alc_fhedb, sm_cons=sm_fhedb, 
                                                      pa_cons=pa_fhedb, ob_cons=ob_fhedb),
                                        ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  s0_fedb <- dtms_expectancy(probs=prob_s0_lfedb,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_fedb <- dtms_expectancy(probs=prob_a1_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_fedb <- dtms_expectancy(probs=prob_a2_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_fedb <- dtms_expectancy(probs=prob_a3_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_fedb <- dtms_expectancy(probs=prob_a4_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_fedb <- dtms_expectancy(probs=prob_aj_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_fedb <- dtms_expectancy(probs=prob_b1_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_fedb <- dtms_expectancy(probs=prob_b2_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_fedb <- dtms_expectancy(probs=prob_b3_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_fedb <- dtms_expectancy(probs=prob_b4_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_fedb <- dtms_expectancy(probs=prob_bj_fedb,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_fedb <- dtms_expectancy(probs=prob_sfinal_hfedb,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfedb <- a1_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  g_smk_lfedb <- a2_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  g_act_lfedb <- a3_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  g_obs_lfedb <- a4_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  g_joint_lfedb <- aj_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  g_alc_hfedb <- b1_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
  g_smk_hfedb <- b2_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
  g_act_hfedb <- b3_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
  g_obs_hfedb <- b4_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
  g_joint_hfedb <- bj_fedb["start:Nondisabled_840","Nondisabled"] - sfinal_fedb["start:Nondisabled_840","Nondisabled"]
  total_gap_fedb <- sfinal_fedb["start:Nondisabled_840","Nondisabled"] - s0_fedb["start:Nondisabled_840","Nondisabled"]
  d_alc_fedb <- b1_fedb["start:Nondisabled_840","Nondisabled"] - a1_fedb["start:Nondisabled_840","Nondisabled"]
  d_smk_fedb <- b2_fedb["start:Nondisabled_840","Nondisabled"] - a2_fedb["start:Nondisabled_840","Nondisabled"]
  d_act_fedb <- b3_fedb["start:Nondisabled_840","Nondisabled"] - a3_fedb["start:Nondisabled_840","Nondisabled"]
  d_obs_fedb <- b4_fedb["start:Nondisabled_840","Nondisabled"] - a4_fedb["start:Nondisabled_840","Nondisabled"]
  residual_fedb <- bj_fedb["start:Nondisabled_840","Nondisabled"] - aj_fedb["start:Nondisabled_840","Nondisabled"]
  g_alc_lfed_tb <- a1_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  g_smk_lfed_tb <- a2_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  g_act_lfed_tb <- a3_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  g_obs_lfed_tb <- a4_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  g_joint_lfed_tb <- aj_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  g_alc_hfed_tb <- b1_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
  g_smk_hfed_tb <- b2_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
  g_act_hfed_tb <- b3_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
  g_obs_hfed_tb <- b4_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
  g_joint_hfed_tb <- bj_fedb["start:Nondisabled_840","TOTAL"] - sfinal_fedb["start:Nondisabled_840","TOTAL"]
  total_gap_fed_tb <- sfinal_fedb["start:Nondisabled_840","TOTAL"] - s0_fedb["start:Nondisabled_840","TOTAL"]
  d_alc_fed_tb <- b1_fedb["start:Nondisabled_840","TOTAL"] - a1_fedb["start:Nondisabled_840","TOTAL"]
  d_smk_fed_tb <- b2_fedb["start:Nondisabled_840","TOTAL"] - a2_fedb["start:Nondisabled_840","TOTAL"]
  d_act_fed_tb <- b3_fedb["start:Nondisabled_840","TOTAL"] - a3_fedb["start:Nondisabled_840","TOTAL"]
  d_obs_fed_tb <- b4_fedb["start:Nondisabled_840","TOTAL"] - a4_fedb["start:Nondisabled_840","TOTAL"]
  residual_fed_tb <- bj_fedb["start:Nondisabled_840","TOTAL"] - aj_fedb["start:Nondisabled_840","TOTAL"]
  alc_cont_fedb <- ((total_gap_fedb - d_alc_fedb)/total_gap_fedb)*100
  alc_cont_fed_tb <- ((total_gap_fed_tb - d_alc_fed_tb)/total_gap_fed_tb)*100
  smk_cont_fedb <- ((total_gap_fedb - d_smk_fedb)/total_gap_fedb)*100
  smk_cont_fed_tb <- ((total_gap_fed_tb - d_smk_fed_tb)/total_gap_fed_tb)*100
  act_cont_fedb <- ((total_gap_fedb - d_act_fedb)/total_gap_fedb)*100
  act_cont_fed_tb <- ((total_gap_fed_tb - d_act_fed_tb)/total_gap_fed_tb)*100
  obs_cont_fedb <- ((total_gap_fedb - d_obs_fedb)/total_gap_fedb)*100
  obs_cont_fed_tb <- ((total_gap_fed_tb - d_obs_fed_tb)/total_gap_fed_tb)*100
  joint_cont_fedb <- ((total_gap_fedb - residual_fedb)/total_gap_fedb)*100
  joint_cont_fed_tb <- ((total_gap_fed_tb - residual_fed_tb)/total_gap_fed_tb)*100
  rbind(s0_fedb,a1_fedb,a2_fedb,a3_fedb,a4_fedb,aj_fedb,b1_fedb,b2_fedb,b3_fedb,b4_fedb,bj_fedb,sfinal_fedb,
        g_alc_lfedb,g_smk_lfedb,g_act_lfedb,g_obs_lfedb,g_joint_lfedb,
        g_alc_hfedb,g_smk_hfedb,g_act_hfedb,g_obs_hfedb,g_joint_hfedb,
        total_gap_fedb,d_alc_fedb,d_smk_fedb,d_act_fedb,d_obs_fedb,residual_fedb,
        g_alc_lfed_tb,g_smk_lfed_tb,g_act_lfed_tb,g_obs_lfed_tb,g_joint_lfed_tb,
        g_alc_hfed_tb,g_smk_hfed_tb,g_act_hfed_tb,g_obs_hfed_tb,g_joint_hfed_tb,
        total_gap_fed_tb,d_alc_fed_tb,d_smk_fed_tb,d_act_fed_tb,d_obs_fed_tb,residual_fed_tb,
        alc_cont_fedb,alc_cont_fed_tb,smk_cont_fedb,smk_cont_fed_tb,act_cont_fedb,act_cont_fed_tb,obs_cont_fedb,obs_cont_fed_tb,joint_cont_fedb,joint_cont_fed_tb)
}
## Bootstrap results female
bootresults_feb <- dtms_boot(data=estdata_w,
                            dtms=simple,
                            fun=bootfun_feb,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_feb)
save(bootresults_feb,file="Results-bootstrap-febc-10000.Rda")

## Print estimates
s0_medb
a1_medb
a2_medb
a3_medb
a4_medb
aj_medb
b1_medb
b2_medb
b3_medb
b4_medb
bj_medb
sfinal_medb
g_alc_lmedb
g_smk_lmedb
g_act_lmedb
g_obs_lmedb
g_joint_lmedb
g_alc_hmedb
g_smk_hmedb
g_act_hmedb
g_obs_hmedb
g_joint_hmedb
total_gap_medb
d_alc_medb
d_smk_medb
d_act_medb
d_obs_medb
residual_medb
g_alc_lmed_tb
g_smk_lmed_tb
g_act_lmed_tb
g_obs_lmed_tb
g_joint_lmed_tb
g_alc_hmed_tb
g_smk_hmed_tb
g_act_hmed_tb
g_obs_hmed_tb
g_joint_hmed_tb
total_gap_med_tb
d_alc_med_tb
d_smk_med_tb
d_act_med_tb
d_obs_med_tb
residual_med_tb
alc_cont_medb
alc_cont_med_tb
smk_cont_medb
smk_cont_med_tb
act_cont_medb
act_cont_med_tb
obs_cont_medb
obs_cont_med_tb
joint_cont_medb
joint_cont_med_tb

s0_fedb
a1_fedb
a2_fedb
a3_fedb
a4_fedb
aj_fedb
b1_fedb
b2_fedb
b3_fedb
b4_fedb
bj_fedb
sfinal_fedb
g_alc_lfedb
g_smk_lfedb
g_act_lfedb
g_obs_lfedb
g_joint_lfedb
g_alc_hfedb
g_smk_hfedb
g_act_hfedb
g_obs_hfedb
g_joint_hfedb
total_gap_fedb
d_alc_fedb
d_smk_fedb
d_act_fedb
d_obs_fedb
residual_fedb
g_alc_lfed_tb
g_smk_lfed_tb
g_act_lfed_tb
g_obs_lfed_tb
g_joint_lfed_tb
g_alc_hfed_tb
g_smk_hfed_tb
g_act_hfed_tb
g_obs_hfed_tb
g_joint_hfed_tb
total_gap_fed_tb
d_alc_fed_tb
d_smk_fed_tb
d_act_fed_tb
d_obs_fed_tb
residual_fed_tb
alc_cont_fedb
alc_cont_fed_tb
smk_cont_fedb
smk_cont_fed_tb
act_cont_fedb
act_cont_fed_tb
obs_cont_fedb
obs_cont_fed_tb
joint_cont_fedb
joint_cont_fed_tb
