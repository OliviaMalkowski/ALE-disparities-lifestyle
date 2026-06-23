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
fit_m0a <- dtms_fit(data=estdata_m,
                    formula=to~from+time+I(time^2)+adi_cons)

## Fit women unadjusted
fit_w0a <- dtms_fit(data=estdata_w,
                    formula=to~from+time+I(time^2)+adi_cons)

## Fit men adjusted
fit_ma <- dtms_fit(data=estdata_m,
                   formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+adi_cons
                   +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Fit women adjusted
fit_wa <- dtms_fit(data=estdata_w,
                   formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+adi_cons
                   +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)

## Values for prediction ##############################################

## Male
## Time-constant variables
eth_gm_m <- mean(estdata_m$eth_bi[estdata_m$intbloc==0], na.rm = TRUE)
eth_gm_m
alc_mlad <- mean(estdata_m$alc_cons[estdata_m$adi_cons==0 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mlad 
alc_mhad <- mean(estdata_m$alc_cons[estdata_m$adi_cons==1 & estdata_m$intbloc==0], na.rm = TRUE)
alc_mhad

## Time-varying variables
model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=estdata_m)
cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
model_smok_mad <- glm(last_nm_smok ~ (time+I(time^2))*adi_cons,data=estdata_m, family=binomial)
smok_controls_mlad <- predict(model_smok_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
smok_controls_mhad <- predict(model_smok_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
model_pa_mad <- glm(last_nm_pa ~ (time+I(time^2))*adi_cons,data=estdata_m, family=binomial)
pa_controls_mlad <- predict(model_pa_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
pa_controls_mhad <- predict(model_pa_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
model_ob_mad <- glm(last_nm_ob ~ (time+I(time^2))*adi_cons,data=estdata_m, family=binomial)
ob_controls_mlad <- predict(model_ob_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
ob_controls_mhad <- predict(model_ob_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")

## Female
## Time-constant variables
eth_gm_f <- mean(estdata_w$eth_bi[estdata_w$intbloc==0], na.rm = TRUE)
eth_gm_f 
alc_flad <- mean(estdata_w$alc_cons[estdata_w$adi_cons==0 & estdata_w$intbloc==0], na.rm = TRUE)
alc_flad 
alc_fhad <- mean(estdata_w$alc_cons[estdata_w$adi_cons==1 & estdata_w$intbloc==0], na.rm = TRUE)
alc_fhad

## Time-varying variables
model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=estdata_w)
cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
model_smok_fad <- glm(last_nm_smok ~ (time+I(time^2))*adi_cons,data=estdata_w, family=binomial)
smok_controls_flad <- predict(model_smok_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
smok_controls_fhad <- predict(model_smok_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
model_pa_fad <- glm(last_nm_pa ~ (time+I(time^2))*adi_cons,data=estdata_w, family=binomial)
pa_controls_flad <- predict(model_pa_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
pa_controls_fhad <- predict(model_pa_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
model_ob_fad <- glm(last_nm_ob ~ (time+I(time^2))*adi_cons,data=estdata_w, family=binomial)
ob_controls_flad <- predict(model_ob_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
ob_controls_fhad <- predict(model_ob_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")

## Elimination scenario(s)
smok_elimination <- rep(0,times=480)
pa_elimination <- rep(0,times=480)
ob_elimination <- rep(0,times=480)

## Predict probabilities ##############################################

## Unadjusted analyses lower SES male
unadjusted_lmad <- dtms_transitions(dtms=simple,
                                    model=fit_m0a,
                                    controls=list(time=840:1319, adi_cons=0),
                                    ci=TRUE)

## Unadjusted analyses higher SES male
unadjusted_hmad <- dtms_transitions(dtms=simple,
                                    model=fit_m0a,
                                    controls=list(time=840:1319, adi_cons=1),
                                    ci=TRUE)

## Unadjusted analyses lower SES female
unadjusted_lfad <- dtms_transitions(dtms=simple,
                                    model=fit_w0a,
                                    controls=list(time=840:1319, adi_cons=0),
                                    ci=TRUE)

## Unadjusted analyses higher SES female
unadjusted_hfad <- dtms_transitions(dtms=simple,
                                    model=fit_w0a,
                                    controls=list(time=840:1319, adi_cons=1),
                                    ci=TRUE)

## Reference scenario lower SES male
prob_s0_lmad <- dtms_transitions(dtms=simple,
                                 model=fit_ma,
                                 controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                               adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                               last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES male
prob_a1_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=0, alc_cons=0, last_nm_smok=smok_controls_mlad, 
                                              last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                ci=TRUE)
## Eliminate smoking lower SES male
prob_a2_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                ci=TRUE)
## Eliminate low physical activity lower SES male
prob_a3_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mlad),
                                ci=TRUE)
## Eliminate obesity lower SES male
prob_a4_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                              last_nm_pa=pa_controls_mlad, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES male
prob_aj_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES male
prob_b1_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=1, alc_cons=0, last_nm_smok=smok_controls_mhad, 
                                              last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                ci=TRUE)
## Eliminate smoking higher SES male
prob_b2_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                ci=TRUE)
## Eliminate low physical activity higher SES male
prob_b3_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhad),
                                ci=TRUE)
## Eliminate obesity higher SES male
prob_b4_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                              last_nm_pa=pa_controls_mhad, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES male
prob_bj_mad <- dtms_transitions(dtms=simple,
                                model=fit_ma,
                                controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                              adi_cons=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES male
prob_sfinal_hmad <- dtms_transitions(dtms=simple,
                                     model=fit_ma,
                                     controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                   adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                                   last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                     ci=TRUE)

## Reference scenario lower SES female
prob_s0_lfad <- dtms_transitions(dtms=simple,
                                 model=fit_wa,
                                 controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                               adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                               last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                 ci=TRUE)
## Eliminate harmful alcohol use lower SES female
prob_a1_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=0, alc_cons=0, last_nm_smok=smok_controls_flad, 
                                              last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                ci=TRUE)
## Eliminate smoking lower SES female
prob_a2_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                ci=TRUE)
## Eliminate low physical activity lower SES female
prob_a3_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_flad),
                                ci=TRUE)
## Eliminate obesity lower SES female
prob_a4_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                              last_nm_pa=pa_controls_flad, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly lower SES female
prob_aj_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)

## Eliminate harmful alcohol use higher SES female
prob_b1_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=1, alc_cons=0, last_nm_smok=smok_controls_fhad, 
                                              last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
                                ci=TRUE)
## Eliminate smoking higher SES female
prob_b2_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
                                ci=TRUE)
