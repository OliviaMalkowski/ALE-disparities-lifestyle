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
fit_m0i <- dtms_fit(data=estdata_m,
                   formula=to~from+time+I(time^2)+inc_bimi)

## Fit women unadjusted
fit_w0i <- dtms_fit(data=estdata_w,
                   formula=to~from+time+I(time^2)+inc_bimi)

## Fit men adjusted
fit_mi <- dtms_fit(data=estdata_m,
                  formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+inc_bimi
                  +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Fit women adjusted
fit_wi <- dtms_fit(data=estdata_w,
                  formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+inc_bimi
                  +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_m <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_m
alc_mlin <- mean(estdata_m$alc_cons[estdata_m$inc_bimi==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mlin
alc_mhin <- mean(estdata_m$alc_cons[estdata_m$inc_bimi==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhin

## Time-varying variables
model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=estdata_m)
cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
model_smok_min <- glm(last_nm_smok ~ (time+I(time^2))*inc_bimi,data=estdata_m, family=binomial)
smok_controls_mlin <- predict(model_smok_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
smok_controls_mhin <- predict(model_smok_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
model_pa_min <- glm(last_nm_pa ~ (time+I(time^2))*inc_bimi,data=estdata_m, family=binomial)
pa_controls_mlin <- predict(model_pa_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
pa_controls_mhin <- predict(model_pa_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
model_ob_min <- glm(last_nm_ob ~ (time+I(time^2))*inc_bimi,data=estdata_m, family=binomial)
ob_controls_mlin <- predict(model_ob_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
ob_controls_mhin <- predict(model_ob_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")

## Female
## Time-constant variables
eth_gm_f <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_f 
alc_flin <- mean(estdata_w$alc_cons[estdata_w$inc_bimi==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_flin 
alc_fhin <- mean(estdata_w$alc_cons[estdata_w$inc_bimi==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhin

## Time-varying variables
model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=estdata_w)
cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
model_smok_fin <- glm(last_nm_smok ~ (time+I(time^2))*inc_bimi,data=estdata_w, family=binomial)
smok_controls_flin <- predict(model_smok_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
smok_controls_fhin <- predict(model_smok_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
model_pa_fin <- glm(last_nm_pa ~ (time+I(time^2))*inc_bimi,data=estdata_w, family=binomial)
pa_controls_flin <- predict(model_pa_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
pa_controls_fhin <- predict(model_pa_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
model_ob_fin <- glm(last_nm_ob ~ (time+I(time^2))*inc_bimi,data=estdata_w, family=binomial)
ob_controls_flin <- predict(model_ob_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
ob_controls_fhin <- predict(model_ob_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")

## Elimination scenario(s)
smok_elimination <- rep(0,times=480)
pa_elimination <- rep(0,times=480)
ob_elimination <- rep(0,times=480)

## Predict probabilities ##############################################

## Unadjusted analyses lower SES male
unadjusted_lmin <- dtms_transitions(dtms=simple,
                                    model=fit_m0i,
                                    controls=list(time=840:1319, inc_bimi=0),
                                    ci=TRUE)

## Unadjusted analyses higher SES male
unadjusted_hmin <- dtms_transitions(dtms=simple,
                                    model=fit_m0i,
                                    controls=list(time=840:1319, inc_bimi=1),
                                    ci=TRUE)

## Unadjusted analyses lower SES female
unadjusted_lfin <- dtms_transitions(dtms=simple,
                                    model=fit_w0i,
                                    controls=list(time=840:1319, inc_bimi=0),
                                    ci=TRUE)

## Unadjusted analyses higher SES female
unadjusted_hfin <- dtms_transitions(dtms=simple,
                                    model=fit_w0i,
                                    controls=list(time=840:1319, inc_bimi=1),
                                    ci=TRUE)

## Reference scenario lower SES male
prob_s0_lmin <- dtms_transitions(dtms=simple,
                                 model=fit_mi,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                               last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=0, alc_cons=0, last_nm_smok=smok_controls_mlin, 
                                              last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mlin),
                                ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                              last_nm_pa=pa_controls_mlin, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=1, alc_cons=0, last_nm_smok=smok_controls_mhin, 
                                              last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhin),
                                ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                              last_nm_pa=pa_controls_mhin, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_min <- dtms_transitions(dtms=simple,
                                model=fit_mi,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              inc_bimi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hmin <- dtms_transitions(dtms=simple,
                                     model=fit_mi,
                                     controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                   inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                                   last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                     ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfin <- dtms_transitions(dtms=simple,
                                 model=fit_wi,
                                 controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                               inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                               last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=0, alc_cons=0, last_nm_smok=smok_controls_flin, 
                                              last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_flin),
                                ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                              last_nm_pa=pa_controls_flin, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=1, alc_cons=0, last_nm_smok=smok_controls_fhin, 
                                              last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
                                ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
                                ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhin),
                                ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                              last_nm_pa=pa_controls_fhin, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_fin <- dtms_transitions(dtms=simple,
                                model=fit_wi,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              inc_bimi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfin <- dtms_transitions(dtms=simple,
                                     model=fit_wi,
                                     controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                   inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                                   last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
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
un_mlin <- dtms_expectancy(probs=unadjusted_lmin,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES male
un_mhin <- dtms_expectancy(probs=unadjusted_hmin,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses lower SES female
un_flin <- dtms_expectancy(probs=unadjusted_lfin,start_distr=Sw,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES female
un_fhin <- dtms_expectancy(probs=unadjusted_hfin,start_distr=Sw,dtms=simple,start_state=limited)

## Reference scenario lower SES male
s0_min <- dtms_expectancy(probs=prob_s0_lmin,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_min <- dtms_expectancy(probs=prob_a1_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_min <- dtms_expectancy(probs=prob_a2_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_min <- dtms_expectancy(probs=prob_a3_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_min <- dtms_expectancy(probs=prob_a4_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_min <- dtms_expectancy(probs=prob_aj_min,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_min <- dtms_expectancy(probs=prob_b1_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_min <- dtms_expectancy(probs=prob_b2_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_min <- dtms_expectancy(probs=prob_b3_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_min <- dtms_expectancy(probs=prob_b4_min,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_min <- dtms_expectancy(probs=prob_bj_min,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_min <- dtms_expectancy(probs=prob_sfinal_hmin,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_fin <- dtms_expectancy(probs=prob_s0_lfin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_fin <- dtms_expectancy(probs=prob_a1_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_fin <- dtms_expectancy(probs=prob_a2_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_fin <- dtms_expectancy(probs=prob_a3_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_fin <- dtms_expectancy(probs=prob_a4_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_fin <- dtms_expectancy(probs=prob_aj_fin,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_fin <- dtms_expectancy(probs=prob_b1_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_fin <- dtms_expectancy(probs=prob_b2_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_fin <- dtms_expectancy(probs=prob_b3_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_fin <- dtms_expectancy(probs=prob_b4_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_fin <- dtms_expectancy(probs=prob_bj_fin,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_fin <- dtms_expectancy(probs=prob_sfinal_hfin,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmin <- a1_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
g_smk_lmin <- a2_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
g_act_lmin <- a3_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
g_obs_lmin <- a4_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmin <- aj_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmin <- b1_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
g_smk_hmin <- b2_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
g_act_hmin <- b3_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
g_obs_hmin <- b4_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmin <- bj_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_min <- un_mhin["start:Nondisabled_840","Nondisabled"] - un_mlin["start:Nondisabled_840","Nondisabled"]
total_gap_min <- sfinal_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_min <- b1_min["start:Nondisabled_840","Nondisabled"] - a1_min["start:Nondisabled_840","Nondisabled"]
d_smk_min <- b2_min["start:Nondisabled_840","Nondisabled"] - a2_min["start:Nondisabled_840","Nondisabled"]
d_act_min <- b3_min["start:Nondisabled_840","Nondisabled"] - a3_min["start:Nondisabled_840","Nondisabled"]
d_obs_min <- b4_min["start:Nondisabled_840","Nondisabled"] - a4_min["start:Nondisabled_840","Nondisabled"]
residual_min <- bj_min["start:Nondisabled_840","Nondisabled"] - aj_min["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmin_t <- a1_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
g_smk_lmin_t <- a2_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
g_act_lmin_t <- a3_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
g_obs_lmin_t <- a4_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmin_t <- aj_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmin_t <- b1_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
g_smk_hmin_t <- b2_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
g_act_hmin_t <- b3_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
g_obs_hmin_t <- b4_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmin_t <- bj_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_min_t <- un_mhin["start:Nondisabled_840","TOTAL"] - un_mlin["start:Nondisabled_840","TOTAL"]
total_gap_min_t <- sfinal_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_min_t <- b1_min["start:Nondisabled_840","TOTAL"] - a1_min["start:Nondisabled_840","TOTAL"]
d_smk_min_t <- b2_min["start:Nondisabled_840","TOTAL"] - a2_min["start:Nondisabled_840","TOTAL"]
d_act_min_t <- b3_min["start:Nondisabled_840","TOTAL"] - a3_min["start:Nondisabled_840","TOTAL"]
d_obs_min_t <- b4_min["start:Nondisabled_840","TOTAL"] - a4_min["start:Nondisabled_840","TOTAL"]
residual_min_t <- bj_min["start:Nondisabled_840","TOTAL"] - aj_min["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES male)
prop_ale_mlin <- (un_mlin["start:Nondisabled_840","Nondisabled"]/un_mlin["start:Nondisabled_840","TOTAL"])*100
prop_ale_mhin <- (un_mhin["start:Nondisabled_840","Nondisabled"]/un_mhin["start:Nondisabled_840","TOTAL"])*100
prop_dif_min <- prop_ale_mhin - prop_ale_mlin

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_min <- ((total_gap_min - d_alc_min)/total_gap_min)*100
alc_cont_min_t <- ((total_gap_min_t - d_alc_min_t)/total_gap_min_t)*100
smk_cont_min <- ((total_gap_min - d_smk_min)/total_gap_min)*100
smk_cont_min_t <- ((total_gap_min_t - d_smk_min_t)/total_gap_min_t)*100
act_cont_min <- ((total_gap_min - d_act_min)/total_gap_min)*100
act_cont_min_t <- ((total_gap_min_t - d_act_min_t)/total_gap_min_t)*100
obs_cont_min <- ((total_gap_min - d_obs_min)/total_gap_min)*100
obs_cont_min_t <- ((total_gap_min_t - d_obs_min_t)/total_gap_min_t)*100
joint_cont_min <- ((total_gap_min - residual_min)/total_gap_min)*100
joint_cont_min_t <- ((total_gap_min_t - residual_min_t)/total_gap_min_t)*100

## Bootstrap function male
bootfun_mi <- function(data,dtms) {
  fit_m0i <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+inc_bimi)
  fit_mi <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+inc_bimi
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_m <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_mlin <- mean(data$alc_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhin <- mean(data$alc_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
  model_smok_min <- glm(last_nm_smok ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  smok_controls_mlin <- predict(model_smok_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  smok_controls_mhin <- predict(model_smok_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  model_pa_min <- glm(last_nm_pa ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  pa_controls_mlin <- predict(model_pa_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  pa_controls_mhin <- predict(model_pa_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  model_ob_min <- glm(last_nm_ob ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  ob_controls_mlin <- predict(model_ob_min,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  ob_controls_mhin <- predict(model_ob_min,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lmin <- dtms_transitions(dtms=dtms,
                                      model=fit_m0i,
                                      controls=list(time=840:1319, inc_bimi=0),
                                      ci=TRUE)
  unadjusted_hmin <- dtms_transitions(dtms=dtms,
                                      model=fit_m0i,
                                      controls=list(time=840:1319, inc_bimi=1),
                                      ci=TRUE)
  prob_s0_lmin <- dtms_transitions(dtms=dtms,
                                   model=fit_mi,
                                   controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                 inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                                 last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                   ci=TRUE)
  prob_a1_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=0, alc_cons=0, last_nm_smok=smok_controls_mlin, 
                                                last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                  ci=TRUE)
  prob_a2_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mlin, last_nm_ob=ob_controls_mlin),
                                  ci=TRUE)
  prob_a3_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mlin),
                                  ci=TRUE)
  prob_a4_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=0, alc_cons=alc_mlin, last_nm_smok=smok_controls_mlin, 
                                                last_nm_pa=pa_controls_mlin, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=1, alc_cons=0, last_nm_smok=smok_controls_mhin, 
                                                last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                  ci=TRUE)
  prob_b2_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                  ci=TRUE)
  prob_b3_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhin),
                                  ci=TRUE)
  prob_b4_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                                last_nm_pa=pa_controls_mhin, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_min <- dtms_transitions(dtms=dtms,
                                  model=fit_mi,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                inc_bimi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hmin <- dtms_transitions(dtms=dtms,
                                       model=fit_mi,
                                       controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                     inc_bimi=1, alc_cons=alc_mhin, last_nm_smok=smok_controls_mhin, 
                                                     last_nm_pa=pa_controls_mhin, last_nm_ob=ob_controls_mhin),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_mlin <- dtms_expectancy(probs=unadjusted_lmin,start_distr=Sm,dtms=dtms,start_state=limited)
  un_mhin <- dtms_expectancy(probs=unadjusted_hmin,start_distr=Sm,dtms=dtms,start_state=limited)
  s0_min <- dtms_expectancy(probs=prob_s0_lmin,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_min <- dtms_expectancy(probs=prob_a1_min,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_min <- dtms_expectancy(probs=prob_a2_min,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_min <- dtms_expectancy(probs=prob_a3_min,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_min <- dtms_expectancy(probs=prob_a4_min,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_min <- dtms_expectancy(probs=prob_aj_min,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_min <- dtms_expectancy(probs=prob_b1_min,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_min <- dtms_expectancy(probs=prob_b2_min,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_min <- dtms_expectancy(probs=prob_b3_min,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_min <- dtms_expectancy(probs=prob_b4_min,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_min <- dtms_expectancy(probs=prob_bj_min,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_min <- dtms_expectancy(probs=prob_sfinal_hmin,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lmin <- a1_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  g_smk_lmin <- a2_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  g_act_lmin <- a3_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  g_obs_lmin <- a4_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  g_joint_lmin <- aj_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  g_alc_hmin <- b1_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
  g_smk_hmin <- b2_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
  g_act_hmin <- b3_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
  g_obs_hmin <- b4_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
  g_joint_hmin <- bj_min["start:Nondisabled_840","Nondisabled"] - sfinal_min["start:Nondisabled_840","Nondisabled"]
  un_total_gap_min <- un_mhin["start:Nondisabled_840","Nondisabled"] - un_mlin["start:Nondisabled_840","Nondisabled"]
  total_gap_min <- sfinal_min["start:Nondisabled_840","Nondisabled"] - s0_min["start:Nondisabled_840","Nondisabled"]
  d_alc_min <- b1_min["start:Nondisabled_840","Nondisabled"] - a1_min["start:Nondisabled_840","Nondisabled"]
  d_smk_min <- b2_min["start:Nondisabled_840","Nondisabled"] - a2_min["start:Nondisabled_840","Nondisabled"]
  d_act_min <- b3_min["start:Nondisabled_840","Nondisabled"] - a3_min["start:Nondisabled_840","Nondisabled"]
  d_obs_min <- b4_min["start:Nondisabled_840","Nondisabled"] - a4_min["start:Nondisabled_840","Nondisabled"]
  residual_min <- bj_min["start:Nondisabled_840","Nondisabled"] - aj_min["start:Nondisabled_840","Nondisabled"]
  g_alc_lmin_t <- a1_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  g_smk_lmin_t <- a2_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  g_act_lmin_t <- a3_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  g_obs_lmin_t <- a4_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  g_joint_lmin_t <- aj_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  g_alc_hmin_t <- b1_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
  g_smk_hmin_t <- b2_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
  g_act_hmin_t <- b3_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
  g_obs_hmin_t <- b4_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
  g_joint_hmin_t <- bj_min["start:Nondisabled_840","TOTAL"] - sfinal_min["start:Nondisabled_840","TOTAL"]
  un_total_gap_min_t <- un_mhin["start:Nondisabled_840","TOTAL"] - un_mlin["start:Nondisabled_840","TOTAL"]
  total_gap_min_t <- sfinal_min["start:Nondisabled_840","TOTAL"] - s0_min["start:Nondisabled_840","TOTAL"]
  d_alc_min_t <- b1_min["start:Nondisabled_840","TOTAL"] - a1_min["start:Nondisabled_840","TOTAL"]
  d_smk_min_t <- b2_min["start:Nondisabled_840","TOTAL"] - a2_min["start:Nondisabled_840","TOTAL"]
  d_act_min_t <- b3_min["start:Nondisabled_840","TOTAL"] - a3_min["start:Nondisabled_840","TOTAL"]
  d_obs_min_t <- b4_min["start:Nondisabled_840","TOTAL"] - a4_min["start:Nondisabled_840","TOTAL"]
  residual_min_t <- bj_min["start:Nondisabled_840","TOTAL"] - aj_min["start:Nondisabled_840","TOTAL"]
  prop_ale_mlin <- (un_mlin["start:Nondisabled_840","Nondisabled"]/un_mlin["start:Nondisabled_840","TOTAL"])*100
  prop_ale_mhin <- (un_mhin["start:Nondisabled_840","Nondisabled"]/un_mhin["start:Nondisabled_840","TOTAL"])*100
  prop_dif_min <- prop_ale_mhin - prop_ale_mlin
  alc_cont_min <- ((total_gap_min - d_alc_min)/total_gap_min)*100
  alc_cont_min_t <- ((total_gap_min_t - d_alc_min_t)/total_gap_min_t)*100
  smk_cont_min <- ((total_gap_min - d_smk_min)/total_gap_min)*100
  smk_cont_min_t <- ((total_gap_min_t - d_smk_min_t)/total_gap_min_t)*100
  act_cont_min <- ((total_gap_min - d_act_min)/total_gap_min)*100
  act_cont_min_t <- ((total_gap_min_t - d_act_min_t)/total_gap_min_t)*100
  obs_cont_min <- ((total_gap_min - d_obs_min)/total_gap_min)*100
  obs_cont_min_t <- ((total_gap_min_t - d_obs_min_t)/total_gap_min_t)*100
  joint_cont_min <- ((total_gap_min - residual_min)/total_gap_min)*100
  joint_cont_min_t <- ((total_gap_min_t - residual_min_t)/total_gap_min_t)*100
  rbind(un_mlin,un_mhin,s0_min,a1_min,a2_min,a3_min,a4_min,aj_min,b1_min,b2_min,b3_min,b4_min,bj_min,sfinal_min,
        g_alc_lmin,g_smk_lmin,g_act_lmin,g_obs_lmin,g_joint_lmin,
        g_alc_hmin,g_smk_hmin,g_act_hmin,g_obs_hmin,g_joint_hmin,
        un_total_gap_min,total_gap_min,d_alc_min,d_smk_min,d_act_min,d_obs_min,residual_min,
        g_alc_lmin_t,g_smk_lmin_t,g_act_lmin_t,g_obs_lmin_t,g_joint_lmin_t,
        g_alc_hmin_t,g_smk_hmin_t,g_act_hmin_t,g_obs_hmin_t,g_joint_hmin_t,
        un_total_gap_min_t,total_gap_min_t,d_alc_min_t,d_smk_min_t,d_act_min_t,d_obs_min_t,residual_min_t,
        prop_ale_mlin,prop_ale_mhin,prop_dif_min,
        alc_cont_min,alc_cont_min_t,smk_cont_min,smk_cont_min_t,act_cont_min,act_cont_min_t,obs_cont_min,obs_cont_min_t,joint_cont_min,joint_cont_min_t)
}
## Bootstrap results male
bootresults_mi <- dtms_boot(data=estdata_m,
                            dtms=simple,
                            fun=bootfun_mi,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_mi)
save(bootresults_mi,file="Results-bootstrap-mi4bc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfin <- a1_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
g_smk_lfin <- a2_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
g_act_lfin <- a3_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
g_obs_lfin <- a4_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfin <- aj_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfin <- b1_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
g_smk_hfin <- b2_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
g_act_hfin <- b3_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
g_obs_hfin <- b4_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfin <- bj_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fin <- un_fhin["start:Nondisabled_840","Nondisabled"] - un_flin["start:Nondisabled_840","Nondisabled"]
total_gap_fin <- sfinal_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fin <- b1_fin["start:Nondisabled_840","Nondisabled"] - a1_fin["start:Nondisabled_840","Nondisabled"]
d_smk_fin <- b2_fin["start:Nondisabled_840","Nondisabled"] - a2_fin["start:Nondisabled_840","Nondisabled"]
d_act_fin <- b3_fin["start:Nondisabled_840","Nondisabled"] - a3_fin["start:Nondisabled_840","Nondisabled"]
d_obs_fin <- b4_fin["start:Nondisabled_840","Nondisabled"] - a4_fin["start:Nondisabled_840","Nondisabled"]
residual_fin <- bj_fin["start:Nondisabled_840","Nondisabled"] - aj_fin["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfin_t <- a1_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
g_smk_lfin_t <- a2_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
g_act_lfin_t <- a3_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
g_obs_lfin_t <- a4_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfin_t <- aj_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfin_t <- b1_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
g_smk_hfin_t <- b2_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
g_act_hfin_t <- b3_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
g_obs_hfin_t <- b4_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfin_t <- bj_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fin_t <- un_fhin["start:Nondisabled_840","TOTAL"] - un_flin["start:Nondisabled_840","TOTAL"]
total_gap_fin_t <- sfinal_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fin_t <- b1_fin["start:Nondisabled_840","TOTAL"] - a1_fin["start:Nondisabled_840","TOTAL"]
d_smk_fin_t <- b2_fin["start:Nondisabled_840","TOTAL"] - a2_fin["start:Nondisabled_840","TOTAL"]
d_act_fin_t <- b3_fin["start:Nondisabled_840","TOTAL"] - a3_fin["start:Nondisabled_840","TOTAL"]
d_obs_fin_t <- b4_fin["start:Nondisabled_840","TOTAL"] - a4_fin["start:Nondisabled_840","TOTAL"]
residual_fin_t <- bj_fin["start:Nondisabled_840","TOTAL"] - aj_fin["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES female)
prop_ale_flin <- (un_flin["start:Nondisabled_840","Nondisabled"]/un_flin["start:Nondisabled_840","TOTAL"])*100
prop_ale_fhin <- (un_fhin["start:Nondisabled_840","Nondisabled"]/un_fhin["start:Nondisabled_840","TOTAL"])*100
prop_dif_fin <- prop_ale_fhin - prop_ale_flin

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_fin <- ((total_gap_fin - d_alc_fin)/total_gap_fin)*100
alc_cont_fin_t <- ((total_gap_fin_t - d_alc_fin_t)/total_gap_fin_t)*100
smk_cont_fin <- ((total_gap_fin - d_smk_fin)/total_gap_fin)*100
smk_cont_fin_t <- ((total_gap_fin_t - d_smk_fin_t)/total_gap_fin_t)*100
act_cont_fin <- ((total_gap_fin - d_act_fin)/total_gap_fin)*100
act_cont_fin_t <- ((total_gap_fin_t - d_act_fin_t)/total_gap_fin_t)*100
obs_cont_fin <- ((total_gap_fin - d_obs_fin)/total_gap_fin)*100
obs_cont_fin_t <- ((total_gap_fin_t - d_obs_fin_t)/total_gap_fin_t)*100
joint_cont_fin <- ((total_gap_fin - residual_fin)/total_gap_fin)*100
joint_cont_fin_t <- ((total_gap_fin_t - residual_fin_t)/total_gap_fin_t)*100

## Bootstrap function female
bootfun_fi <- function(data,dtms) {
  fit_w0i <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+inc_bimi)
  fit_wi <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+inc_bimi
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_f <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_flin <- mean(data$alc_cons[data$inc_bimi==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhin <- mean(data$alc_cons[data$inc_bimi==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
  model_smok_fin <- glm(last_nm_smok ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  smok_controls_flin <- predict(model_smok_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  smok_controls_fhin <- predict(model_smok_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  model_pa_fin <- glm(last_nm_pa ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  pa_controls_flin <- predict(model_pa_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  pa_controls_fhin <- predict(model_pa_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  model_ob_fin <- glm(last_nm_ob ~ (time+I(time^2))*inc_bimi,data=data, family=binomial)
  ob_controls_flin <- predict(model_ob_fin,newdata=data.frame(time=840:1319,inc_bimi=0),type="response")
  ob_controls_fhin <- predict(model_ob_fin,newdata=data.frame(time=840:1319,inc_bimi=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lfin <- dtms_transitions(dtms=dtms,
                                      model=fit_w0i,
                                      controls=list(time=840:1319, inc_bimi=0),
                                      ci=TRUE)
  unadjusted_hfin <- dtms_transitions(dtms=dtms,
                                      model=fit_w0i,
                                      controls=list(time=840:1319, inc_bimi=1),
                                      ci=TRUE)
  prob_s0_lfin <- dtms_transitions(dtms=dtms,
                                   model=fit_wi,
                                   controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                 inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                                 last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                   ci=TRUE)
  prob_a1_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=0, alc_cons=0, last_nm_smok=smok_controls_flin, 
                                                last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                  ci=TRUE)
  prob_a2_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_flin, last_nm_ob=ob_controls_flin),
                                  ci=TRUE)
  prob_a3_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_flin),
                                  ci=TRUE)
  prob_a4_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=0, alc_cons=alc_flin, last_nm_smok=smok_controls_flin, 
                                                last_nm_pa=pa_controls_flin, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=1, alc_cons=0, last_nm_smok=smok_controls_fhin, 
                                                last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
                                  ci=TRUE)
  prob_b2_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
                                  ci=TRUE)
  prob_b3_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhin),
                                  ci=TRUE)
  prob_b4_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                                last_nm_pa=pa_controls_fhin, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_fin <- dtms_transitions(dtms=dtms,
                                  model=fit_wi,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                inc_bimi=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hfin <- dtms_transitions(dtms=dtms,
                                       model=fit_wi,
                                       controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                     inc_bimi=1, alc_cons=alc_fhin, last_nm_smok=smok_controls_fhin, 
                                                     last_nm_pa=pa_controls_fhin, last_nm_ob=ob_controls_fhin),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_flin <- dtms_expectancy(probs=unadjusted_lfin,start_distr=Sw,dtms=dtms,start_state=limited)
  un_fhin <- dtms_expectancy(probs=unadjusted_hfin,start_distr=Sw,dtms=dtms,start_state=limited)
  s0_fin <- dtms_expectancy(probs=prob_s0_lfin,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_fin <- dtms_expectancy(probs=prob_a1_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_fin <- dtms_expectancy(probs=prob_a2_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_fin <- dtms_expectancy(probs=prob_a3_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_fin <- dtms_expectancy(probs=prob_a4_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_fin <- dtms_expectancy(probs=prob_aj_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_fin <- dtms_expectancy(probs=prob_b1_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_fin <- dtms_expectancy(probs=prob_b2_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_fin <- dtms_expectancy(probs=prob_b3_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_fin <- dtms_expectancy(probs=prob_b4_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_fin <- dtms_expectancy(probs=prob_bj_fin,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_fin <- dtms_expectancy(probs=prob_sfinal_hfin,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfin <- a1_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  g_smk_lfin <- a2_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  g_act_lfin <- a3_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  g_obs_lfin <- a4_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  g_joint_lfin <- aj_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  g_alc_hfin <- b1_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
  g_smk_hfin <- b2_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
  g_act_hfin <- b3_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
  g_obs_hfin <- b4_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
  g_joint_hfin <- bj_fin["start:Nondisabled_840","Nondisabled"] - sfinal_fin["start:Nondisabled_840","Nondisabled"]
  un_total_gap_fin <- un_fhin["start:Nondisabled_840","Nondisabled"] - un_flin["start:Nondisabled_840","Nondisabled"]
  total_gap_fin <- sfinal_fin["start:Nondisabled_840","Nondisabled"] - s0_fin["start:Nondisabled_840","Nondisabled"]
  d_alc_fin <- b1_fin["start:Nondisabled_840","Nondisabled"] - a1_fin["start:Nondisabled_840","Nondisabled"]
  d_smk_fin <- b2_fin["start:Nondisabled_840","Nondisabled"] - a2_fin["start:Nondisabled_840","Nondisabled"]
  d_act_fin <- b3_fin["start:Nondisabled_840","Nondisabled"] - a3_fin["start:Nondisabled_840","Nondisabled"]
  d_obs_fin <- b4_fin["start:Nondisabled_840","Nondisabled"] - a4_fin["start:Nondisabled_840","Nondisabled"]
  residual_fin <- bj_fin["start:Nondisabled_840","Nondisabled"] - aj_fin["start:Nondisabled_840","Nondisabled"]
  g_alc_lfin_t <- a1_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  g_smk_lfin_t <- a2_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  g_act_lfin_t <- a3_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  g_obs_lfin_t <- a4_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  g_joint_lfin_t <- aj_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  g_alc_hfin_t <- b1_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
  g_smk_hfin_t <- b2_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
  g_act_hfin_t <- b3_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
  g_obs_hfin_t <- b4_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
  g_joint_hfin_t <- bj_fin["start:Nondisabled_840","TOTAL"] - sfinal_fin["start:Nondisabled_840","TOTAL"]
  un_total_gap_fin_t <- un_fhin["start:Nondisabled_840","TOTAL"] - un_flin["start:Nondisabled_840","TOTAL"]
  total_gap_fin_t <- sfinal_fin["start:Nondisabled_840","TOTAL"] - s0_fin["start:Nondisabled_840","TOTAL"]
  d_alc_fin_t <- b1_fin["start:Nondisabled_840","TOTAL"] - a1_fin["start:Nondisabled_840","TOTAL"]
  d_smk_fin_t <- b2_fin["start:Nondisabled_840","TOTAL"] - a2_fin["start:Nondisabled_840","TOTAL"]
  d_act_fin_t <- b3_fin["start:Nondisabled_840","TOTAL"] - a3_fin["start:Nondisabled_840","TOTAL"]
  d_obs_fin_t <- b4_fin["start:Nondisabled_840","TOTAL"] - a4_fin["start:Nondisabled_840","TOTAL"]
  residual_fin_t <- bj_fin["start:Nondisabled_840","TOTAL"] - aj_fin["start:Nondisabled_840","TOTAL"]
  prop_ale_flin <- (un_flin["start:Nondisabled_840","Nondisabled"]/un_flin["start:Nondisabled_840","TOTAL"])*100
  prop_ale_fhin <- (un_fhin["start:Nondisabled_840","Nondisabled"]/un_fhin["start:Nondisabled_840","TOTAL"])*100
  prop_dif_fin <- prop_ale_fhin - prop_ale_flin
  alc_cont_fin <- ((total_gap_fin - d_alc_fin)/total_gap_fin)*100
  alc_cont_fin_t <- ((total_gap_fin_t - d_alc_fin_t)/total_gap_fin_t)*100
  smk_cont_fin <- ((total_gap_fin - d_smk_fin)/total_gap_fin)*100
  smk_cont_fin_t <- ((total_gap_fin_t - d_smk_fin_t)/total_gap_fin_t)*100
  act_cont_fin <- ((total_gap_fin - d_act_fin)/total_gap_fin)*100
  act_cont_fin_t <- ((total_gap_fin_t - d_act_fin_t)/total_gap_fin_t)*100
  obs_cont_fin <- ((total_gap_fin - d_obs_fin)/total_gap_fin)*100
  obs_cont_fin_t <- ((total_gap_fin_t - d_obs_fin_t)/total_gap_fin_t)*100
  joint_cont_fin <- ((total_gap_fin - residual_fin)/total_gap_fin)*100
  joint_cont_fin_t <- ((total_gap_fin_t - residual_fin_t)/total_gap_fin_t)*100
  rbind(un_flin,un_fhin,s0_fin,a1_fin,a2_fin,a3_fin,a4_fin,aj_fin,b1_fin,b2_fin,b3_fin,b4_fin,bj_fin,sfinal_fin,
        g_alc_lfin,g_smk_lfin,g_act_lfin,g_obs_lfin,g_joint_lfin,
        g_alc_hfin,g_smk_hfin,g_act_hfin,g_obs_hfin,g_joint_hfin,
        un_total_gap_fin,total_gap_fin,d_alc_fin,d_smk_fin,d_act_fin,d_obs_fin,residual_fin,
        g_alc_lfin_t,g_smk_lfin_t,g_act_lfin_t,g_obs_lfin_t,g_joint_lfin_t,
        g_alc_hfin_t,g_smk_hfin_t,g_act_hfin_t,g_obs_hfin_t,g_joint_hfin_t,
        un_total_gap_fin_t,total_gap_fin_t,d_alc_fin_t,d_smk_fin_t,d_act_fin_t,d_obs_fin_t,residual_fin_t,
        prop_ale_flin,prop_ale_fhin,prop_dif_fin,
        alc_cont_fin,alc_cont_fin_t,smk_cont_fin,smk_cont_fin_t,act_cont_fin,act_cont_fin_t,obs_cont_fin,obs_cont_fin_t,joint_cont_fin,joint_cont_fin_t)
}
## Bootstrap results female
bootresults_fi <- dtms_boot(data=estdata_w,
                            dtms=simple,
                            fun=bootfun_fi,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_fi)
save(bootresults_fi,file="Results-bootstrap-fi4bc-10000.Rda")

## Print estimates
un_mlin
un_mhin
s0_min
a1_min
a2_min
a3_min
a4_min
aj_min
b1_min
b2_min
b3_min
b4_min
bj_min
sfinal_min
g_alc_lmin
g_smk_lmin
g_act_lmin
g_obs_lmin
g_joint_lmin
g_alc_hmin
g_smk_hmin
g_act_hmin
g_obs_hmin
g_joint_hmin
un_total_gap_min
total_gap_min
d_alc_min
d_smk_min
d_act_min
d_obs_min
residual_min
g_alc_lmin_t
g_smk_lmin_t
g_act_lmin_t
g_obs_lmin_t
g_joint_lmin_t
g_alc_hmin_t
g_smk_hmin_t
g_act_hmin_t
g_obs_hmin_t
g_joint_hmin_t
un_total_gap_min_t
total_gap_min_t
d_alc_min_t
d_smk_min_t
d_act_min_t
d_obs_min_t
residual_min_t
prop_ale_mlin
prop_ale_mhin
prop_dif_min
alc_cont_min
alc_cont_min_t
smk_cont_min
smk_cont_min_t
act_cont_min
act_cont_min_t
obs_cont_min
obs_cont_min_t
joint_cont_min
joint_cont_min_t

un_flin
un_fhin
s0_fin
a1_fin
a2_fin
a3_fin
a4_fin
aj_fin
b1_fin
b2_fin
b3_fin
b4_fin
bj_fin
sfinal_fin
g_alc_lfin
g_smk_lfin
g_act_lfin
g_obs_lfin
g_joint_lfin
g_alc_hfin
g_smk_hfin
g_act_hfin
g_obs_hfin
g_joint_hfin
un_total_gap_fin
total_gap_fin
d_alc_fin
d_smk_fin
d_act_fin
d_obs_fin
residual_fin
g_alc_lfin_t
g_smk_lfin_t
g_act_lfin_t
g_obs_lfin_t
g_joint_lfin_t
g_alc_hfin_t
g_smk_hfin_t
g_act_hfin_t
g_obs_hfin_t
g_joint_hfin_t
un_total_gap_fin_t
total_gap_fin_t
d_alc_fin_t
d_smk_fin_t
d_act_fin_t
d_obs_fin_t
residual_fin_t
prop_ale_flin
prop_ale_fhin
prop_dif_fin
alc_cont_fin
alc_cont_fin_t
smk_cont_fin
smk_cont_fin_t
act_cont_fin
act_cont_fin_t
obs_cont_fin
obs_cont_fin_t
joint_cont_fin
joint_cont_fin_t
