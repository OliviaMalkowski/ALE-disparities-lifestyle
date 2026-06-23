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

## Fit men unadjusted
fit_m0e <- dtms_fit(data=estdata_m,
                  formula=to~from+time+I(time^2)+edu_cons_bi)

## Fit women unadjusted
fit_w0e <- dtms_fit(data=estdata_w,
                  formula=to~from+time+I(time^2)+edu_cons_bi)

## Fit men adjusted
fit_me <- dtms_fit(data=estdata_m,
                  formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+edu_cons_bi
                  +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Fit women adjusted
fit_we <- dtms_fit(data=estdata_w,
                  formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+edu_cons_bi
                  +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_m <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_m
alc_mled <- mean(estdata_m$alc_cons[estdata_m$edu_cons_bi==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mled 
alc_mhed <- mean(estdata_m$alc_cons[estdata_m$edu_cons_bi==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhed

## Time-varying variables
model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=estdata_m)
cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
model_smok_med <- glm(last_nm_smok ~ (time+I(time^2))*edu_cons_bi,data=estdata_m, family=binomial)
smok_controls_mled <- predict(model_smok_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
smok_controls_mhed <- predict(model_smok_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
model_pa_med <- glm(last_nm_pa ~ (time+I(time^2))*edu_cons_bi,data=estdata_m, family=binomial)
pa_controls_mled <- predict(model_pa_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
pa_controls_mhed <- predict(model_pa_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
model_ob_med <- glm(last_nm_ob ~ (time+I(time^2))*edu_cons_bi,data=estdata_m, family=binomial)
ob_controls_mled <- predict(model_ob_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
ob_controls_mhed <- predict(model_ob_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")

## Female
## Time-constant variables
eth_gm_f <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_f
alc_fled <- mean(estdata_w$alc_cons[estdata_w$edu_cons_bi==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fled 
alc_fhed <- mean(estdata_w$alc_cons[estdata_w$edu_cons_bi==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhed

## Time-varying variables
model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=estdata_w)
cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
model_smok_fed <- glm(last_nm_smok ~ (time+I(time^2))*edu_cons_bi,data=estdata_w, family=binomial)
smok_controls_fled <- predict(model_smok_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
smok_controls_fhed <- predict(model_smok_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
model_pa_fed <- glm(last_nm_pa ~ (time+I(time^2))*edu_cons_bi,data=estdata_w, family=binomial)
pa_controls_fled <- predict(model_pa_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
pa_controls_fhed <- predict(model_pa_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
model_ob_fed <- glm(last_nm_ob ~ (time+I(time^2))*edu_cons_bi,data=estdata_w, family=binomial)
ob_controls_fled <- predict(model_ob_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
ob_controls_fhed <- predict(model_ob_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")

## Elimination scenario(s)
smok_elimination <- rep(0,times=480)
pa_elimination <- rep(0,times=480)
ob_elimination <- rep(0,times=480)

## Predict probabilities ##############################################

## Unadjusted analyses lower SES male
unadjusted_lmed <- dtms_transitions(dtms=simple,
                                 model=fit_m0e,
                                 controls=list(time=840:1319, edu_cons_bi=0),
                                 ci=TRUE)

## Unadjusted analyses higher SES male
unadjusted_hmed <- dtms_transitions(dtms=simple,
                                 model=fit_m0e,
                                 controls=list(time=840:1319, edu_cons_bi=1),
                                 ci=TRUE)

## Unadjusted analyses lower SES female
unadjusted_lfed <- dtms_transitions(dtms=simple,
                                    model=fit_w0e,
                                    controls=list(time=840:1319, edu_cons_bi=0),
                                    ci=TRUE)

## Unadjusted analyses higher SES female
unadjusted_hfed <- dtms_transitions(dtms=simple,
                                    model=fit_w0e,
                                    controls=list(time=840:1319, edu_cons_bi=1),
                                    ci=TRUE)

## Reference scenario lower SES male
prob_s0_lmed <- dtms_transitions(dtms=simple,
                              model=fit_me,
                              controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                            edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                            last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                              ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_med <- dtms_transitions(dtms=simple,
                                 model=fit_me,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_controls_mled, 
                                               last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                                 ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_med <- dtms_transitions(dtms=simple,
                                 model=fit_me,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_elimination, 
                                               last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                                 ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_med <- dtms_transitions(dtms=simple,
                                 model=fit_me,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                               last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mled),
                                 ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_med <- dtms_transitions(dtms=simple,
                                 model=fit_me,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                               last_nm_pa=pa_controls_mled, last_nm_ob=ob_elimination),
                                 ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_med <- dtms_transitions(dtms=simple,
                                 model=fit_me,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                               last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                 ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_med <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_controls_mhed, 
                                              last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_med <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_med <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhed),
                                ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_med <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                              last_nm_pa=pa_controls_mhed, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_med <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hmed <- dtms_transitions(dtms=simple,
                                model=fit_me,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                              last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfed <- dtms_transitions(dtms=simple,
                                 model=fit_we,
                                 controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                               edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                               last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_controls_fled, 
                                              last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fled),
                                ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                              last_nm_pa=pa_controls_fled, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_controls_fhed, 
                                              last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
                                ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
                                ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhed),
                                ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                              last_nm_pa=pa_controls_fhed, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_fed <- dtms_transitions(dtms=simple,
                                model=fit_we,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfed <- dtms_transitions(dtms=simple,
                                     model=fit_we,
                                     controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                   edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                                   last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
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

## Unadjusted analyses lower SES male
un_mled <- dtms_expectancy(probs=unadjusted_lmed,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES male
un_mhed <- dtms_expectancy(probs=unadjusted_hmed,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses lower SES female
un_fled <- dtms_expectancy(probs=unadjusted_lfed,start_distr=Sw,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES female
un_fhed <- dtms_expectancy(probs=unadjusted_hfed,start_distr=Sw,dtms=simple,start_state=limited)

## Reference scenario lower SES male
s0_med <- dtms_expectancy(probs=prob_s0_lmed,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_med <- dtms_expectancy(probs=prob_a1_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_med <- dtms_expectancy(probs=prob_a2_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_med <- dtms_expectancy(probs=prob_a3_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_med <- dtms_expectancy(probs=prob_a4_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_med <- dtms_expectancy(probs=prob_aj_med,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_med <- dtms_expectancy(probs=prob_b1_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_med <- dtms_expectancy(probs=prob_b2_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_med <- dtms_expectancy(probs=prob_b3_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_med <- dtms_expectancy(probs=prob_b4_med,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_med <- dtms_expectancy(probs=prob_bj_med,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_med <- dtms_expectancy(probs=prob_sfinal_hmed,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_fed <- dtms_expectancy(probs=prob_s0_lfed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_fed <- dtms_expectancy(probs=prob_a1_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_fed <- dtms_expectancy(probs=prob_a2_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_fed <- dtms_expectancy(probs=prob_a3_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_fed <- dtms_expectancy(probs=prob_a4_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_fed <- dtms_expectancy(probs=prob_aj_fed,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_fed <- dtms_expectancy(probs=prob_b1_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_fed <- dtms_expectancy(probs=prob_b2_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_fed <- dtms_expectancy(probs=prob_b3_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_fed <- dtms_expectancy(probs=prob_b4_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_fed <- dtms_expectancy(probs=prob_bj_fed,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_fed <- dtms_expectancy(probs=prob_sfinal_hfed,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmed <- a1_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
g_smk_lmed <- a2_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
g_act_lmed <- a3_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
g_obs_lmed <- a4_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmed <- aj_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmed <- b1_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
g_smk_hmed <- b2_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
g_act_hmed <- b3_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
g_obs_hmed <- b4_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmed <- bj_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_med <- un_mhed["start:Nondisabled_840","Nondisabled"] - un_mled["start:Nondisabled_840","Nondisabled"]
total_gap_med <- sfinal_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_med <- b1_med["start:Nondisabled_840","Nondisabled"] - a1_med["start:Nondisabled_840","Nondisabled"]
d_smk_med <- b2_med["start:Nondisabled_840","Nondisabled"] - a2_med["start:Nondisabled_840","Nondisabled"]
d_act_med <- b3_med["start:Nondisabled_840","Nondisabled"] - a3_med["start:Nondisabled_840","Nondisabled"]
d_obs_med <- b4_med["start:Nondisabled_840","Nondisabled"] - a4_med["start:Nondisabled_840","Nondisabled"]
residual_med <- bj_med["start:Nondisabled_840","Nondisabled"] - aj_med["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmed_t <- a1_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
g_smk_lmed_t <- a2_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
g_act_lmed_t <- a3_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
g_obs_lmed_t <- a4_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmed_t <- aj_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmed_t <- b1_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
g_smk_hmed_t <- b2_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
g_act_hmed_t <- b3_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
g_obs_hmed_t <- b4_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmed_t <- bj_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_med_t <- un_mhed["start:Nondisabled_840","TOTAL"] - un_mled["start:Nondisabled_840","TOTAL"]
total_gap_med_t <- sfinal_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_med_t <- b1_med["start:Nondisabled_840","TOTAL"] - a1_med["start:Nondisabled_840","TOTAL"]
d_smk_med_t <- b2_med["start:Nondisabled_840","TOTAL"] - a2_med["start:Nondisabled_840","TOTAL"]
d_act_med_t <- b3_med["start:Nondisabled_840","TOTAL"] - a3_med["start:Nondisabled_840","TOTAL"]
d_obs_med_t <- b4_med["start:Nondisabled_840","TOTAL"] - a4_med["start:Nondisabled_840","TOTAL"]
residual_med_t <- bj_med["start:Nondisabled_840","TOTAL"] - aj_med["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES male)
prop_ale_mled <- (un_mled["start:Nondisabled_840","Nondisabled"]/un_mled["start:Nondisabled_840","TOTAL"])*100
prop_ale_mhed <- (un_mhed["start:Nondisabled_840","Nondisabled"]/un_mhed["start:Nondisabled_840","TOTAL"])*100
prop_dif_med <- prop_ale_mhed - prop_ale_mled

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_med <- ((total_gap_med - d_alc_med)/total_gap_med)*100
alc_cont_med_t <- ((total_gap_med_t - d_alc_med_t)/total_gap_med_t)*100
smk_cont_med <- ((total_gap_med - d_smk_med)/total_gap_med)*100
smk_cont_med_t <- ((total_gap_med_t - d_smk_med_t)/total_gap_med_t)*100
act_cont_med <- ((total_gap_med - d_act_med)/total_gap_med)*100
act_cont_med_t <- ((total_gap_med_t - d_act_med_t)/total_gap_med_t)*100
obs_cont_med <- ((total_gap_med - d_obs_med)/total_gap_med)*100
obs_cont_med_t <- ((total_gap_med_t - d_obs_med_t)/total_gap_med_t)*100
joint_cont_med <- ((total_gap_med - residual_med)/total_gap_med)*100
joint_cont_med_t <- ((total_gap_med_t - residual_med_t)/total_gap_med_t)*100

## Bootstrap function male
bootfun_me <- function(data,dtms) {
  fit_m0e <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+edu_cons_bi)
  fit_me <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+edu_cons_bi
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_m <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_mled <- mean(data$alc_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhed <- mean(data$alc_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
  model_smok_med <- glm(last_nm_smok ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  smok_controls_mled <- predict(model_smok_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  smok_controls_mhed <- predict(model_smok_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  model_pa_med <- glm(last_nm_pa ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  pa_controls_mled <- predict(model_pa_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  pa_controls_mhed <- predict(model_pa_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  model_ob_med <- glm(last_nm_ob ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  ob_controls_mled <- predict(model_ob_med,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  ob_controls_mhed <- predict(model_ob_med,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lmed <- dtms_transitions(dtms=dtms,
                                      model=fit_m0e,
                                      controls=list(time=840:1319, edu_cons_bi=0),
                                      ci=TRUE)
  unadjusted_hmed <- dtms_transitions(dtms=dtms,
                                      model=fit_m0e,
                                      controls=list(time=840:1319, edu_cons_bi=1),
                                      ci=TRUE)
  prob_s0_lmed <- dtms_transitions(dtms=dtms,
                                   model=fit_me,
                                   controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                 edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                                 last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                                   ci=TRUE)
  prob_a1_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_controls_mled, 
                                                last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                                  ci=TRUE)
  prob_a2_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mled, last_nm_ob=ob_controls_mled),
                                  ci=TRUE)
  prob_a3_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mled),
                                  ci=TRUE)
  prob_a4_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=0, alc_cons=alc_mled, last_nm_smok=smok_controls_mled, 
                                                last_nm_pa=pa_controls_mled, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_controls_mhed, 
                                                last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                  ci=TRUE)
  prob_b2_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                  ci=TRUE)
  prob_b3_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhed),
                                  ci=TRUE)
  prob_b4_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                                last_nm_pa=pa_controls_mhed, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_med <- dtms_transitions(dtms=dtms,
                                  model=fit_me,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hmed <- dtms_transitions(dtms=dtms,
                                       model=fit_me,
                                       controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                     edu_cons_bi=1, alc_cons=alc_mhed, last_nm_smok=smok_controls_mhed, 
                                                     last_nm_pa=pa_controls_mhed, last_nm_ob=ob_controls_mhed),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_mled <- dtms_expectancy(probs=unadjusted_lmed,start_distr=Sm,dtms=dtms,start_state=limited)
  un_mhed <- dtms_expectancy(probs=unadjusted_hmed,start_distr=Sm,dtms=dtms,start_state=limited)
  s0_med <- dtms_expectancy(probs=prob_s0_lmed,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_med <- dtms_expectancy(probs=prob_a1_med,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_med <- dtms_expectancy(probs=prob_a2_med,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_med <- dtms_expectancy(probs=prob_a3_med,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_med <- dtms_expectancy(probs=prob_a4_med,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_med <- dtms_expectancy(probs=prob_aj_med,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_med <- dtms_expectancy(probs=prob_b1_med,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_med <- dtms_expectancy(probs=prob_b2_med,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_med <- dtms_expectancy(probs=prob_b3_med,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_med <- dtms_expectancy(probs=prob_b4_med,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_med <- dtms_expectancy(probs=prob_bj_med,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_med <- dtms_expectancy(probs=prob_sfinal_hmed,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lmed <- a1_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  g_smk_lmed <- a2_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  g_act_lmed <- a3_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  g_obs_lmed <- a4_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  g_joint_lmed <- aj_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  g_alc_hmed <- b1_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
  g_smk_hmed <- b2_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
  g_act_hmed <- b3_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
  g_obs_hmed <- b4_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
  g_joint_hmed <- bj_med["start:Nondisabled_840","Nondisabled"] - sfinal_med["start:Nondisabled_840","Nondisabled"]
  un_total_gap_med <- un_mhed["start:Nondisabled_840","Nondisabled"] - un_mled["start:Nondisabled_840","Nondisabled"]
  total_gap_med <- sfinal_med["start:Nondisabled_840","Nondisabled"] - s0_med["start:Nondisabled_840","Nondisabled"]
  d_alc_med <- b1_med["start:Nondisabled_840","Nondisabled"] - a1_med["start:Nondisabled_840","Nondisabled"]
  d_smk_med <- b2_med["start:Nondisabled_840","Nondisabled"] - a2_med["start:Nondisabled_840","Nondisabled"]
  d_act_med <- b3_med["start:Nondisabled_840","Nondisabled"] - a3_med["start:Nondisabled_840","Nondisabled"]
  d_obs_med <- b4_med["start:Nondisabled_840","Nondisabled"] - a4_med["start:Nondisabled_840","Nondisabled"]
  residual_med <- bj_med["start:Nondisabled_840","Nondisabled"] - aj_med["start:Nondisabled_840","Nondisabled"]
  g_alc_lmed_t <- a1_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  g_smk_lmed_t <- a2_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  g_act_lmed_t <- a3_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  g_obs_lmed_t <- a4_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  g_joint_lmed_t <- aj_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  g_alc_hmed_t <- b1_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
  g_smk_hmed_t <- b2_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
  g_act_hmed_t <- b3_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
  g_obs_hmed_t <- b4_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
  g_joint_hmed_t <- bj_med["start:Nondisabled_840","TOTAL"] - sfinal_med["start:Nondisabled_840","TOTAL"]
  un_total_gap_med_t <- un_mhed["start:Nondisabled_840","TOTAL"] - un_mled["start:Nondisabled_840","TOTAL"]
  total_gap_med_t <- sfinal_med["start:Nondisabled_840","TOTAL"] - s0_med["start:Nondisabled_840","TOTAL"]
  d_alc_med_t <- b1_med["start:Nondisabled_840","TOTAL"] - a1_med["start:Nondisabled_840","TOTAL"]
  d_smk_med_t <- b2_med["start:Nondisabled_840","TOTAL"] - a2_med["start:Nondisabled_840","TOTAL"]
  d_act_med_t <- b3_med["start:Nondisabled_840","TOTAL"] - a3_med["start:Nondisabled_840","TOTAL"]
  d_obs_med_t <- b4_med["start:Nondisabled_840","TOTAL"] - a4_med["start:Nondisabled_840","TOTAL"]
  residual_med_t <- bj_med["start:Nondisabled_840","TOTAL"] - aj_med["start:Nondisabled_840","TOTAL"]
  prop_ale_mled <- (un_mled["start:Nondisabled_840","Nondisabled"]/un_mled["start:Nondisabled_840","TOTAL"])*100
  prop_ale_mhed <- (un_mhed["start:Nondisabled_840","Nondisabled"]/un_mhed["start:Nondisabled_840","TOTAL"])*100
  prop_dif_med <- prop_ale_mhed - prop_ale_mled
  alc_cont_med <- ((total_gap_med - d_alc_med)/total_gap_med)*100
  alc_cont_med_t <- ((total_gap_med_t - d_alc_med_t)/total_gap_med_t)*100
  smk_cont_med <- ((total_gap_med - d_smk_med)/total_gap_med)*100
  smk_cont_med_t <- ((total_gap_med_t - d_smk_med_t)/total_gap_med_t)*100
  act_cont_med <- ((total_gap_med - d_act_med)/total_gap_med)*100
  act_cont_med_t <- ((total_gap_med_t - d_act_med_t)/total_gap_med_t)*100
  obs_cont_med <- ((total_gap_med - d_obs_med)/total_gap_med)*100
  obs_cont_med_t <- ((total_gap_med_t - d_obs_med_t)/total_gap_med_t)*100
  joint_cont_med <- ((total_gap_med - residual_med)/total_gap_med)*100
  joint_cont_med_t <- ((total_gap_med_t - residual_med_t)/total_gap_med_t)*100
  rbind(un_mled,un_mhed,s0_med,a1_med,a2_med,a3_med,a4_med,aj_med,b1_med,b2_med,b3_med,b4_med,bj_med,sfinal_med,
        g_alc_lmed,g_smk_lmed,g_act_lmed,g_obs_lmed,g_joint_lmed,
        g_alc_hmed,g_smk_hmed,g_act_hmed,g_obs_hmed,g_joint_hmed,
        un_total_gap_med,total_gap_med,d_alc_med,d_smk_med,d_act_med,d_obs_med,residual_med,
        g_alc_lmed_t,g_smk_lmed_t,g_act_lmed_t,g_obs_lmed_t,g_joint_lmed_t,
        g_alc_hmed_t,g_smk_hmed_t,g_act_hmed_t,g_obs_hmed_t,g_joint_hmed_t,
        un_total_gap_med_t,total_gap_med_t,d_alc_med_t,d_smk_med_t,d_act_med_t,d_obs_med_t,residual_med_t,
        prop_ale_mled,prop_ale_mhed,prop_dif_med,
        alc_cont_med,alc_cont_med_t,smk_cont_med,smk_cont_med_t,act_cont_med,act_cont_med_t,obs_cont_med,obs_cont_med_t,joint_cont_med,joint_cont_med_t)
}
## Bootstrap results male
bootresults_me <- dtms_boot(data=estdata_m,
                         dtms=simple,
                         fun=bootfun_me,
                         idvar="id",
                         rep=10000,
                         method="block",
                         parallel=TRUE,
                         cores=3)
summary(bootresults_me)
save(bootresults_me,file="Results-bootstrap-me4bc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfed <- a1_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
g_smk_lfed <- a2_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
g_act_lfed <- a3_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
g_obs_lfed <- a4_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfed <- aj_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfed <- b1_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
g_smk_hfed <- b2_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
g_act_hfed <- b3_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
g_obs_hfed <- b4_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfed <- bj_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fed <- un_fhed["start:Nondisabled_840","Nondisabled"] - un_fled["start:Nondisabled_840","Nondisabled"]
total_gap_fed <- sfinal_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fed <- b1_fed["start:Nondisabled_840","Nondisabled"] - a1_fed["start:Nondisabled_840","Nondisabled"]
d_smk_fed <- b2_fed["start:Nondisabled_840","Nondisabled"] - a2_fed["start:Nondisabled_840","Nondisabled"]
d_act_fed <- b3_fed["start:Nondisabled_840","Nondisabled"] - a3_fed["start:Nondisabled_840","Nondisabled"]
d_obs_fed <- b4_fed["start:Nondisabled_840","Nondisabled"] - a4_fed["start:Nondisabled_840","Nondisabled"]
residual_fed <- bj_fed["start:Nondisabled_840","Nondisabled"] - aj_fed["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfed_t <- a1_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
g_smk_lfed_t <- a2_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
g_act_lfed_t <- a3_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
g_obs_lfed_t <- a4_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfed_t <- aj_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfed_t <- b1_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
g_smk_hfed_t <- b2_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
g_act_hfed_t <- b3_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
g_obs_hfed_t <- b4_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfed_t <- bj_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fed_t <- un_fhed["start:Nondisabled_840","TOTAL"] - un_fled["start:Nondisabled_840","TOTAL"]
total_gap_fed_t <- sfinal_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fed_t <- b1_fed["start:Nondisabled_840","TOTAL"] - a1_fed["start:Nondisabled_840","TOTAL"]
d_smk_fed_t <- b2_fed["start:Nondisabled_840","TOTAL"] - a2_fed["start:Nondisabled_840","TOTAL"]
d_act_fed_t <- b3_fed["start:Nondisabled_840","TOTAL"] - a3_fed["start:Nondisabled_840","TOTAL"]
d_obs_fed_t <- b4_fed["start:Nondisabled_840","TOTAL"] - a4_fed["start:Nondisabled_840","TOTAL"]
residual_fed_t <- bj_fed["start:Nondisabled_840","TOTAL"] - aj_fed["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES female)
prop_ale_fled <- (un_fled["start:Nondisabled_840","Nondisabled"]/un_fled["start:Nondisabled_840","TOTAL"])*100
prop_ale_fhed <- (un_fhed["start:Nondisabled_840","Nondisabled"]/un_fhed["start:Nondisabled_840","TOTAL"])*100
prop_dif_fed <- prop_ale_fhed - prop_ale_fled

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_fed <- ((total_gap_fed - d_alc_fed)/total_gap_fed)*100
alc_cont_fed_t <- ((total_gap_fed_t - d_alc_fed_t)/total_gap_fed_t)*100
smk_cont_fed <- ((total_gap_fed - d_smk_fed)/total_gap_fed)*100
smk_cont_fed_t <- ((total_gap_fed_t - d_smk_fed_t)/total_gap_fed_t)*100
act_cont_fed <- ((total_gap_fed - d_act_fed)/total_gap_fed)*100
act_cont_fed_t <- ((total_gap_fed_t - d_act_fed_t)/total_gap_fed_t)*100
obs_cont_fed <- ((total_gap_fed - d_obs_fed)/total_gap_fed)*100
obs_cont_fed_t <- ((total_gap_fed_t - d_obs_fed_t)/total_gap_fed_t)*100
joint_cont_fed <- ((total_gap_fed - residual_fed)/total_gap_fed)*100
joint_cont_fed_t <- ((total_gap_fed_t - residual_fed_t)/total_gap_fed_t)*100

## Bootstrap function female
bootfun_fe <- function(data,dtms) {
  fit_w0e <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+edu_cons_bi)
  fit_we <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+edu_cons_bi
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_f <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_fled <- mean(data$alc_cons[data$edu_cons_bi==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhed <- mean(data$alc_cons[data$edu_cons_bi==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
  model_smok_fed <- glm(last_nm_smok ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  smok_controls_fled <- predict(model_smok_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  smok_controls_fhed <- predict(model_smok_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  model_pa_fed <- glm(last_nm_pa ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  pa_controls_fled <- predict(model_pa_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  pa_controls_fhed <- predict(model_pa_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  model_ob_fed <- glm(last_nm_ob ~ (time+I(time^2))*edu_cons_bi,data=data, family=binomial)
  ob_controls_fled <- predict(model_ob_fed,newdata=data.frame(time=840:1319,edu_cons_bi=0),type="response")
  ob_controls_fhed <- predict(model_ob_fed,newdata=data.frame(time=840:1319,edu_cons_bi=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lfed <- dtms_transitions(dtms=dtms,
                                      model=fit_w0e,
                                      controls=list(time=840:1319, edu_cons_bi=0),
                                      ci=TRUE)
  unadjusted_hfed <- dtms_transitions(dtms=dtms,
                                      model=fit_w0e,
                                      controls=list(time=840:1319, edu_cons_bi=1),
                                      ci=TRUE)
  prob_s0_lfed <- dtms_transitions(dtms=dtms,
                                   model=fit_we,
                                   controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                 edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                                 last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                   ci=TRUE)
  prob_a1_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_controls_fled, 
                                                last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                  ci=TRUE)
  prob_a2_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_fled, last_nm_ob=ob_controls_fled),
                                  ci=TRUE)
  prob_a3_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fled),
                                  ci=TRUE)
  prob_a4_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=0, alc_cons=alc_fled, last_nm_smok=smok_controls_fled, 
                                                last_nm_pa=pa_controls_fled, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_controls_fhed, 
                                                last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
                                  ci=TRUE)
  prob_b2_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
                                  ci=TRUE)
  prob_b3_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhed),
                                  ci=TRUE)
  prob_b4_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                                last_nm_pa=pa_controls_fhed, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_fed <- dtms_transitions(dtms=dtms,
                                  model=fit_we,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                edu_cons_bi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hfed <- dtms_transitions(dtms=dtms,
                                       model=fit_we,
                                       controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                     edu_cons_bi=1, alc_cons=alc_fhed, last_nm_smok=smok_controls_fhed, 
                                                     last_nm_pa=pa_controls_fhed, last_nm_ob=ob_controls_fhed),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_fled <- dtms_expectancy(probs=unadjusted_lfed,start_distr=Sw,dtms=dtms,start_state=limited)
  un_fhed <- dtms_expectancy(probs=unadjusted_hfed,start_distr=Sw,dtms=dtms,start_state=limited)
  s0_fed <- dtms_expectancy(probs=prob_s0_lfed,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_fed <- dtms_expectancy(probs=prob_a1_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_fed <- dtms_expectancy(probs=prob_a2_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_fed <- dtms_expectancy(probs=prob_a3_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_fed <- dtms_expectancy(probs=prob_a4_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_fed <- dtms_expectancy(probs=prob_aj_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_fed <- dtms_expectancy(probs=prob_b1_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_fed <- dtms_expectancy(probs=prob_b2_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_fed <- dtms_expectancy(probs=prob_b3_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_fed <- dtms_expectancy(probs=prob_b4_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_fed <- dtms_expectancy(probs=prob_bj_fed,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_fed <- dtms_expectancy(probs=prob_sfinal_hfed,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfed <- a1_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  g_smk_lfed <- a2_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  g_act_lfed <- a3_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  g_obs_lfed <- a4_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  g_joint_lfed <- aj_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  g_alc_hfed <- b1_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
  g_smk_hfed <- b2_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
  g_act_hfed <- b3_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
  g_obs_hfed <- b4_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
  g_joint_hfed <- bj_fed["start:Nondisabled_840","Nondisabled"] - sfinal_fed["start:Nondisabled_840","Nondisabled"]
  un_total_gap_fed <- un_fhed["start:Nondisabled_840","Nondisabled"] - un_fled["start:Nondisabled_840","Nondisabled"]
  total_gap_fed <- sfinal_fed["start:Nondisabled_840","Nondisabled"] - s0_fed["start:Nondisabled_840","Nondisabled"]
  d_alc_fed <- b1_fed["start:Nondisabled_840","Nondisabled"] - a1_fed["start:Nondisabled_840","Nondisabled"]
  d_smk_fed <- b2_fed["start:Nondisabled_840","Nondisabled"] - a2_fed["start:Nondisabled_840","Nondisabled"]
  d_act_fed <- b3_fed["start:Nondisabled_840","Nondisabled"] - a3_fed["start:Nondisabled_840","Nondisabled"]
  d_obs_fed <- b4_fed["start:Nondisabled_840","Nondisabled"] - a4_fed["start:Nondisabled_840","Nondisabled"]
  residual_fed <- bj_fed["start:Nondisabled_840","Nondisabled"] - aj_fed["start:Nondisabled_840","Nondisabled"]
  g_alc_lfed_t <- a1_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  g_smk_lfed_t <- a2_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  g_act_lfed_t <- a3_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  g_obs_lfed_t <- a4_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  g_joint_lfed_t <- aj_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  g_alc_hfed_t <- b1_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
  g_smk_hfed_t <- b2_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
  g_act_hfed_t <- b3_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
  g_obs_hfed_t <- b4_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
  g_joint_hfed_t <- bj_fed["start:Nondisabled_840","TOTAL"] - sfinal_fed["start:Nondisabled_840","TOTAL"]
  un_total_gap_fed_t <- un_fhed["start:Nondisabled_840","TOTAL"] - un_fled["start:Nondisabled_840","TOTAL"]
  total_gap_fed_t <- sfinal_fed["start:Nondisabled_840","TOTAL"] - s0_fed["start:Nondisabled_840","TOTAL"]
  d_alc_fed_t <- b1_fed["start:Nondisabled_840","TOTAL"] - a1_fed["start:Nondisabled_840","TOTAL"]
  d_smk_fed_t <- b2_fed["start:Nondisabled_840","TOTAL"] - a2_fed["start:Nondisabled_840","TOTAL"]
  d_act_fed_t <- b3_fed["start:Nondisabled_840","TOTAL"] - a3_fed["start:Nondisabled_840","TOTAL"]
  d_obs_fed_t <- b4_fed["start:Nondisabled_840","TOTAL"] - a4_fed["start:Nondisabled_840","TOTAL"]
  residual_fed_t <- bj_fed["start:Nondisabled_840","TOTAL"] - aj_fed["start:Nondisabled_840","TOTAL"]
  prop_ale_fled <- (un_fled["start:Nondisabled_840","Nondisabled"]/un_fled["start:Nondisabled_840","TOTAL"])*100
  prop_ale_fhed <- (un_fhed["start:Nondisabled_840","Nondisabled"]/un_fhed["start:Nondisabled_840","TOTAL"])*100
  prop_dif_fed <- prop_ale_fhed - prop_ale_fled
  alc_cont_fed <- ((total_gap_fed - d_alc_fed)/total_gap_fed)*100
  alc_cont_fed_t <- ((total_gap_fed_t - d_alc_fed_t)/total_gap_fed_t)*100
  smk_cont_fed <- ((total_gap_fed - d_smk_fed)/total_gap_fed)*100
  smk_cont_fed_t <- ((total_gap_fed_t - d_smk_fed_t)/total_gap_fed_t)*100
  act_cont_fed <- ((total_gap_fed - d_act_fed)/total_gap_fed)*100
  act_cont_fed_t <- ((total_gap_fed_t - d_act_fed_t)/total_gap_fed_t)*100
  obs_cont_fed <- ((total_gap_fed - d_obs_fed)/total_gap_fed)*100
  obs_cont_fed_t <- ((total_gap_fed_t - d_obs_fed_t)/total_gap_fed_t)*100
  joint_cont_fed <- ((total_gap_fed - residual_fed)/total_gap_fed)*100
  joint_cont_fed_t <- ((total_gap_fed_t - residual_fed_t)/total_gap_fed_t)*100
  rbind(un_fled,un_fhed,s0_fed,a1_fed,a2_fed,a3_fed,a4_fed,aj_fed,b1_fed,b2_fed,b3_fed,b4_fed,bj_fed,sfinal_fed,
        g_alc_lfed,g_smk_lfed,g_act_lfed,g_obs_lfed,g_joint_lfed,
        g_alc_hfed,g_smk_hfed,g_act_hfed,g_obs_hfed,g_joint_hfed,
        un_total_gap_fed,total_gap_fed,d_alc_fed,d_smk_fed,d_act_fed,d_obs_fed,residual_fed,
        g_alc_lfed_t,g_smk_lfed_t,g_act_lfed_t,g_obs_lfed_t,g_joint_lfed_t,
        g_alc_hfed_t,g_smk_hfed_t,g_act_hfed_t,g_obs_hfed_t,g_joint_hfed_t,
        un_total_gap_fed_t,total_gap_fed_t,d_alc_fed_t,d_smk_fed_t,d_act_fed_t,d_obs_fed_t,residual_fed_t,
        prop_ale_fled,prop_ale_fhed,prop_dif_fed,
        alc_cont_fed,alc_cont_fed_t,smk_cont_fed,smk_cont_fed_t,act_cont_fed,act_cont_fed_t,obs_cont_fed,obs_cont_fed_t,joint_cont_fed,joint_cont_fed_t)
}
## Bootstrap results female
bootresults_fe <- dtms_boot(data=estdata_w,
                            dtms=simple,
                            fun=bootfun_fe,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_fe)
save(bootresults_fe,file="Results-bootstrap-fe4bc-10000.Rda")

## Print estimates
un_mled
un_mhed
s0_med
a1_med
a2_med
a3_med
a4_med
aj_med
b1_med
b2_med
b3_med
b4_med
bj_med
sfinal_med
g_alc_lmed
g_smk_lmed
g_act_lmed
g_obs_lmed
g_joint_lmed
g_alc_hmed
g_smk_hmed
g_act_hmed
g_obs_hmed
g_joint_hmed
un_total_gap_med
total_gap_med
d_alc_med
d_smk_med
d_act_med
d_obs_med
residual_med
g_alc_lmed_t
g_smk_lmed_t
g_act_lmed_t
g_obs_lmed_t
g_joint_lmed_t
g_alc_hmed_t
g_smk_hmed_t
g_act_hmed_t
g_obs_hmed_t
g_joint_hmed_t
un_total_gap_med_t
total_gap_med_t
d_alc_med_t
d_smk_med_t
d_act_med_t
d_obs_med_t
residual_med_t
prop_ale_mled
prop_ale_mhed
prop_dif_med
alc_cont_med
alc_cont_med_t
smk_cont_med
smk_cont_med_t
act_cont_med
act_cont_med_t
obs_cont_med
obs_cont_med_t
joint_cont_med
joint_cont_med_t

un_fled
un_fhed
s0_fed
a1_fed
a2_fed
a3_fed
a4_fed
aj_fed
b1_fed
b2_fed
b3_fed
b4_fed
bj_fed
sfinal_fed
g_alc_lfed
g_smk_lfed
g_act_lfed
g_obs_lfed
g_joint_lfed
g_alc_hfed
g_smk_hfed
g_act_hfed
g_obs_hfed
g_joint_hfed
un_total_gap_fed
total_gap_fed
d_alc_fed
d_smk_fed
d_act_fed
d_obs_fed
residual_fed
g_alc_lfed_t
g_smk_lfed_t
g_act_lfed_t
g_obs_lfed_t
g_joint_lfed_t
g_alc_hfed_t
g_smk_hfed_t
g_act_hfed_t
g_obs_hfed_t
g_joint_hfed_t
un_total_gap_fed_t
total_gap_fed_t
d_alc_fed_t
d_smk_fed_t
d_act_fed_t
d_obs_fed_t
residual_fed_t
prop_ale_fled
prop_ale_fhed
prop_dif_fed
alc_cont_fed
alc_cont_fed_t
smk_cont_fed
smk_cont_fed_t
act_cont_fed
act_cont_fed_t
obs_cont_fed
obs_cont_fed_t
joint_cont_fed
joint_cont_fed_t