## Eliminate low physical activity higher SES female
prob_b3_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhad),
                                ci=TRUE)
## Eliminate obesity higher SES female
prob_b4_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                              last_nm_pa=pa_controls_fhad, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Eliminate all risk factors jointly higher SES female
prob_bj_fad <- dtms_transitions(dtms=simple,
                                model=fit_wa,
                                controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                              adi_cons=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                              last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                ci=TRUE)
## Reference scenario higher SES female
prob_sfinal_hfad <- dtms_transitions(dtms=simple,
                                     model=fit_wa,
                                     controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                   adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                                   last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
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
un_mlad <- dtms_expectancy(probs=unadjusted_lmad,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES male
un_mhad <- dtms_expectancy(probs=unadjusted_hmad,start_distr=Sm,dtms=simple,start_state=limited)
## Unadjusted analyses lower SES female
un_flad <- dtms_expectancy(probs=unadjusted_lfad,start_distr=Sw,dtms=simple,start_state=limited)
## Unadjusted analyses higher SES female
un_fhad <- dtms_expectancy(probs=unadjusted_hfad,start_distr=Sw,dtms=simple,start_state=limited)

## Reference scenario lower SES male
s0_mad <- dtms_expectancy(probs=prob_s0_lmad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES male
a1_mad <- dtms_expectancy(probs=prob_a1_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking lower SES male
a2_mad <- dtms_expectancy(probs=prob_a2_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES male
a3_mad <- dtms_expectancy(probs=prob_a3_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity lower SES male
a4_mad <- dtms_expectancy(probs=prob_a4_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES male
aj_mad <- dtms_expectancy(probs=prob_aj_mad,start_distr=Sm,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES male
b1_mad <- dtms_expectancy(probs=prob_b1_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate smoking higher SES male
b2_mad <- dtms_expectancy(probs=prob_b2_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES male
b3_mad <- dtms_expectancy(probs=prob_b3_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate obesity higher SES male
b4_mad <- dtms_expectancy(probs=prob_b4_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES male
bj_mad <- dtms_expectancy(probs=prob_bj_mad,start_distr=Sm,dtms=simple,start_state=limited)
## Reference scenario higher SES male
sfinal_mad <- dtms_expectancy(probs=prob_sfinal_hmad,start_distr=Sm,dtms=simple,start_state=limited)

## Reference scenario lower SES female
s0_fad <- dtms_expectancy(probs=prob_s0_lfad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate harmful alcohol use lower SES female
a1_fad <- dtms_expectancy(probs=prob_a1_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking lower SES female
a2_fad <- dtms_expectancy(probs=prob_a2_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity lower SES female
a3_fad <- dtms_expectancy(probs=prob_a3_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity lower SES female
a4_fad <- dtms_expectancy(probs=prob_a4_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly lower SES female
aj_fad <- dtms_expectancy(probs=prob_aj_fad,start_distr=Sw,dtms=simple,start_state=limited)

## Eliminate harmful alcohol use higher SES female
b1_fad <- dtms_expectancy(probs=prob_b1_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate smoking higher SES female
b2_fad <- dtms_expectancy(probs=prob_b2_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate low physical activity higher SES female
b3_fad <- dtms_expectancy(probs=prob_b3_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate obesity higher SES female
b4_fad <- dtms_expectancy(probs=prob_b4_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Eliminate all risk factors jointly higher SES female
bj_fad <- dtms_expectancy(probs=prob_bj_fad,start_distr=Sw,dtms=simple,start_state=limited)
## Reference scenario higher SES female
sfinal_fad <- dtms_expectancy(probs=prob_sfinal_hfad,start_distr=Sw,dtms=simple,start_state=limited)

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmad <- a1_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
g_smk_lmad <- a2_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
g_act_lmad <- a3_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
g_obs_lmad <- a4_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmad <- aj_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmad <- b1_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
g_smk_hmad <- b2_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
g_act_hmad <- b3_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
g_obs_hmad <- b4_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmad <- bj_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_mad <- un_mhad["start:Nondisabled_840","Nondisabled"] - un_mlad["start:Nondisabled_840","Nondisabled"]
total_gap_mad <- sfinal_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_mad <- b1_mad["start:Nondisabled_840","Nondisabled"] - a1_mad["start:Nondisabled_840","Nondisabled"]
d_smk_mad <- b2_mad["start:Nondisabled_840","Nondisabled"] - a2_mad["start:Nondisabled_840","Nondisabled"]
d_act_mad <- b3_mad["start:Nondisabled_840","Nondisabled"] - a3_mad["start:Nondisabled_840","Nondisabled"]
d_obs_mad <- b4_mad["start:Nondisabled_840","Nondisabled"] - a4_mad["start:Nondisabled_840","Nondisabled"]
residual_mad <- bj_mad["start:Nondisabled_840","Nondisabled"] - aj_mad["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES male)
g_alc_lmad_t <- a1_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
g_smk_lmad_t <- a2_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
g_act_lmad_t <- a3_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
g_obs_lmad_t <- a4_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES male)
g_joint_lmad_t <- aj_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES male)
g_alc_hmad_t <- b1_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
g_smk_hmad_t <- b2_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
g_act_hmad_t <- b3_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
g_obs_hmad_t <- b4_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES male)
g_joint_hmad_t <- bj_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_mad_t <- un_mhad["start:Nondisabled_840","TOTAL"] - un_mlad["start:Nondisabled_840","TOTAL"]
total_gap_mad_t <- sfinal_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_mad_t <- b1_mad["start:Nondisabled_840","TOTAL"] - a1_mad["start:Nondisabled_840","TOTAL"]
d_smk_mad_t <- b2_mad["start:Nondisabled_840","TOTAL"] - a2_mad["start:Nondisabled_840","TOTAL"]
d_act_mad_t <- b3_mad["start:Nondisabled_840","TOTAL"] - a3_mad["start:Nondisabled_840","TOTAL"]
d_obs_mad_t <- b4_mad["start:Nondisabled_840","TOTAL"] - a4_mad["start:Nondisabled_840","TOTAL"]
residual_mad_t <- bj_mad["start:Nondisabled_840","TOTAL"] - aj_mad["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES male)
prop_ale_mlad <- (un_mlad["start:Nondisabled_840","Nondisabled"]/un_mlad["start:Nondisabled_840","TOTAL"])*100
prop_ale_mhad <- (un_mhad["start:Nondisabled_840","Nondisabled"]/un_mhad["start:Nondisabled_840","TOTAL"])*100
prop_dif_mad <- prop_ale_mhad - prop_ale_mlad

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (male)
alc_cont_mad <- ((total_gap_mad - d_alc_mad)/total_gap_mad)*100
alc_cont_mad_t <- ((total_gap_mad_t - d_alc_mad_t)/total_gap_mad_t)*100
smk_cont_mad <- ((total_gap_mad - d_smk_mad)/total_gap_mad)*100
smk_cont_mad_t <- ((total_gap_mad_t - d_smk_mad_t)/total_gap_mad_t)*100
act_cont_mad <- ((total_gap_mad - d_act_mad)/total_gap_mad)*100
act_cont_mad_t <- ((total_gap_mad_t - d_act_mad_t)/total_gap_mad_t)*100
obs_cont_mad <- ((total_gap_mad - d_obs_mad)/total_gap_mad)*100
obs_cont_mad_t <- ((total_gap_mad_t - d_obs_mad_t)/total_gap_mad_t)*100
joint_cont_mad <- ((total_gap_mad - residual_mad)/total_gap_mad)*100
joint_cont_mad_t <- ((total_gap_mad_t - residual_mad_t)/total_gap_mad_t)*100

## Bootstrap function male
bootfun_ma <- function(data,dtms) {
  fit_m0a <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+adi_cons)
  fit_ma <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+adi_cons
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_m <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_mlad <- mean(data$alc_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  alc_mhad <- mean(data$alc_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_m <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_m <- predict(model_cc_gm_m,newdata=data.frame(time=840:1319))
  model_smok_mad <- glm(last_nm_smok ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  smok_controls_mlad <- predict(model_smok_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  smok_controls_mhad <- predict(model_smok_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  model_pa_mad <- glm(last_nm_pa ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  pa_controls_mlad <- predict(model_pa_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  pa_controls_mhad <- predict(model_pa_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  model_ob_mad <- glm(last_nm_ob ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  ob_controls_mlad <- predict(model_ob_mad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  ob_controls_mhad <- predict(model_ob_mad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lmad <- dtms_transitions(dtms=dtms,
                                      model=fit_m0a,
                                      controls=list(time=840:1319, adi_cons=0),
                                      ci=TRUE)
  unadjusted_hmad <- dtms_transitions(dtms=dtms,
                                      model=fit_m0a,
                                      controls=list(time=840:1319, adi_cons=1),
                                      ci=TRUE)
  prob_s0_lmad <- dtms_transitions(dtms=dtms,
                                   model=fit_ma,
                                   controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                 adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                                 last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                   ci=TRUE)
  prob_a1_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=0, alc_cons=0, last_nm_smok=smok_controls_mlad, 
                                                last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                  ci=TRUE)
  prob_a2_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mlad, last_nm_ob=ob_controls_mlad),
                                  ci=TRUE)
  prob_a3_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mlad),
                                  ci=TRUE)
  prob_a4_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=0, alc_cons=alc_mlad, last_nm_smok=smok_controls_mlad, 
                                                last_nm_pa=pa_controls_mlad, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=1, alc_cons=0, last_nm_smok=smok_controls_mhad, 
                                                last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                  ci=TRUE)
  prob_b2_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                  ci=TRUE)
  prob_b3_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_mhad),
                                  ci=TRUE)
  prob_b4_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                                last_nm_pa=pa_controls_mhad, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_mad <- dtms_transitions(dtms=dtms,
                                  model=fit_ma,
                                  controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                adi_cons=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hmad <- dtms_transitions(dtms=dtms,
                                       model=fit_ma,
                                       controls=list(eth_bi=eth_gm_m, time=840:1319, last_nm_cc=cc_controls_gm_m,
                                                     adi_cons=1, alc_cons=alc_mhad, last_nm_smok=smok_controls_mhad, 
                                                     last_nm_pa=pa_controls_mhad, last_nm_ob=ob_controls_mhad),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sm <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_mlad <- dtms_expectancy(probs=unadjusted_lmad,start_distr=Sm,dtms=dtms,start_state=limited)
  un_mhad <- dtms_expectancy(probs=unadjusted_hmad,start_distr=Sm,dtms=dtms,start_state=limited)
  s0_mad <- dtms_expectancy(probs=prob_s0_lmad,start_distr=Sm,dtms=dtms,start_state=limited)
  a1_mad <- dtms_expectancy(probs=prob_a1_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  a2_mad <- dtms_expectancy(probs=prob_a2_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  a3_mad <- dtms_expectancy(probs=prob_a3_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  a4_mad <- dtms_expectancy(probs=prob_a4_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  aj_mad <- dtms_expectancy(probs=prob_aj_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  b1_mad <- dtms_expectancy(probs=prob_b1_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  b2_mad <- dtms_expectancy(probs=prob_b2_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  b3_mad <- dtms_expectancy(probs=prob_b3_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  b4_mad <- dtms_expectancy(probs=prob_b4_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  bj_mad <- dtms_expectancy(probs=prob_bj_mad,start_distr=Sm,dtms=dtms,start_state=limited)
  sfinal_mad <- dtms_expectancy(probs=prob_sfinal_hmad,start_distr=Sm,dtms=dtms,start_state=limited)
  g_alc_lmad <- a1_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  g_smk_lmad <- a2_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  g_act_lmad <- a3_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  g_obs_lmad <- a4_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  g_joint_lmad <- aj_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  g_alc_hmad <- b1_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
  g_smk_hmad <- b2_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
  g_act_hmad <- b3_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
  g_obs_hmad <- b4_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
  g_joint_hmad <- bj_mad["start:Nondisabled_840","Nondisabled"] - sfinal_mad["start:Nondisabled_840","Nondisabled"]
  un_total_gap_mad <- un_mhad["start:Nondisabled_840","Nondisabled"] - un_mlad["start:Nondisabled_840","Nondisabled"]
  total_gap_mad <- sfinal_mad["start:Nondisabled_840","Nondisabled"] - s0_mad["start:Nondisabled_840","Nondisabled"]
  d_alc_mad <- b1_mad["start:Nondisabled_840","Nondisabled"] - a1_mad["start:Nondisabled_840","Nondisabled"]
  d_smk_mad <- b2_mad["start:Nondisabled_840","Nondisabled"] - a2_mad["start:Nondisabled_840","Nondisabled"]
  d_act_mad <- b3_mad["start:Nondisabled_840","Nondisabled"] - a3_mad["start:Nondisabled_840","Nondisabled"]
  d_obs_mad <- b4_mad["start:Nondisabled_840","Nondisabled"] - a4_mad["start:Nondisabled_840","Nondisabled"]
  residual_mad <- bj_mad["start:Nondisabled_840","Nondisabled"] - aj_mad["start:Nondisabled_840","Nondisabled"]
  g_alc_lmad_t <- a1_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  g_smk_lmad_t <- a2_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  g_act_lmad_t <- a3_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  g_obs_lmad_t <- a4_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  g_joint_lmad_t <- aj_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  g_alc_hmad_t <- b1_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
  g_smk_hmad_t <- b2_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
  g_act_hmad_t <- b3_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
  g_obs_hmad_t <- b4_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
  g_joint_hmad_t <- bj_mad["start:Nondisabled_840","TOTAL"] - sfinal_mad["start:Nondisabled_840","TOTAL"]
  un_total_gap_mad_t <- un_mhad["start:Nondisabled_840","TOTAL"] - un_mlad["start:Nondisabled_840","TOTAL"]
  total_gap_mad_t <- sfinal_mad["start:Nondisabled_840","TOTAL"] - s0_mad["start:Nondisabled_840","TOTAL"]
  d_alc_mad_t <- b1_mad["start:Nondisabled_840","TOTAL"] - a1_mad["start:Nondisabled_840","TOTAL"]
  d_smk_mad_t <- b2_mad["start:Nondisabled_840","TOTAL"] - a2_mad["start:Nondisabled_840","TOTAL"]
  d_act_mad_t <- b3_mad["start:Nondisabled_840","TOTAL"] - a3_mad["start:Nondisabled_840","TOTAL"]
  d_obs_mad_t <- b4_mad["start:Nondisabled_840","TOTAL"] - a4_mad["start:Nondisabled_840","TOTAL"]
  residual_mad_t <- bj_mad["start:Nondisabled_840","TOTAL"] - aj_mad["start:Nondisabled_840","TOTAL"]
  prop_ale_mlad <- (un_mlad["start:Nondisabled_840","Nondisabled"]/un_mlad["start:Nondisabled_840","TOTAL"])*100
  prop_ale_mhad <- (un_mhad["start:Nondisabled_840","Nondisabled"]/un_mhad["start:Nondisabled_840","TOTAL"])*100
  prop_dif_mad <- prop_ale_mhad - prop_ale_mlad
  alc_cont_mad <- ((total_gap_mad - d_alc_mad)/total_gap_mad)*100
  alc_cont_mad_t <- ((total_gap_mad_t - d_alc_mad_t)/total_gap_mad_t)*100
  smk_cont_mad <- ((total_gap_mad - d_smk_mad)/total_gap_mad)*100
  smk_cont_mad_t <- ((total_gap_mad_t - d_smk_mad_t)/total_gap_mad_t)*100
  act_cont_mad <- ((total_gap_mad - d_act_mad)/total_gap_mad)*100
  act_cont_mad_t <- ((total_gap_mad_t - d_act_mad_t)/total_gap_mad_t)*100
  obs_cont_mad <- ((total_gap_mad - d_obs_mad)/total_gap_mad)*100
  obs_cont_mad_t <- ((total_gap_mad_t - d_obs_mad_t)/total_gap_mad_t)*100
  joint_cont_mad <- ((total_gap_mad - residual_mad)/total_gap_mad)*100
  joint_cont_mad_t <- ((total_gap_mad_t - residual_mad_t)/total_gap_mad_t)*100
  rbind(un_mlad,un_mhad,s0_mad,a1_mad,a2_mad,a3_mad,a4_mad,aj_mad,b1_mad,b2_mad,b3_mad,b4_mad,bj_mad,sfinal_mad,
        g_alc_lmad,g_smk_lmad,g_act_lmad,g_obs_lmad,g_joint_lmad,
        g_alc_hmad,g_smk_hmad,g_act_hmad,g_obs_hmad,g_joint_hmad,
        un_total_gap_mad,total_gap_mad,d_alc_mad,d_smk_mad,d_act_mad,d_obs_mad,residual_mad,
        g_alc_lmad_t,g_smk_lmad_t,g_act_lmad_t,g_obs_lmad_t,g_joint_lmad_t,
        g_alc_hmad_t,g_smk_hmad_t,g_act_hmad_t,g_obs_hmad_t,g_joint_hmad_t,
        un_total_gap_mad_t,total_gap_mad_t,d_alc_mad_t,d_smk_mad_t,d_act_mad_t,d_obs_mad_t,residual_mad_t,
        prop_ale_mlad,prop_ale_mhad,prop_dif_mad,
        alc_cont_mad,alc_cont_mad_t,smk_cont_mad,smk_cont_mad_t,act_cont_mad,act_cont_mad_t,obs_cont_mad,obs_cont_mad_t,joint_cont_mad,joint_cont_mad_t)
}
## Bootstrap results male
bootresults_ma <- dtms_boot(data=estdata_m,
                            dtms=simple,
                            fun=bootfun_ma,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_ma)
save(bootresults_ma,file="Results-bootstrap-ma4bc-10000.Rda")

## Active life expectancy
## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfad <- a1_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
g_smk_lfad <- a2_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
g_act_lfad <- a3_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
g_obs_lfad <- a4_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfad <- aj_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfad <- b1_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
g_smk_hfad <- b2_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
g_act_hfad <- b3_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
g_obs_hfad <- b4_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]

## Gains in active life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfad <- bj_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fad <- un_fhad["start:Nondisabled_840","Nondisabled"] - un_flad["start:Nondisabled_840","Nondisabled"]
total_gap_fad <- sfinal_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fad <- b1_fad["start:Nondisabled_840","Nondisabled"] - a1_fad["start:Nondisabled_840","Nondisabled"]
d_smk_fad <- b2_fad["start:Nondisabled_840","Nondisabled"] - a2_fad["start:Nondisabled_840","Nondisabled"]
d_act_fad <- b3_fad["start:Nondisabled_840","Nondisabled"] - a3_fad["start:Nondisabled_840","Nondisabled"]
d_obs_fad <- b4_fad["start:Nondisabled_840","Nondisabled"] - a4_fad["start:Nondisabled_840","Nondisabled"]
residual_fad <- bj_fad["start:Nondisabled_840","Nondisabled"] - aj_fad["start:Nondisabled_840","Nondisabled"]

## Total life expectancy
## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (lower SES female)
g_alc_lfad_t <- a1_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
g_smk_lfad_t <- a2_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
g_act_lfad_t <- a3_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
g_obs_lfad_t <- a4_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (lower SES female)
g_joint_lfad_t <- aj_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating each lifestyle risk factor one-by-one (higher SES female)
g_alc_hfad_t <- b1_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
g_smk_hfad_t <- b2_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
g_act_hfad_t <- b3_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
g_obs_hfad_t <- b4_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]

## Gains in total life expectancy from eliminating all lifestyle risk factors jointly (higher SES female)
g_joint_hfad_t <- bj_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]

## Reference scenario disparities (higher minus lower SES), unadjusted and adjusted analyses
un_total_gap_fad_t <- un_fhad["start:Nondisabled_840","TOTAL"] - un_flad["start:Nondisabled_840","TOTAL"]
total_gap_fad_t <- sfinal_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]

## Elimination scenario disparities (higher minus lower SES)
d_alc_fad_t <- b1_fad["start:Nondisabled_840","TOTAL"] - a1_fad["start:Nondisabled_840","TOTAL"]
d_smk_fad_t <- b2_fad["start:Nondisabled_840","TOTAL"] - a2_fad["start:Nondisabled_840","TOTAL"]
d_act_fad_t <- b3_fad["start:Nondisabled_840","TOTAL"] - a3_fad["start:Nondisabled_840","TOTAL"]
d_obs_fad_t <- b4_fad["start:Nondisabled_840","TOTAL"] - a4_fad["start:Nondisabled_840","TOTAL"]
residual_fad_t <- bj_fad["start:Nondisabled_840","TOTAL"] - aj_fad["start:Nondisabled_840","TOTAL"]

## Proportion of remaining total life expectancy spent in an active state (lower and higher SES female)
prop_ale_flad <- (un_flad["start:Nondisabled_840","Nondisabled"]/un_flad["start:Nondisabled_840","TOTAL"])*100
prop_ale_fhad <- (un_fhad["start:Nondisabled_840","Nondisabled"]/un_fhad["start:Nondisabled_840","TOTAL"])*100
prop_dif_fad <- prop_ale_fhad - prop_ale_flad

## Contributions of lifestyle risk factors to disparities in active life expectancy and total life expectancy (female)
alc_cont_fad <- ((total_gap_fad - d_alc_fad)/total_gap_fad)*100
alc_cont_fad_t <- ((total_gap_fad_t - d_alc_fad_t)/total_gap_fad_t)*100
smk_cont_fad <- ((total_gap_fad - d_smk_fad)/total_gap_fad)*100
smk_cont_fad_t <- ((total_gap_fad_t - d_smk_fad_t)/total_gap_fad_t)*100
act_cont_fad <- ((total_gap_fad - d_act_fad)/total_gap_fad)*100
act_cont_fad_t <- ((total_gap_fad_t - d_act_fad_t)/total_gap_fad_t)*100
obs_cont_fad <- ((total_gap_fad - d_obs_fad)/total_gap_fad)*100
obs_cont_fad_t <- ((total_gap_fad_t - d_obs_fad_t)/total_gap_fad_t)*100
joint_cont_fad <- ((total_gap_fad - residual_fad)/total_gap_fad)*100
joint_cont_fad_t <- ((total_gap_fad_t - residual_fad_t)/total_gap_fad_t)*100

## Bootstrap function female
bootfun_fa <- function(data,dtms) {
  fit_w0a <- dtms_fit(data=data,
                      formula=to~from+time+I(time^2)+adi_cons)
  fit_wa <- dtms_fit(data=data,
                     formula=to~from+eth_bi+time+I(time^2)+last_nm_cc+adi_cons
                     +alc_cons+last_nm_smok+last_nm_pa+last_nm_ob)
  eth_gm_f <- mean(data$eth_bi[data$intbloc==0], na.rm = TRUE)
  alc_flad <- mean(data$alc_cons[data$adi_cons==0 & data$intbloc==0], na.rm = TRUE)
  alc_fhad <- mean(data$alc_cons[data$adi_cons==1 & data$intbloc==0], na.rm = TRUE)
  model_cc_gm_f <- lm(last_nm_cc ~ time+I(time^2),data=data)
  cc_controls_gm_f <- predict(model_cc_gm_f,newdata=data.frame(time=840:1319))
  model_smok_fad <- glm(last_nm_smok ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  smok_controls_flad <- predict(model_smok_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  smok_controls_fhad <- predict(model_smok_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  model_pa_fad <- glm(last_nm_pa ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  pa_controls_flad <- predict(model_pa_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  pa_controls_fhad <- predict(model_pa_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  model_ob_fad <- glm(last_nm_ob ~ (time+I(time^2))*adi_cons,data=data, family=binomial)
  ob_controls_flad <- predict(model_ob_fad,newdata=data.frame(time=840:1319,adi_cons=0),type="response")
  ob_controls_fhad <- predict(model_ob_fad,newdata=data.frame(time=840:1319,adi_cons=1),type="response")
  smok_elimination <- rep(0,times=480)
  pa_elimination <- rep(0,times=480)
  ob_elimination <- rep(0,times=480)
  unadjusted_lfad <- dtms_transitions(dtms=dtms,
                                      model=fit_w0a,
                                      controls=list(time=840:1319, adi_cons=0),
                                      ci=TRUE)
  unadjusted_hfad <- dtms_transitions(dtms=dtms,
                                      model=fit_w0a,
                                      controls=list(time=840:1319, adi_cons=1),
                                      ci=TRUE)
  prob_s0_lfad <- dtms_transitions(dtms=dtms,
                                   model=fit_wa,
                                   controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                 adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                                 last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                   ci=TRUE)
  prob_a1_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=0, alc_cons=0, last_nm_smok=smok_controls_flad, 
                                                last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                  ci=TRUE)
  prob_a2_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_flad, last_nm_ob=ob_controls_flad),
                                  ci=TRUE)
  prob_a3_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_flad),
                                  ci=TRUE)
  prob_a4_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=0, alc_cons=alc_flad, last_nm_smok=smok_controls_flad, 
                                                last_nm_pa=pa_controls_flad, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_aj_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=0, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_b1_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=1, alc_cons=0, last_nm_smok=smok_controls_fhad, 
                                                last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
                                  ci=TRUE)
  prob_b2_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
                                  ci=TRUE)
  prob_b3_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_controls_fhad),
                                  ci=TRUE)
  prob_b4_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                                last_nm_pa=pa_controls_fhad, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_bj_fad <- dtms_transitions(dtms=dtms,
                                  model=fit_wa,
                                  controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                adi_cons=1, alc_cons=0, last_nm_smok=smok_elimination, 
                                                last_nm_pa=pa_elimination, last_nm_ob=ob_elimination),
                                  ci=TRUE)
  prob_sfinal_hfad <- dtms_transitions(dtms=dtms,
                                       model=fit_wa,
                                       controls=list(eth_bi=eth_gm_f, time=840:1319, last_nm_cc=cc_controls_gm_f,
                                                     adi_cons=1, alc_cons=alc_fhad, last_nm_smok=smok_controls_fhad, 
                                                     last_nm_pa=pa_controls_fhad, last_nm_ob=ob_controls_fhad),
                                       ci=TRUE)
  limited <- c("Nondisabled")
  Sw <- dtms_start(dtms=dtms,
                   data=data,
                   start_state=limited)
  un_flad <- dtms_expectancy(probs=unadjusted_lfad,start_distr=Sw,dtms=dtms,start_state=limited)
  un_fhad <- dtms_expectancy(probs=unadjusted_hfad,start_distr=Sw,dtms=dtms,start_state=limited)
  s0_fad <- dtms_expectancy(probs=prob_s0_lfad,start_distr=Sw,dtms=dtms,start_state=limited)
  a1_fad <- dtms_expectancy(probs=prob_a1_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  a2_fad <- dtms_expectancy(probs=prob_a2_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  a3_fad <- dtms_expectancy(probs=prob_a3_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  a4_fad <- dtms_expectancy(probs=prob_a4_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  aj_fad <- dtms_expectancy(probs=prob_aj_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  b1_fad <- dtms_expectancy(probs=prob_b1_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  b2_fad <- dtms_expectancy(probs=prob_b2_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  b3_fad <- dtms_expectancy(probs=prob_b3_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  b4_fad <- dtms_expectancy(probs=prob_b4_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  bj_fad <- dtms_expectancy(probs=prob_bj_fad,start_distr=Sw,dtms=dtms,start_state=limited)
  sfinal_fad <- dtms_expectancy(probs=prob_sfinal_hfad,start_distr=Sw,dtms=dtms,start_state=limited)
  g_alc_lfad <- a1_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  g_smk_lfad <- a2_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  g_act_lfad <- a3_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  g_obs_lfad <- a4_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  g_joint_lfad <- aj_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  g_alc_hfad <- b1_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
  g_smk_hfad <- b2_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
  g_act_hfad <- b3_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
  g_obs_hfad <- b4_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
  g_joint_hfad <- bj_fad["start:Nondisabled_840","Nondisabled"] - sfinal_fad["start:Nondisabled_840","Nondisabled"]
  un_total_gap_fad <- un_fhad["start:Nondisabled_840","Nondisabled"] - un_flad["start:Nondisabled_840","Nondisabled"]
  total_gap_fad <- sfinal_fad["start:Nondisabled_840","Nondisabled"] - s0_fad["start:Nondisabled_840","Nondisabled"]
  d_alc_fad <- b1_fad["start:Nondisabled_840","Nondisabled"] - a1_fad["start:Nondisabled_840","Nondisabled"]
  d_smk_fad <- b2_fad["start:Nondisabled_840","Nondisabled"] - a2_fad["start:Nondisabled_840","Nondisabled"]
  d_act_fad <- b3_fad["start:Nondisabled_840","Nondisabled"] - a3_fad["start:Nondisabled_840","Nondisabled"]
  d_obs_fad <- b4_fad["start:Nondisabled_840","Nondisabled"] - a4_fad["start:Nondisabled_840","Nondisabled"]
  residual_fad <- bj_fad["start:Nondisabled_840","Nondisabled"] - aj_fad["start:Nondisabled_840","Nondisabled"]
  g_alc_lfad_t <- a1_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  g_smk_lfad_t <- a2_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  g_act_lfad_t <- a3_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  g_obs_lfad_t <- a4_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  g_joint_lfad_t <- aj_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  g_alc_hfad_t <- b1_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
  g_smk_hfad_t <- b2_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
  g_act_hfad_t <- b3_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
  g_obs_hfad_t <- b4_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
  g_joint_hfad_t <- bj_fad["start:Nondisabled_840","TOTAL"] - sfinal_fad["start:Nondisabled_840","TOTAL"]
  un_total_gap_fad_t <- un_fhad["start:Nondisabled_840","TOTAL"] - un_flad["start:Nondisabled_840","TOTAL"]
  total_gap_fad_t <- sfinal_fad["start:Nondisabled_840","TOTAL"] - s0_fad["start:Nondisabled_840","TOTAL"]
  d_alc_fad_t <- b1_fad["start:Nondisabled_840","TOTAL"] - a1_fad["start:Nondisabled_840","TOTAL"]
  d_smk_fad_t <- b2_fad["start:Nondisabled_840","TOTAL"] - a2_fad["start:Nondisabled_840","TOTAL"]
  d_act_fad_t <- b3_fad["start:Nondisabled_840","TOTAL"] - a3_fad["start:Nondisabled_840","TOTAL"]
  d_obs_fad_t <- b4_fad["start:Nondisabled_840","TOTAL"] - a4_fad["start:Nondisabled_840","TOTAL"]
  residual_fad_t <- bj_fad["start:Nondisabled_840","TOTAL"] - aj_fad["start:Nondisabled_840","TOTAL"]
  prop_ale_flad <- (un_flad["start:Nondisabled_840","Nondisabled"]/un_flad["start:Nondisabled_840","TOTAL"])*100
  prop_ale_fhad <- (un_fhad["start:Nondisabled_840","Nondisabled"]/un_fhad["start:Nondisabled_840","TOTAL"])*100
  prop_dif_fad <- prop_ale_fhad - prop_ale_flad
  alc_cont_fad <- ((total_gap_fad - d_alc_fad)/total_gap_fad)*100
  alc_cont_fad_t <- ((total_gap_fad_t - d_alc_fad_t)/total_gap_fad_t)*100
  smk_cont_fad <- ((total_gap_fad - d_smk_fad)/total_gap_fad)*100
  smk_cont_fad_t <- ((total_gap_fad_t - d_smk_fad_t)/total_gap_fad_t)*100
  act_cont_fad <- ((total_gap_fad - d_act_fad)/total_gap_fad)*100
  act_cont_fad_t <- ((total_gap_fad_t - d_act_fad_t)/total_gap_fad_t)*100
  obs_cont_fad <- ((total_gap_fad - d_obs_fad)/total_gap_fad)*100
  obs_cont_fad_t <- ((total_gap_fad_t - d_obs_fad_t)/total_gap_fad_t)*100
  joint_cont_fad <- ((total_gap_fad - residual_fad)/total_gap_fad)*100
  joint_cont_fad_t <- ((total_gap_fad_t - residual_fad_t)/total_gap_fad_t)*100
  rbind(un_flad,un_fhad,s0_fad,a1_fad,a2_fad,a3_fad,a4_fad,aj_fad,b1_fad,b2_fad,b3_fad,b4_fad,bj_fad,sfinal_fad,
        g_alc_lfad,g_smk_lfad,g_act_lfad,g_obs_lfad,g_joint_lfad,
        g_alc_hfad,g_smk_hfad,g_act_hfad,g_obs_hfad,g_joint_hfad,
        un_total_gap_fad,total_gap_fad,d_alc_fad,d_smk_fad,d_act_fad,d_obs_fad,residual_fad,
        g_alc_lfad_t,g_smk_lfad_t,g_act_lfad_t,g_obs_lfad_t,g_joint_lfad_t,
        g_alc_hfad_t,g_smk_hfad_t,g_act_hfad_t,g_obs_hfad_t,g_joint_hfad_t,
        un_total_gap_fad_t,total_gap_fad_t,d_alc_fad_t,d_smk_fad_t,d_act_fad_t,d_obs_fad_t,residual_fad_t,
        prop_ale_flad,prop_ale_fhad,prop_dif_fad,
        alc_cont_fad,alc_cont_fad_t,smk_cont_fad,smk_cont_fad_t,act_cont_fad,act_cont_fad_t,obs_cont_fad,obs_cont_fad_t,joint_cont_fad,joint_cont_fad_t)
}
## Bootstrap results female
bootresults_fa <- dtms_boot(data=estdata_w,
                            dtms=simple,
                            fun=bootfun_fa,
                            idvar="id",
                            rep=10000,
                            method="block",
                            parallel=TRUE,
                            cores=3)
summary(bootresults_fa)
save(bootresults_fa,file="Results-bootstrap-fa4bc-10000.Rda")

## Print estimates
un_mlad
un_mhad
s0_mad
a1_mad
a2_mad
a3_mad
a4_mad
aj_mad
b1_mad
b2_mad
b3_mad
b4_mad
bj_mad
sfinal_mad
g_alc_lmad
g_smk_lmad
g_act_lmad
g_obs_lmad
g_joint_lmad
g_alc_hmad
g_smk_hmad
g_act_hmad
g_obs_hmad
g_joint_hmad
un_total_gap_mad
total_gap_mad
d_alc_mad
d_smk_mad
d_act_mad
d_obs_mad
residual_mad
g_alc_lmad_t
g_smk_lmad_t
g_act_lmad_t
g_obs_lmad_t
g_joint_lmad_t
g_alc_hmad_t
g_smk_hmad_t
g_act_hmad_t
g_obs_hmad_t
g_joint_hmad_t
un_total_gap_mad_t
total_gap_mad_t
d_alc_mad_t
d_smk_mad_t
d_act_mad_t
d_obs_mad_t
residual_mad_t
prop_ale_mlad
prop_ale_mhad
prop_dif_mad
alc_cont_mad
alc_cont_mad_t
smk_cont_mad
smk_cont_mad_t
act_cont_mad
act_cont_mad_t
obs_cont_mad
obs_cont_mad_t
joint_cont_mad
joint_cont_mad_t

un_flad
un_fhad
s0_fad
a1_fad
a2_fad
a3_fad
a4_fad
aj_fad
b1_fad
b2_fad
b3_fad
b4_fad
bj_fad
sfinal_fad
g_alc_lfad
g_smk_lfad
g_act_lfad
g_obs_lfad
g_joint_lfad
g_alc_hfad
g_smk_hfad
g_act_hfad
g_obs_hfad
g_joint_hfad
un_total_gap_fad
total_gap_fad
d_alc_fad
d_smk_fad
d_act_fad
d_obs_fad
residual_fad
g_alc_lfad_t
g_smk_lfad_t
g_act_lfad_t
g_obs_lfad_t
g_joint_lfad_t
g_alc_hfad_t
g_smk_hfad_t
g_act_hfad_t
g_obs_hfad_t
g_joint_hfad_t
un_total_gap_fad_t
total_gap_fad_t
d_alc_fad_t
d_smk_fad_t
d_act_fad_t
d_obs_fad_t
residual_fad_t
prop_ale_flad
prop_ale_fhad
prop_dif_fad
alc_cont_fad
alc_cont_fad_t
smk_cont_fad
smk_cont_fad_t
act_cont_fad
act_cont_fad_t
obs_cont_fad
obs_cont_fad_t
joint_cont_fad
joint_cont_fad_t
