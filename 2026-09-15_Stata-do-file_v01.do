* SYNTAX for "Contributions of lifestyle risk factors to socio-economic disparities in active and total life expectancy among older adults: a longitudinal cohort study"

* STATA version: StataNow 19.5, MP-Parallel Edition

* STATA citation: StataCorp. 2025. Stata Statistical Software: Release 19. College Station, TX: StataCorp LLC. 

* Data access statement: Requests for access to data from the Precipitating Events Project for meritorious analyses from qualified investigators should be directed to Thomas M. Gill (thomas.gill@yale.edu). The syntax files are openly available at https://github.com/OliviaMalkowski/ALE-disparities-lifestyle.git.

* Import master dataset
import sas using "P:\projects\PEP\Master\f2f_master_analysisvar306.sas7bdat"
* Count total number of participants and observations
unique StudyID
* 754 individuals, 5215 observations
* Assigns a number in ascending order to each row of observations
gen ascnr = _n
* Generate a variable that assigns the observation number (i.e., 1 for first data collection timepoint, 2 for second data collection timepoint) to each row by participant ID
bysort StudyID(intdateF2F): gen obsnr = _n
* Generate a variable that assigns the number of total observations to each row of data for a given participant
bysort StudyID: gen obscount = _N
* Check outcome code for comprehensive assessments that were refused
tab fout_fu if respondent==.
* Drop comprehensive assessments that were refused
drop if respondent==.
* Count total number of participants and observations
unique StudyID
* 754 individuals, 5168 observations
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save master dataset with a new name
save master.dta
clear 

* Import baseline data
import sas using "P:\projects\PEP\Master\baseface.sas7bdat"
* Keep relevant variables
keep STUDYID fc5_pasebl age_b GDI1 INC female white edu_cont edu7cat age5cat BMI_bl highbp mi chf stroke cancer diabetes hipfx otherfx arthrit parkinsn legamput liver lung_d ccsumbl1 ccsumbl2 diff4adl diff7adl dep3adl diff3adl walk_dev hp_walk ds_walk hp_stair ds_stair hp_carry ds_carry hp_shop ds_shop hp_clean ds_clean hp_meal ds_meal hp_meds ds_meds hp_bills ds_bills iadl_dep iadl_dis hp_mobil ds_mobil bloc_cat blocksbl adl24_bl adl12ms badl14bl iadl10bl mobdisbl intdtebl mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9cw mpasebl alc_bl smoker_bl
* Rename variables to ensure consistency across intervals
rename * raw_*
* Generate a new variable called interval and assign the number 1 to each observation
gen interval = 1
* Rename raw_STUDYID variable to ensure consistency with master dataset
rename raw_STUDYID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save baseline dataset with a new name
save other_vrb1.dta
clear

* Import 18-month follow-up data
import sas using "P:\projects\PEP\Master\fu18face.sas7bdat"
* Keep relevant variables
keep STUDYID fc5_pase18 age_18 female white edu_cont agecat18 BMI_18 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_18 mi_18 chf_18 strok_18 cancr_18 diab_18 hipfx_18 lungd_18 arth_18 ccsum18a ccsum18b ccsum18c d_4adl18 d_7adl18 d_3adl18 hp3adl18 walkd_18 hpwalk18 dswalk18 hpstir18 dsstir18 hpcary18 dscary18 hpshop18 dsshop18 hpclen18 dsclen18 hpmeal18 dsmeal18 hpmeds18 dsmeds18 hpbill18 dsbill18 iadlhp18 iadlds18 hp_mob18 ds_mob18 bloc_c18 blocks18 adl24_18 adl12ms badl1418 iadl1018 mobdis18 intdate18 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase18 alc_18 smoker_18
* Rename variables to ensure consistency across intervals
rename fc5_pase18 fc5_pasebl
rename BMI_18 BMI_bl
rename agecat18 age5cat
rename age_18 age_b
rename ccsum18a ccsumbl1
rename ccsum18c ccsumbl2
rename Cancer cancer
rename d_4adl18 diff4adl 
rename d_7adl18 diff7adl
rename d_3adl18 diff3adl 
rename hp3adl18 dep3adl 
rename walkd_18 walk_dev
rename hpwalk18 hp_walk
rename dswalk18 ds_walk
rename hpstir18 hp_stair
rename dsstir18 ds_stair
rename hpcary18 hp_carry
rename dscary18 ds_carry
rename hpshop18 hp_shop
rename dsshop18 ds_shop 
rename hpclen18 hp_clean
rename dsclen18 ds_clean
rename hpmeal18 hp_meal
rename dsmeal18 ds_meal
rename hpmeds18 hp_meds
rename dsmeds18 ds_meds
rename hpbill18 hp_bills
rename dsbill18 ds_bills
rename iadlhp18 iadl_dep
rename iadlds18 iadl_dis
rename hp_mob18 hp_mobil
rename ds_mob18 ds_mobil
rename bloc_c18 bloc_cat
rename blocks18 blocksbl
rename adl24_18 adl24_bl
rename badl1418 badl14bl
rename iadl1018 iadl10bl
rename mobdis18 mobdisbl
rename mpase9bw mpase9cw
rename mpase18 mpasebl
rename alc_18 alc_bl
rename smoker_18 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 2 to each observation
gen interval = 2
* Rename raw_STUDYID variable to ensure consistency with master dataset
rename raw_STUDYID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 18-month follow-up dataset with a new name
save other_vrb2.dta
clear

* Import 36-month follow-up data
import sas using "P:\projects\PEP\Master\fu36face.sas7bdat"
* Keep relevant variables
keep StudyID fc5_pase36 age_36 female white edu_cont agecat36 BMI_36 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_36 mi_36 chf_36 strok_36 cancr_36 diab_36 hipfx_36 lungd_36 arth_36 ccsum36a ccsum36b ccsum36c d_4adl36 d_7adl36 d_3adl36 hp3adl36 walkd_36 hpwalk36 dswalk36 hpstir36 dsstir36 hpcary36 dscary36 hpshop36 dsshop36 hpclen36 dsclen36 hpmeal36 dsmeal36 hpmeds36 dsmeds36 hpbill36 dsbill36 iadlhp36 iadlds36 hp_mob36 ds_mob36 bloc_c36 blocks36 adl24_36 adl12ms badl1436 iadl1036 mobdis36 intdate36 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase36 smoker_36
* Rename variables to ensure consistency across intervals
rename fc5_pase36 fc5_pasebl
rename BMI_36 BMI_bl
rename agecat36 age5cat
rename age_36 age_b
rename ccsum36a ccsumbl1
rename ccsum36c ccsumbl2
rename Cancer cancer
rename d_4adl36 diff4adl 
rename d_7adl36 diff7adl
rename d_3adl36 diff3adl 
rename hp3adl36 dep3adl 
rename walkd_36 walk_dev
rename hpwalk36 hp_walk
rename dswalk36 ds_walk
rename hpstir36 hp_stair
rename dsstir36 ds_stair
rename hpcary36 hp_carry
rename dscary36 ds_carry
rename hpshop36 hp_shop
rename dsshop36 ds_shop 
rename hpclen36 hp_clean
rename dsclen36 ds_clean
rename hpmeal36 hp_meal
rename dsmeal36 ds_meal
rename hpmeds36 hp_meds
rename dsmeds36 ds_meds
rename hpbill36 hp_bills
rename dsbill36 ds_bills
rename iadlhp36 iadl_dep
rename iadlds36 iadl_dis
rename hp_mob36 hp_mobil
rename ds_mob36 ds_mobil
rename bloc_c36 bloc_cat
rename blocks36 blocksbl
rename adl24_36 adl24_bl
rename badl1436 badl14bl
rename iadl1036 iadl10bl
rename mobdis36 mobdisbl
rename mpase9bw mpase9cw
rename mpase36 mpasebl
rename smoker_36 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 3 to each observation
gen interval = 3
* Rename raw_StudyID variable to ensure consistency with master dataset
rename raw_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 36-month follow-up dataset with a new name
save other_vrb3.dta
clear

* Import 54-month follow-up data
import sas using "P:\projects\PEP\Master\fu54face.sas7bdat"
* Keep relevant variables
keep StudyID fc5_pase54 age_54 female white edu_cont agecat54 BMI_54 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_54 mi_54 chf_54 strok_54 cancr_54 diab_54 hipfx_54 lungd_54 arth_54 ccsum54a ccsum54b ccsum54c d_4adl54 d_7adl54 d_3adl54 hp3adl54 walkd_54 hpwalk54 dswalk54 hpstir54 dsstir54 hpcary54 dscary54 hpshop54 dsshop54 hpclen54 dsclen54 hpmeal54 dsmeal54 hpmeds54 dsmeds54 hpbill54 dsbill54 iadlhp54 iadlds54 hp_mob54 ds_mob54 bloc_c54 blocks54 adl24_54 adl12ms badl1454 iadl1054 mobdis54 intdate54 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase54 smoker_54
* Rename variables to ensure consistency across intervals
rename fc5_pase54 fc5_pasebl
rename BMI_54 BMI_bl
rename agecat54 age5cat
rename age_54 age_b
rename ccsum54a ccsumbl1
rename ccsum54c ccsumbl2
rename Cancer cancer
rename d_4adl54 diff4adl 
rename d_7adl54 diff7adl
rename d_3adl54 diff3adl 
rename hp3adl54 dep3adl 
rename walkd_54 walk_dev
rename hpwalk54 hp_walk
rename dswalk54 ds_walk
rename hpstir54 hp_stair
rename dsstir54 ds_stair
rename hpcary54 hp_carry
rename dscary54 ds_carry
rename hpshop54 hp_shop
rename dsshop54 ds_shop 
rename hpclen54 hp_clean
rename dsclen54 ds_clean
rename hpmeal54 hp_meal
rename dsmeal54 ds_meal
rename hpmeds54 hp_meds
rename dsmeds54 ds_meds
rename hpbill54 hp_bills
rename dsbill54 ds_bills
rename iadlhp54 iadl_dep
rename iadlds54 iadl_dis
rename hp_mob54 hp_mobil
rename ds_mob54 ds_mobil
rename bloc_c54 bloc_cat
rename blocks54 blocksbl
rename adl24_54 adl24_bl
rename badl1454 badl14bl
rename iadl1054 iadl10bl
rename mobdis54 mobdisbl
rename mpase9bw mpase9cw
rename mpase54 mpasebl
rename smoker_54 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 4 to each observation
gen interval = 4
* Rename raw_StudyID variable to ensure consistency with master dataset
rename raw_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 54-month follow-up dataset with a new name
save other_vrb4.dta
clear

* Import 72-month follow-up data
import sas using "P:\projects\PEP\Master\fu72face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase72 age_72 female white edu_cont agecat72 BMI_72 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_72 mi_72 chf_72 strok_72 cancr_72 diab_72 hipfx_72 lungd_72 arth_72 ccsum72a ccsum72b ccsum72c d_4adl72 d_7adl72 d_3adl72 hp3adl72 walkd_72 hpwalk72 dswalk72 hpstir72 dsstir72 hpcary72 dscary72 hpshop72 dsshop72 hpclen72 dsclen72 hpmeal72 dsmeal72 hpmeds72 dsmeds72 hpbill72 dsbill72 iadlhp72 iadlds72 hp_mob72 ds_mob72 bloc_c72 blocks72 adl24_72 adl12ms badl1472 iadl1072 mobdis72 intdate72 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase72 smoker_72
* Rename variables to ensure consistency across intervals
rename fc5_pase72 fc5_pasebl
rename BMI_72 BMI_bl
rename agecat72 age5cat
rename age_72 age_b
rename ccsum72a ccsumbl1
rename ccsum72c ccsumbl2
rename Cancer cancer
rename d_4adl72 diff4adl 
rename d_7adl72 diff7adl
rename d_3adl72 diff3adl 
rename hp3adl72 dep3adl 
rename walkd_72 walk_dev
rename hpwalk72 hp_walk
rename dswalk72 ds_walk
rename hpstir72 hp_stair
rename dsstir72 ds_stair
rename hpcary72 hp_carry
rename dscary72 ds_carry
rename hpshop72 hp_shop
rename dsshop72 ds_shop 
rename hpclen72 hp_clean
rename dsclen72 ds_clean
rename hpmeal72 hp_meal
rename dsmeal72 ds_meal
rename hpmeds72 hp_meds
rename dsmeds72 ds_meds
rename hpbill72 hp_bills
rename dsbill72 ds_bills
rename iadlhp72 iadl_dep
rename iadlds72 iadl_dis
rename hp_mob72 hp_mobil
rename ds_mob72 ds_mobil
rename bloc_c72 bloc_cat
rename blocks72 blocksbl
rename adl24_72 adl24_bl
rename badl1472 badl14bl
rename iadl1072 iadl10bl
rename mobdis72 mobdisbl
rename mpase9bw mpase9cw
rename mpase72 mpasebl
rename smoker_72 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 5 to each observation
gen interval = 5
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 72-month follow-up dataset with a new name
save other_vrb5.dta
clear

* Import 90-month follow-up data
import sas using "P:\projects\PEP\Master\fu90face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase90 age_90 female white edu_cont agecat90 BMI_90 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_90 mi_90 chf_90 strok_90 cancr_90 diab_90 hipfx_90 lungd_90 arth_90 ccsum90a ccsum90b ccsum90c d_4adl90 d_7adl90 d_3adl90 hp3adl90 walkd_90 hpwalk90 dswalk90 hpstir90 dsstir90 hpcary90 dscary90 hpshop90 dsshop90 hpclen90 dsclen90 hpmeal90 dsmeal90 hpmeds90 dsmeds90 hpbill90 dsbill90 iadlhp90 iadlds90 hp_mob90 ds_mob90 bloc_c90 blocks90 adl24_90 adl12ms badl1490 iadl1090 mobdis90 intdate90 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase90 smoker_90
* Rename variables to ensure consistency across intervals
rename fc5_pase90 fc5_pasebl
rename BMI_90 BMI_bl
rename agecat90 age5cat
rename age_90 age_b
rename ccsum90a ccsumbl1
rename ccsum90c ccsumbl2
rename Cancer cancer
rename d_4adl90 diff4adl 
rename d_7adl90 diff7adl
rename d_3adl90 diff3adl 
rename hp3adl90 dep3adl 
rename walkd_90 walk_dev
rename hpwalk90 hp_walk
rename dswalk90 ds_walk
rename hpstir90 hp_stair
rename dsstir90 ds_stair
rename hpcary90 hp_carry
rename dscary90 ds_carry
rename hpshop90 hp_shop
rename dsshop90 ds_shop 
rename hpclen90 hp_clean
rename dsclen90 ds_clean
rename hpmeal90 hp_meal
rename dsmeal90 ds_meal
rename hpmeds90 hp_meds
rename dsmeds90 ds_meds
rename hpbill90 hp_bills
rename dsbill90 ds_bills
rename iadlhp90 iadl_dep
rename iadlds90 iadl_dis
rename hp_mob90 hp_mobil
rename ds_mob90 ds_mobil
rename bloc_c90 bloc_cat
rename blocks90 blocksbl
rename adl24_90 adl24_bl
rename badl1490 badl14bl
rename iadl1090 iadl10bl
rename mobdis90 mobdisbl
rename mpase9bw mpase9cw
rename mpase90 mpasebl
rename smoker_90 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 6 to each observation
gen interval = 6
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 90-month follow-up dataset with a new name
save other_vrb6.dta
clear

* Import 108-month follow-up data
import sas using "P:\projects\PEP\Master\fu108face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase108 age_108 female white edu_cont agecat108 BMI_108 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_108 mi_108 chf_108 strok_108 cancr_108 diab_108 hipfx_108 lungd_108 arth_108 ccsum108a ccsum108b ccsum108c d_4adl108 d_7adl108 d_3adl108 hp3adl108 walkd_108 hpwalk108 dswalk108 hpstir108 dsstir108 hpcary108 dscary108 hpshop108 dsshop108 hpclen108 dsclen108 hpmeal108 dsmeal108 hpmeds108 dsmeds108 hpbill108 dsbill108 iadlhp108 iadlds108 hp_mob108 ds_mob108 bloc_c108 blocks108 adl24_108 adl12ms badl14108 iadl10108 mobdis108 intdate108 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase108 smoker_108
* Rename variables to ensure consistency across intervals
rename fc5_pase108 fc5_pasebl
rename BMI_108 BMI_bl
rename agecat108 age5cat
rename age_108 age_b
rename ccsum108a ccsumbl1
rename ccsum108c ccsumbl2
rename Cancer cancer
rename d_4adl108 diff4adl 
rename d_7adl108 diff7adl
rename d_3adl108 diff3adl 
rename hp3adl108 dep3adl 
rename walkd_108 walk_dev
rename hpwalk108 hp_walk
rename dswalk108 ds_walk
rename hpstir108 hp_stair
rename dsstir108 ds_stair
rename hpcary108 hp_carry
rename dscary108 ds_carry
rename hpshop108 hp_shop
rename dsshop108 ds_shop 
rename hpclen108 hp_clean
rename dsclen108 ds_clean
rename hpmeal108 hp_meal
rename dsmeal108 ds_meal
rename hpmeds108 hp_meds
rename dsmeds108 ds_meds
rename hpbill108 hp_bills
rename dsbill108 ds_bills
rename iadlhp108 iadl_dep
rename iadlds108 iadl_dis
rename hp_mob108 hp_mobil
rename ds_mob108 ds_mobil
rename bloc_c108 bloc_cat
rename blocks108 blocksbl
rename adl24_108 adl24_bl
rename badl14108 badl14bl
rename iadl10108 iadl10bl
rename mobdis108 mobdisbl
rename mpase9bw mpase9cw
rename mpase108 mpasebl
rename smoker_108 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 7 to each observation
gen interval = 7
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 108-month follow-up dataset with a new name
save other_vrb7.dta
clear

* Import 144-month follow-up data
import sas using "P:\projects\PEP\Master\fu144face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase144 age_144 female white edu_cont agecat144 BMI_144 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_144 mi_144 chf_144 strok_144 cancr_144 diab_144 hipfx_144 lungd_144 arth_144 ccsum144a ccsum144b ccsum144c d_4adl144 d_7adl144 d_3adl144 hp3adl144 walkd_144 hpwalk144 dswalk144 hpstir144 dsstir144 hpcary144 dscary144 hpshop144 dsshop144 hpclen144 dsclen144 hpmeal144 dsmeal144 hpmeds144 dsmeds144 hpbill144 dsbill144 iadlhp144 iadlds144 hp_mob144 ds_mob144 bloc_c144 blocks144 adl24_144 adl12ms badl14144 iadl10144 mobdis144 intdate144 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase144 smoker_144
* Rename variables to ensure consistency across intervals
rename fc5_pase144 fc5_pasebl
rename BMI_144 BMI_bl
rename agecat144 age5cat
rename age_144 age_b
rename ccsum144a ccsumbl1
rename ccsum144c ccsumbl2
rename Cancer cancer
rename d_4adl144 diff4adl 
rename d_7adl144 diff7adl
rename d_3adl144 diff3adl 
rename hp3adl144 dep3adl 
rename walkd_144 walk_dev
rename hpwalk144 hp_walk
rename dswalk144 ds_walk
rename hpstir144 hp_stair
rename dsstir144 ds_stair
rename hpcary144 hp_carry
rename dscary144 ds_carry
rename hpshop144 hp_shop
rename dsshop144 ds_shop 
rename hpclen144 hp_clean
rename dsclen144 ds_clean
rename hpmeal144 hp_meal
rename dsmeal144 ds_meal
rename hpmeds144 hp_meds
rename dsmeds144 ds_meds
rename hpbill144 hp_bills
rename dsbill144 ds_bills
rename iadlhp144 iadl_dep
rename iadlds144 iadl_dis
rename hp_mob144 hp_mobil
rename ds_mob144 ds_mobil
rename bloc_c144 bloc_cat
rename blocks144 blocksbl
rename adl24_144 adl24_bl
rename badl14144 badl14bl
rename iadl10144 iadl10bl
rename mobdis144 mobdisbl
rename mpase9bw mpase9cw
rename mpase144 mpasebl
rename smoker_144 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 9 to each observation
gen interval = 9
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 144-month follow-up dataset with a new name
save other_vrb9.dta
clear

* Import 162-month follow-up data
import sas using "P:\projects\PEP\Master\fu162face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase162 age_162 female white edu_cont agecat162 BMI_162 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_162 mi_162 chf_162 strok_162 cancr_162 diab_162 hipfx_162 lungd_162 arth_162 ccsum162a ccsum162b ccsum162c d_4adl162 d_7adl162 d_3adl162 hp3adl162 walkd_162 hpwalk162 dswalk162 hpstir162 dsstir162 hpcary162 dscary162 hpshop162 dsshop162 hpclen162 dsclen162 hpmeal162 dsmeal162 hpmeds162 dsmeds162 hpbill162 dsbill162 iadlhp162 iadlds162 hp_mob162 ds_mob162 bloc_c162 blocks162 adl24_162 adl12ms badl14162 iadl10162 mobdis162 intdate162 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase162 smoker_162
* Rename variables to ensure consistency across intervals
rename fc5_pase162 fc5_pasebl
rename BMI_162 BMI_bl
rename agecat162 age5cat
rename age_162 age_b
rename ccsum162a ccsumbl1
rename ccsum162c ccsumbl2
rename Cancer cancer
rename d_4adl162 diff4adl 
rename d_7adl162 diff7adl
rename d_3adl162 diff3adl 
rename hp3adl162 dep3adl 
rename walkd_162 walk_dev
rename hpwalk162 hp_walk
rename dswalk162 ds_walk
rename hpstir162 hp_stair
rename dsstir162 ds_stair
rename hpcary162 hp_carry
rename dscary162 ds_carry
rename hpshop162 hp_shop
rename dsshop162 ds_shop 
rename hpclen162 hp_clean
rename dsclen162 ds_clean
rename hpmeal162 hp_meal
rename dsmeal162 ds_meal
rename hpmeds162 hp_meds
rename dsmeds162 ds_meds
rename hpbill162 hp_bills
rename dsbill162 ds_bills
rename iadlhp162 iadl_dep
rename iadlds162 iadl_dis
rename hp_mob162 hp_mobil
rename ds_mob162 ds_mobil
rename bloc_c162 bloc_cat
rename blocks162 blocksbl
rename adl24_162 adl24_bl
rename badl14162 badl14bl
rename iadl10162 iadl10bl
rename mobdis162 mobdisbl
rename mpase9bw mpase9cw
rename mpase162 mpasebl
rename smoker_162 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 10 to each observation
gen interval = 10
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 162-month follow-up dataset with a new name
save other_vrb10.dta
clear

* Import 180-month follow-up data
import sas using "P:\projects\PEP\Master\fu180face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase180 age_180 female white edu_cont agecat180 BMI_180 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_180 mi_180 chf_180 strok_180 cancr_180 diab_180 hipfx_180 lungd_180 arth_180 ccsum180a ccsum180b ccsum180c d_4adl180 d_7adl180 d_3adl180 hp3adl180 walkd_180 hpwalk180 dswalk180 hpstir180 dsstir180 hpcary180 dscary180 hpshop180 dsshop180 hpclen180 dsclen180 hpmeal180 dsmeal180 hpmeds180 dsmeds180 hpbill180 dsbill180 iadlhp180 iadlds180 hp_mob180 ds_mob180 bloc_c180 blocks180 adl24_180 adl12ms badl14180 iadl10180 mobdis180 intdate180 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase180 smoker_180
* Rename variables to ensure consistency across intervals
rename fc5_pase180 fc5_pasebl
rename BMI_180 BMI_bl
rename agecat180 age5cat
rename age_180 age_b
rename ccsum180a ccsumbl1
rename ccsum180c ccsumbl2
rename Cancer cancer
rename d_4adl180 diff4adl 
rename d_7adl180 diff7adl
rename d_3adl180 diff3adl 
rename hp3adl180 dep3adl 
rename walkd_180 walk_dev
rename hpwalk180 hp_walk
rename dswalk180 ds_walk
rename hpstir180 hp_stair
rename dsstir180 ds_stair
rename hpcary180 hp_carry
rename dscary180 ds_carry
rename hpshop180 hp_shop
rename dsshop180 ds_shop 
rename hpclen180 hp_clean
rename dsclen180 ds_clean
rename hpmeal180 hp_meal
rename dsmeal180 ds_meal
rename hpmeds180 hp_meds
rename dsmeds180 ds_meds
rename hpbill180 hp_bills
rename dsbill180 ds_bills
rename iadlhp180 iadl_dep
rename iadlds180 iadl_dis
rename hp_mob180 hp_mobil
rename ds_mob180 ds_mobil
rename bloc_c180 bloc_cat
rename blocks180 blocksbl
rename adl24_180 adl24_bl
rename badl14180 badl14bl
rename iadl10180 iadl10bl
rename mobdis180 mobdisbl
rename mpase9bw mpase9cw
rename mpase180 mpasebl
rename smoker_180 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 11 to each observation
gen interval = 11
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 180-month follow-up dataset with a new name
save other_vrb11.dta
clear

* Import 198-month follow-up data
import sas using "P:\projects\PEP\Master\fu198face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase198 age_198 female white edu_cont agecat198 BMI_198 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_198 mi_198 chf_198 strok_198 cancr_198 diab_198 hipfx_198 lungd_198 arth_198 ccsum198a ccsum198b ccsum198c d_4adl198 d_7adl198 d_3adl198 hp3adl198 walkd_198 hpwalk198 dswalk198 hpstir198 dsstir198 hpcary198 dscary198 hpshop198 dsshop198 hpclen198 dsclen198 hpmeal198 dsmeal198 hpmeds198 dsmeds198 hpbill198 dsbill198 iadlhp198 iadlds198 hp_mob198 ds_mob198 bloc_c198 blocks198 adl24_198 adl12ms badl14198 iadl10198 mobdis198 intdate198 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase198 smoker_198
* Rename variables to ensure consistency across intervals
rename fc5_pase198 fc5_pasebl
rename BMI_198 BMI_bl
rename agecat198 age5cat
rename age_198 age_b
rename ccsum198a ccsumbl1
rename ccsum198c ccsumbl2
rename Cancer cancer
rename d_4adl198 diff4adl 
rename d_7adl198 diff7adl
rename d_3adl198 diff3adl 
rename hp3adl198 dep3adl 
rename walkd_198 walk_dev
rename hpwalk198 hp_walk
rename dswalk198 ds_walk
rename hpstir198 hp_stair
rename dsstir198 ds_stair
rename hpcary198 hp_carry
rename dscary198 ds_carry
rename hpshop198 hp_shop
rename dsshop198 ds_shop 
rename hpclen198 hp_clean
rename dsclen198 ds_clean
rename hpmeal198 hp_meal
rename dsmeal198 ds_meal
rename hpmeds198 hp_meds
rename dsmeds198 ds_meds
rename hpbill198 hp_bills
rename dsbill198 ds_bills
rename iadlhp198 iadl_dep
rename iadlds198 iadl_dis
rename hp_mob198 hp_mobil
rename ds_mob198 ds_mobil
rename bloc_c198 bloc_cat
rename blocks198 blocksbl
rename adl24_198 adl24_bl
rename badl14198 badl14bl
rename iadl10198 iadl10bl
rename mobdis198 mobdisbl
rename mpase9bw mpase9cw
rename mpase198 mpasebl
rename smoker_198 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 12 to each observation
gen interval = 12
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 198-month follow-up dataset with a new name
save other_vrb12.dta
clear

* Import 216-month follow-up data
import sas using "P:\projects\PEP\Master\fu216face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase216 age_216 female white edu_cont agecat216 BMI_216 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_216 mi_216 chf_216 strok_216 cancr_216 diab_216 hipfx_216 lungd_216 arth_216 ccsum216a ccsum216b ccsum216c d_4adl216 d_7adl216 d_3adl216 hp3adl216 walkd_216 hpwalk216 dswalk216 hpstir216 dsstir216 hpcary216 dscary216 hpshop216 dsshop216 hpclen216 dsclen216 hpmeal216 dsmeal216 hpmeds216 dsmeds216 hpbill216 dsbill216 iadlhp216 iadlds216 hp_mob216 ds_mob216 bloc_c216 blocks216 adl24_216 adl12ms badl14216 iadl10216 mobdis216 intdate216 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase216 smoker_216
* Rename variables to ensure consistency across intervals
rename fc5_pase216 fc5_pasebl
rename BMI_216 BMI_bl
rename agecat216 age5cat
rename age_216 age_b
rename ccsum216a ccsumbl1
rename ccsum216c ccsumbl2
rename Cancer cancer
rename d_4adl216 diff4adl 
rename d_7adl216 diff7adl
rename d_3adl216 diff3adl 
rename hp3adl216 dep3adl 
rename walkd_216 walk_dev
rename hpwalk216 hp_walk
rename dswalk216 ds_walk
rename hpstir216 hp_stair
rename dsstir216 ds_stair
rename hpcary216 hp_carry
rename dscary216 ds_carry
rename hpshop216 hp_shop
rename dsshop216 ds_shop 
rename hpclen216 hp_clean
rename dsclen216 ds_clean
rename hpmeal216 hp_meal
rename dsmeal216 ds_meal
rename hpmeds216 hp_meds
rename dsmeds216 ds_meds
rename hpbill216 hp_bills
rename dsbill216 ds_bills
rename iadlhp216 iadl_dep
rename iadlds216 iadl_dis
rename hp_mob216 hp_mobil
rename ds_mob216 ds_mobil
rename bloc_c216 bloc_cat
rename blocks216 blocksbl
rename adl24_216 adl24_bl
rename badl14216 badl14bl
rename iadl10216 iadl10bl
rename mobdis216 mobdisbl
rename mpase9bw mpase9cw
rename mpase216 mpasebl
rename smoker_216 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 13 to each observation
gen interval = 13
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 216-month follow-up dataset with a new name
save other_vrb13.dta
clear

* Import 234-month follow-up data
import sas using "P:\projects\PEP\Master\fu234face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase234 age_234 female white edu_cont agecat234 BMI_234 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_234 mi_234 chf_234 strok_234 cancr_234 diab_234 hipfx_234 lungd_234 arth_234 ccsum234a ccsum234b ccsum234c d_4adl234 d_7adl234 d_3adl234 hp3adl234 walkd_234 hpwalk234 dswalk234 hpstir234 dsstir234 hpcary234 dscary234 hpshop234 dsshop234 hpclen234 dsclen234 hpmeal234 dsmeal234 hpmeds234 dsmeds234 hpbill234 dsbill234 iadlhp234 iadlds234 hp_mob234 ds_mob234 bloc_c234 blocks234 adl24_234 adl12ms badl14234 iadl10234 mobdis234 intdate234 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase234 smoker_234
* Rename variables to ensure consistency across intervals
rename fc5_pase234 fc5_pasebl
rename BMI_234 BMI_bl
rename agecat234 age5cat
rename age_234 age_b
rename ccsum234a ccsumbl1
rename ccsum234c ccsumbl2
rename Cancer cancer
rename d_4adl234 diff4adl 
rename d_7adl234 diff7adl
rename d_3adl234 diff3adl 
rename hp3adl234 dep3adl 
rename walkd_234 walk_dev
rename hpwalk234 hp_walk
rename dswalk234 ds_walk
rename hpstir234 hp_stair
rename dsstir234 ds_stair
rename hpcary234 hp_carry
rename dscary234 ds_carry
rename hpshop234 hp_shop
rename dsshop234 ds_shop 
rename hpclen234 hp_clean
rename dsclen234 ds_clean
rename hpmeal234 hp_meal
rename dsmeal234 ds_meal
rename hpmeds234 hp_meds
rename dsmeds234 ds_meds
rename hpbill234 hp_bills
rename dsbill234 ds_bills
rename iadlhp234 iadl_dep
rename iadlds234 iadl_dis
rename hp_mob234 hp_mobil
rename ds_mob234 ds_mobil
rename bloc_c234 bloc_cat
rename blocks234 blocksbl
rename adl24_234 adl24_bl
rename badl14234 badl14bl
rename iadl10234 iadl10bl
rename mobdis234 mobdisbl
rename mpase9bw mpase9cw
rename mpase234 mpasebl
rename smoker_234 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 14 to each observation
gen interval = 14
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 234-month follow-up dataset with a new name
save other_vrb14.dta
clear

* Import 252-month follow-up data
import sas using "P:\projects\PEP\Master\fu252face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase252 age_252 female white edu_cont agecat252 BMI_252 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_252 mi_252 chf_252 strok_252 cancr_252 diab_252 hipfx_252 lungd_252 arth_252 ccsum252a ccsum252b ccsum252c d_4adl252 d_7adl252 d_3adl252 hp3adl252 walkd_252 hpwalk252 dswalk252 hpstir252 dsstir252 hpcary252 dscary252 hpshop252 dsshop252 hpclen252 dsclen252 hpmeal252 dsmeal252 hpmeds252 dsmeds252 hpbill252 dsbill252 iadlhp252 iadlds252 hp_mob252 ds_mob252 bloc_c252 blocks252 adl24_252 adl12ms badl14252 iadl10252 mobdis252 intdate252 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase252 smoker_252
* Rename variables to ensure consistency across intervals
rename fc5_pase252 fc5_pasebl
rename BMI_252 BMI_bl
rename agecat252 age5cat
rename age_252 age_b
rename ccsum252a ccsumbl1
rename ccsum252c ccsumbl2
rename Cancer cancer
rename d_4adl252 diff4adl 
rename d_7adl252 diff7adl
rename d_3adl252 diff3adl 
rename hp3adl252 dep3adl 
rename walkd_252 walk_dev
rename hpwalk252 hp_walk
rename dswalk252 ds_walk
rename hpstir252 hp_stair
rename dsstir252 ds_stair
rename hpcary252 hp_carry
rename dscary252 ds_carry
rename hpshop252 hp_shop
rename dsshop252 ds_shop 
rename hpclen252 hp_clean
rename dsclen252 ds_clean
rename hpmeal252 hp_meal
rename dsmeal252 ds_meal
rename hpmeds252 hp_meds
rename dsmeds252 ds_meds
rename hpbill252 hp_bills
rename dsbill252 ds_bills
rename iadlhp252 iadl_dep
rename iadlds252 iadl_dis
rename hp_mob252 hp_mobil
rename ds_mob252 ds_mobil
rename bloc_c252 bloc_cat
rename blocks252 blocksbl
rename adl24_252 adl24_bl
rename badl14252 badl14bl
rename iadl10252 iadl10bl
rename mobdis252 mobdisbl
rename mpase9bw mpase9cw
rename mpase252 mpasebl
rename smoker_252 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 15 to each observation
gen interval = 15
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 252-month follow-up dataset with a new name
save other_vrb15.dta
clear

* Import 270-month follow-up data
import sas using "P:\projects\PEP\Master\fu270face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase270 age_270 female white edu_cont agecat270 BMI_270 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_270 mi_270 chf_270 strok_270 cancr_270 diab_270 hipfx_270 lungd_270 arth_270 ccsum270a ccsum270b ccsum270c d_4adl270 d_7adl270 d_3adl270 hp3adl270 walkd_270 hpwalk270 dswalk270 hpstir270 dsstir270 hpcary270 dscary270 hpshop270 dsshop270 hpclen270 dsclen270 hpmeal270 dsmeal270 hpmeds270 dsmeds270 hpbill270 dsbill270 iadlhp270 iadlds270 hp_mob270 ds_mob270 bloc_c270 blocks270 adl24_270 adl12ms badl14270 iadl10270 mobdis270 intdate270 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase270 smoker_270
* Rename variables to ensure consistency across intervals
rename fc5_pase270 fc5_pasebl
rename BMI_270 BMI_bl
rename agecat270 age5cat
rename age_270 age_b
rename ccsum270a ccsumbl1
rename ccsum270c ccsumbl2
rename Cancer cancer
rename d_4adl270 diff4adl 
rename d_7adl270 diff7adl
rename d_3adl270 diff3adl 
rename hp3adl270 dep3adl 
rename walkd_270 walk_dev
rename hpwalk270 hp_walk
rename dswalk270 ds_walk
rename hpstir270 hp_stair
rename dsstir270 ds_stair
rename hpcary270 hp_carry
rename dscary270 ds_carry
rename hpshop270 hp_shop
rename dsshop270 ds_shop 
rename hpclen270 hp_clean
rename dsclen270 ds_clean
rename hpmeal270 hp_meal
rename dsmeal270 ds_meal
rename hpmeds270 hp_meds
rename dsmeds270 ds_meds
rename hpbill270 hp_bills
rename dsbill270 ds_bills
rename iadlhp270 iadl_dep
rename iadlds270 iadl_dis
rename hp_mob270 hp_mobil
rename ds_mob270 ds_mobil
rename bloc_c270 bloc_cat
rename blocks270 blocksbl
rename adl24_270 adl24_bl
rename badl14270 badl14bl
rename iadl10270 iadl10bl
rename mobdis270 mobdisbl
rename mpase9bw mpase9cw
rename mpase270 mpasebl
rename smoker_270 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 16 to each observation
gen interval = 16
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 270-month follow-up dataset with a new name
save other_vrb16.dta
clear

* Import 288-month follow-up data
import sas using "P:\projects\PEP\Master\fu288face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase288 age_288 female white edu_cont agecat288 BMI_288 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_288 mi_288 chf_288 strok_288 cancr_288 diab_288 hipfx_288 lungd_288 arth_288 ccsum288a ccsum288b ccsum288c d_4adl288 d_7adl288 d_3adl288 hp3adl288 walkd_288 hpwalk288 dswalk288 hpstir288 dsstir288 hpcary288 dscary288 hpshop288 dsshop288 hpclen288 dsclen288 hpmeal288 dsmeal288 hpmeds288 dsmeds288 hpbill288 dsbill288 iadlhp288 iadlds288 hp_mob288 ds_mob288 bloc_c288 blocks288 adl24_288 adl12ms badl14288 iadl10288 mobdis288 intdate288 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase288 smoker_288
* Rename variables to ensure consistency across intervals
rename fc5_pase288 fc5_pasebl
rename BMI_288 BMI_bl
rename agecat288 age5cat
rename age_288 age_b
rename ccsum288a ccsumbl1
rename ccsum288c ccsumbl2
rename Cancer cancer
rename d_4adl288 diff4adl 
rename d_7adl288 diff7adl
rename d_3adl288 diff3adl 
rename hp3adl288 dep3adl 
rename walkd_288 walk_dev
rename hpwalk288 hp_walk
rename dswalk288 ds_walk
rename hpstir288 hp_stair
rename dsstir288 ds_stair
rename hpcary288 hp_carry
rename dscary288 ds_carry
rename hpshop288 hp_shop
rename dsshop288 ds_shop 
rename hpclen288 hp_clean
rename dsclen288 ds_clean
rename hpmeal288 hp_meal
rename dsmeal288 ds_meal
rename hpmeds288 hp_meds
rename dsmeds288 ds_meds
rename hpbill288 hp_bills
rename dsbill288 ds_bills
rename iadlhp288 iadl_dep
rename iadlds288 iadl_dis
rename hp_mob288 hp_mobil
rename ds_mob288 ds_mobil
rename bloc_c288 bloc_cat
rename blocks288 blocksbl
rename adl24_288 adl24_bl
rename badl14288 badl14bl
rename iadl10288 iadl10bl
rename mobdis288 mobdisbl
rename mpase9bw mpase9cw
rename mpase288 mpasebl
rename smoker_288 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 17 to each observation
gen interval = 17
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 288-month follow-up dataset with a new name
save other_vrb17.dta
clear

* Import 306-month follow-up data
import sas using "P:\projects\PEP\Master\fu306face.sas7bdat"
* Keep relevant variables
keep studyID fc5_pase306 age_306 female white edu_cont agecat306 BMI_306 highbp mi chf stroke Cancer diabetes hipfx arthrit lung_d hbp_306 mi_306 chf_306 strok_306 cancr_306 diab_306 hipfx_306 lungd_306 arth_306 ccsum306a ccsum306b ccsum306c d_4adl306 d_7adl306 d_3adl306 hp3adl306 walkd_306 hpwalk306 dswalk306 hpstir306 dsstir306 hpcary306 dscary306 hpshop306 dsshop306 hpclen306 dsclen306 hpmeal306 dsmeal306 hpmeds306 dsmeds306 hpbill306 dsbill306 iadlhp306 iadlds306 hp_mob306 ds_mob306 bloc_c306 blocks306 adl24_306 adl12ms badl14306 iadl10306 mobdis306 intdate306 mpase1w mpase2w mpase3w mpase4w mpase5w mpase6w mpase7w mpase8aw mpase8bw mpase8cw mpase8dw mpase9bw mpase306 smoker_306
* Rename variables to ensure consistency across intervals
rename fc5_pase306 fc5_pasebl
rename BMI_306 BMI_bl
rename agecat306 age5cat
rename age_306 age_b
rename ccsum306a ccsumbl1
rename ccsum306c ccsumbl2
rename Cancer cancer
rename d_4adl306 diff4adl 
rename d_7adl306 diff7adl
rename d_3adl306 diff3adl 
rename hp3adl306 dep3adl 
rename walkd_306 walk_dev
rename hpwalk306 hp_walk
rename dswalk306 ds_walk
rename hpstir306 hp_stair
rename dsstir306 ds_stair
rename hpcary306 hp_carry
rename dscary306 ds_carry
rename hpshop306 hp_shop
rename dsshop306 ds_shop 
rename hpclen306 hp_clean
rename dsclen306 ds_clean
rename hpmeal306 hp_meal
rename dsmeal306 ds_meal
rename hpmeds306 hp_meds
rename dsmeds306 ds_meds
rename hpbill306 hp_bills
rename dsbill306 ds_bills
rename iadlhp306 iadl_dep
rename iadlds306 iadl_dis
rename hp_mob306 hp_mobil
rename ds_mob306 ds_mobil
rename bloc_c306 bloc_cat
rename blocks306 blocksbl
rename adl24_306 adl24_bl
rename badl14306 badl14bl
rename iadl10306 iadl10bl
rename mobdis306 mobdisbl
rename mpase9bw mpase9cw
rename mpase306 mpasebl
rename smoker_306 smoker_bl
rename * raw_*
* Generate a new variable called interval and assign the number 18 to each observation
gen interval = 18
* Rename raw_studyID variable to ensure consistency with master dataset
rename raw_studyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save 306-month follow-up dataset with a new name
save other_vrb18.dta
clear

* Append follow-up comprehensive assessment datasets to baseline dataset
use other_vrb1.dta
append using other_vrb2.dta
append using other_vrb3.dta
append using other_vrb4.dta
append using other_vrb5.dta
append using other_vrb6.dta
append using other_vrb7.dta
append using other_vrb9.dta
append using other_vrb10.dta
append using other_vrb11.dta
append using other_vrb12.dta
append using other_vrb13.dta
append using other_vrb14.dta
append using other_vrb15.dta
append using other_vrb16.dta
append using other_vrb17.dta
append using other_vrb18.dta
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Save dataset with a new name
save raw_other.dta
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5525 observations
clear 

* Use master dataset
use master.dta
* Rename StudyID variable to ensure consistency with combined comprehensive assessment dataset
rename StudyID STUDYID
* Overwrite dataset, by replacing the previously saved file
save master.dta, replace
* Merge master dataset with combined comprehensive assessment dataset
merge 1:1 STUDYID interval using raw_other.dta, generate(merge_rawother)
* Keep comprehensive assessments that were not refused
keep if inlist(merge_rawother,1,3)
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Save updated master dataset with a new name
save f2f.dta
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
clear

* Import raw baseline data
import sas using "P:\projects\PEP\Master\pepbase.sas7bdat"
* Keep relevant variables
keep STUDYID GDI1 GDI2 GDI3 GDI8 HT1 HT2 WT2A ALC1 ALC2 ALC3 ALC4 ALC5 SMO1 MPASE1 MPASE1A MPASE2 MPASE2A MPASE3 MPASE3A MPASE4 MPASE4A MPASE5 MPASE5A MPASE6 MPASE7 MPASE8A MPASE8B MPASE8C MPASE8D MPASE9A MPASE9B MPASE9C INC GDI9 PF1 PF2 PF3 PF4 PF5A PF5B PF5C PF5D PF6A PF6B PF7A PF7B PF8A PF8B PF9A PF9B PF10A PF10B PF11A PF11B PF12A PF12B PF13A PF13B PF14A PF14B PF15A PF15B PF16A PF16B PF17 CC1A CC1B CC2 CC3 CC4A CC4B1 CC4B2 CC4B3 CC4B4 CC5 CC6A CC6B CC6C CC7 CC8A CC8B1 CC8B2 CC8B3 CC8B4 CC9A CC9B1 CC9B2 CC9B3 CC9B4 CC9B5 CC10 CC11A CC11B CC11C CC12 CC13A CC13B CC14
* Rename variables to ensure consistency across intervals
rename GDI1 gender_p
rename GDI2 race_p
rename GDI3 age_p
rename GDI8 education_p
rename WT2A wt1a 
rename ALC1 alc1 
rename ALC2 alc2
rename ALC3 alc3 
rename ALC4 alc4
rename ALC5 alc5
rename SMO1 smo1
rename MPASE1 mpase1
rename MPASE1A mpase1a
rename MPASE2 mpase2
rename MPASE2A mpase2a 
rename MPASE3 mpase3
rename MPASE3A mpase3a
rename MPASE4 mpase4
rename MPASE4A mpase4a
rename MPASE5 mpase5
rename MPASE5A mpase5a 
rename MPASE6 mpase6
rename MPASE7 mpase7
rename MPASE8A mpase8a
rename MPASE8B mpase8b
rename MPASE8C mpase8c
rename MPASE8D mpase8d
rename MPASE9A mpase9a
rename MPASE9B mpase9b
rename MPASE9C mpase9c
rename GDI9 pf18
rename PF1 pf1b
rename PF2 pf2b
rename PF3 pf3b
rename PF4 pf4b
rename PF5A pf5a
rename PF5B pf5b
rename PF5C pf5c 
rename PF5D pf5d 
rename PF6A pf6a
rename PF6B pf6b
rename PF7A pf7a
rename PF7B pf7b
rename PF8A pf8a 
rename PF8B pf8b
rename PF9A pf9a 
rename PF9B pf9b 
rename PF10A pf10a
rename PF10B pf10b 
rename PF11A pf11a 
rename PF11B pf11b 
rename PF12A pf12a 
rename PF12B pf12b 
rename PF13A pf13a 
rename PF13B pf13b 
rename PF14A pf14a 
rename PF14B pf14b 
rename PF15A pf15a 
rename PF15B pf15b 
rename PF16A pf16a 
rename PF16B pf16b 
rename PF17 pf17
rename CC1A cc1a 
rename CC1B cc1b 
rename CC2 cc2
rename CC3 cc3 
rename CC4A cc4a 
rename CC4B1 cc4b1 
rename CC4B2 cc4b2
rename CC4B3 cc4b3
rename CC4B4 cc4b4
rename CC5 cc5
rename CC6A cc6a
rename CC6B cc6b
rename CC6C cc6c
rename CC7 cc7
rename CC9A cc8a 
rename CC9B1 cc8b1 
rename CC9B2 cc8b2 
rename CC9B3 cc8b3
rename CC9B4 cc8b4 
rename CC9B5 cc8b5 
rename CC13A cc9a
rename CC13B cc9b 
rename * mfu_*
* Generate a new variable called interval and assign the number 1 to each observation
gen interval = 1
* Rename mfu_STUDYID variable to ensure consistency with updated master dataset
rename mfu_STUDYID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw baseline dataset with a new name
save other_mfu1.dta
clear

* Import raw 18-month follow-up data
import sas using "P:\projects\PEP\sasdata\face18m.sas7bdat"
* Keep relevant variables
keep StudyID wt1a alc1 alc2 alc3 alc4 alc5 smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d pf1a pf1b pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b pf17 pf18 cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b cc10a cc10b cc11
* Rename variables to ensure consistency across intervals
rename * mfu_*
* Generate a new variable called interval and assign the number 2 to each observation
gen interval = 2
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 18-month follow-up dataset with a new name
save other_mfu2.dta
clear

* Import raw 36-month follow-up data
import sas using "P:\projects\PEP\sasdata\face36mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt1a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1 bath2a bath3 pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b pf17 cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b cc10a cc10b cc11
* Rename variables to ensure consistency across intervals
rename bath3 bath3g 
rename bath2a bath3 
rename bath1 bath2a 
rename * mfu_*
* Generate a new variable called interval and assign the number 3 to each observation
gen interval = 3
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 36-month follow-up dataset with a new name
save other_mfu3.dta
clear

* Import raw 54-month follow-up data
import sas using "P:\projects\PEP\sasdata\face54mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf2e pf3a pf3b pf3e pf4a pf4b pf4e pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf12e pf13a pf13b pf13e pf14a pf14b pf14e pf15a pf15b pf15e pf16a pf16b pf16c pf16d pf16e cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename pf2b pf2help3m
rename pf3b pf3help3m
rename pf4b pf4help3m
rename pf2e pf2e4
rename pf3e pf3e4 
rename pf4e pf4e4
rename pf12e pf12e4
rename pf13e pf13e4
rename pf14e pf14e4
rename pf15e pf15e4
rename pf16e pf16e4
rename * mfu_*
* Generate a new variable called interval and assign the number 4 to each observation
gen interval = 4
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 54-month follow-up dataset with a new name
save other_mfu4.dta
clear

* Import raw 72-month follow-up data
import sas using "P:\projects\PEP\sasdata\face72mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3g pf2a pf2b pf2f pf3a pf3b pf3f pf4a pf4b pf4f pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename pf2b pf2help1m
rename pf3b pf3help1m
rename pf4b pf4help1m
rename * mfu_*
* Generate a new variable called interval and assign the number 5 to each observation
gen interval = 5
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 72-month follow-up dataset with a new name
save other_mfu5.dta
clear

* Import raw 90-month follow-up data
import sas using "P:\projects\PEP\sasdata\face90mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3g pf2a pf2b pf2f pf3a pf3b pf3f pf4a pf4b pf4f pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename pf2b pf2help12m
rename pf3b pf3help12m
rename pf4b pf4help12m
rename * mfu_*
* Generate a new variable called interval and assign the number 6 to each observation
gen interval = 6
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 90-month follow-up dataset with a new name
save other_mfu6.dta
clear

* Import raw 108-month follow-up data
import sas using "P:\projects\PEP\sasdata\face108mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 7 to each observation
gen interval = 7
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 108-month follow-up dataset with a new name
save other_mfu7.dta
clear

* Import raw 144-month follow-up data
import sas using "P:\projects\PEP\sasdata\face144mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 9 to each observation
gen interval = 9
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 144-month follow-up dataset with a new name
save other_mfu9.dta
clear

* Import raw 162-month follow-up data
import sas using "P:\projects\PEP\sasdata\face162mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 10 to each observation
gen interval = 10
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 162-month follow-up dataset with a new name
save other_mfu10.dta
clear

* Import raw 180-month follow-up data
import sas using "P:\projects\PEP\sasdata\face180mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 11 to each observation
gen interval = 11
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 180-month follow-up dataset with a new name
save other_mfu11.dta
clear

* Import raw 198-month follow-up data
import sas using "P:\projects\PEP\sasdata\face198mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 12 to each observation
gen interval = 12
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 198-month follow-up dataset with a new name
save other_mfu12.dta
clear

* Import raw 216-month follow-up data
import sas using "P:\projects\PEP\sasdata\face216mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 13 to each observation
gen interval = 13
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 216-month follow-up dataset with a new name
save other_mfu13.dta
clear

* Import raw 234-month follow-up data
import sas using "P:\projects\PEP\sasdata\face234mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 14 to each observation
gen interval = 14
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 234-month follow-up dataset with a new name
save other_mfu14.dta
clear

* Import raw 252-month follow-up data
import sas using "P:\projects\PEP\sasdata\face252mfu.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 15 to each observation
gen interval = 15
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 252-month follow-up dataset with a new name
save other_mfu15.dta
clear

* Import raw 270-month follow-up data
import sas using "P:\projects\PEP\sasdata\face270mfu_amend_wrc.sas7bdat"
* Keep relevant variables
keep StudyID wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 16 to each observation
gen interval = 16
* Rename mfu_StudyID variable to ensure consistency with updated master dataset
rename mfu_StudyID STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 270-month follow-up dataset with a new name
save other_mfu16.dta
clear

* Import raw 288-month follow-up data
import sas using "P:\projects\PEP\sasdata\face288mfu.sas7bdat"
* Keep relevant variables
keep studyid wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 17 to each observation
gen interval = 17
* Rename mfu_studyid variable to ensure consistency with updated master dataset
rename mfu_studyid STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 288-month follow-up dataset with a new name
save other_mfu17.dta
clear

* Import raw 306-month follow-up data
import sas using "P:\projects\PEP\sasdata\face306mfu.sas7bdat"
* Keep relevant variables
keep studyid wt2a smo1 mpase1 mpase1a mpase2 mpase2a mpase3 mpase3a mpase4 mpase4a mpase5 mpase5a mpase6 mpase7 mpase8a mpase8b mpase8c mpase8d mpase9a mpase9b mpase9c mpase9d bath1a bath2a bath3c pf2a pf2b pf3a pf3b pf4a pf4b pf5a pf5b pf5c pf5d pf6a pf6b pf7a pf7b pf8a pf8b pf9a pf9b pf10a pf10b pf11a pf11b pf12a pf12b pf13a pf13b pf14a pf14b pf15a pf15b pf16a pf16b cc1a cc1b cc2 cc3 cc4a cc4b1 cc4b2 cc4b3 cc4b4 cc5 cc6a cc6b cc6c cc7 cc8a cc8b1 cc8b2 cc8b3 cc8b4 cc8b5 cc9a cc9b
* Rename variables to ensure consistency across intervals
rename wt2a wt1a
rename bath2a bath3
rename bath1a bath2a
rename bath3c bath3g
rename * mfu_*
* Generate a new variable called interval and assign the number 18 to each observation
gen interval = 18
* Rename mfu_studyid variable to ensure consistency with updated master dataset
rename mfu_studyid STUDYID
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw 306-month follow-up dataset with a new name
save other_mfu18.dta
clear

* Append raw follow-up comprehensive assessment datasets to raw baseline dataset
use other_mfu1.dta
append using other_mfu2.dta
append using other_mfu3.dta
append using other_mfu4.dta
append using other_mfu5.dta
append using other_mfu6.dta
append using other_mfu7.dta
append using other_mfu9.dta
append using other_mfu10.dta
append using other_mfu11.dta
append using other_mfu12.dta
append using other_mfu13.dta
append using other_mfu14.dta
append using other_mfu15.dta
append using other_mfu16.dta
append using other_mfu17.dta
append using other_mfu18.dta
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Save dataset with a new name
save mfu_other.dta
* Count total number of participants and observations
unique STUDYID
* 848 individuals, 5201 observations
clear 

* Use updated master dataset
use f2f.dta
* Merge updated master dataset with combined raw comprehensive assessment dataset
merge 1:1 STUDYID interval using mfu_other.dta, generate(merge_mfuother)
* Keep comprehensive assessments that were not refused
keep if inlist(merge_mfuother,1,3)
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Overwrite dataset, by replacing the previously saved file
save f2f.dta, replace
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
clear

* Import raw baseline data
import sas using "P:\projects\PEP\Master\pepbase.sas7bdat"
* Keep relevant variables
keep STUDYID GDI4MO GDI4DY GDI4YR
* Generate a new variable called interval and assign the number 1 to each observation
gen interval = 1
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save raw baseline dataset with a new name
save birthmfu.dta
clear

* Use updated master dataset
use f2f.dta
* Merge updated master dataset with raw baseline dataset
merge 1:1 STUDYID interval using birthmfu.dta, generate(merge_mfubdate)
* Keep comprehensive assessments that were not refused
keep if inlist(merge_mfubdate,1,3)
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Overwrite dataset, by replacing the previously saved file
save f2f.dta, replace
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
clear

* Import corrected date of birth data
import sas using "P:\projects\PEP\sasdata\subjects_080521_dobfix.sas7bdat"
* Keep relevant variables
keep StudyID BDate DDate bdate_ss 
* Rename variables
rename StudyID STUDYID
rename BDate BDates
rename DDate DDates
rename bdate_ss bdates_ss
* Count total number of participants
unique STUDYID 
* 754 individuals
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save corrected date of birth dataset with a new name
save dobfix.dta
clear

* Use updated master dataset
use f2f.dta
* Merge updated master dataset with corrected date of birth dataset
merge m:1 STUDYID using dobfix.dta, generate(merge_dobfix)
* Keep if matched
keep if merge_dobfix==3
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Save dataset with a new name
save comprehensive.dta
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
clear 

* Import baseline Area Deprivation Index (ADI) data
import sas using "P:\projects\PEP\ADI_Life_expectancy\New_ADI_update\pep_adi_atbaseline.sas7bdat"
* Keep relevant variables
keep studyID interval StateDecile ADId910
* Rename variables
rename studyID STUDYID
rename StateDecile StateDecileb
rename ADId910 ADId910b
* Count total number of participants
unique STUDYID 
* 754 individuals
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save ADI dataset with a new name
save ADI_baseline.dta
clear 

* Use updated master dataset
use comprehensive.dta 
* Merge updated master dataset with ADI dataset
merge 1:1 STUDYID interval using ADI_baseline.dta, generate(merge_ADIb)
* Keep comprehensive assessments that were not refused
keep if inlist(merge_ADIb,1,3)
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Overwrite dataset, by replacing the previously saved file
save comprehensive.dta, replace
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
clear 

* Import imputed income data
import sas using "P:\projects\PEP\ADI_Life_expectancy\New_ADI_update\incblmiforeg.sas7bdat"
* Keep relevant variables
keep StudyID INC_MImdn
* Rename StudyID variable to ensure consistency with updated master dataset
rename StudyID STUDYID
* Count total number of participants
unique STUDYID 
* 754 individuals
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save imputed income dataset with a new name
save inc_MI.dta
clear 

* Use updated master dataset
use comprehensive.dta 
* Merge updated master dataset with imputed income dataset
merge m:1 STUDYID using inc_MI.dta, generate(merge_inc)
* Keep if matched
keep if merge_inc==3
* Sort by participant ID and interval (lowest to highest)
sort STUDYID interval
* Overwrite dataset, by replacing the previously saved file
save comprehensive.dta, replace
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations 

* Individual- and area-level indicators of socio-economic status (SES)
** Years of education (time-constant)
* Generate a new variable duplicating the education variable at baseline
gen edu_cons = mfu_education_p if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward edu_cons, replace
* Code "lower education (less than 12 years)" as 0
gen edu_cons_bi = 0 if edu_cons<12
* Code "higher education (12+ years)" as 1
replace edu_cons_bi = 1 if edu_cons>=12

** Income (time-constant)
* Generate a new version of the imputed income variable ranging from 0 to 12 (instead of 1 to 13)
gen INC_MImdn_new = INC_MImdn-1
* Generate a new variable duplicating the imputed income variable at baseline
gen inc_consmi = INC_MImdn_new if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward inc_consmi, replace
* Code "lower income (< $15000)" as 0
gen inc_bimi = 0 if inlist(inc_consmi,0,1,2,3,4)
* Code "higher income (≥ $15000)" as 1
replace inc_bimi = 1 if inlist(inc_consmi,5,6,7,8,9,10,11,12)

** Neighbourhood disadvantage (time-constant)
* Generate a new variable duplicating the ADI variable at baseline
gen adi_cons = ADId910b if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward adi_cons, replace
* Reverse the variable such that disadvantaged neighborhoods (81 to 100 percentile) are coded as 0 and nondisadvantaged neighborhoods (1 to 80 percentile) are coded as 1
replace adi_cons = 2 if adi_cons==0
replace adi_cons = 0 if adi_cons==1
replace adi_cons = 1 if adi_cons==2

* Descriptive variables
** Age (years)
gen age_fix = floor((intdateF2F-BDates) / 365.25)
gen age_fix_dec = ((intdateF2F-BDates) / 365.25)

** Biological sex (time-constant)
* Generate a new variable duplicating the biological sex variable at baseline
gen sex_cons = mfu_gender_p if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward sex_cons, replace
* Code "male" as 0
replace sex_cons = 0 if sex_cons==1
* Code "female" as 1
replace sex_cons = 1 if sex_cons==2

* Covariates
** Race or ethnicity (time-constant)
* Generate a new variable duplicating the race or ethnicity variable at baseline
gen eth_cons = mfu_race_p if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward eth_cons, replace
* Code "White" as 0
gen eth_bi = 0 if eth_cons==1
* Code "non-White" as 1
replace eth_bi = 1 if inlist(eth_cons,2,3,5) 

** Number of chronic conditions
*** Hypertension
* Code as 1 if the participant has been told by a doctor that they have high blood pressure or hypertension and the participant is currently taking any medicine for high blood pressure
gen highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1
* Code as 0 otherwise
replace highbl = 0 if highbl!=1
* Code as 0 if the participant responds "Don't know" to the question about having high blood pressure or the question about taking medicine for high blood pressure
replace highbl = 0 if mfu_cc1a==8 | mfu_cc1b==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having high blood pressure or the question about taking medicine for high blood pressure
replace highbl = . if inlist(mfu_cc1a,.,7) | mfu_cc1b==7
* Code as missing if the comprehensive assessment is not at baseline or 18-month follow-up (i.e., intervals 1-2)
replace highbl = . if ! inlist(interval,1,2)

* Carryforward observations (high blood pressure and on medication at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen hbp18_cons = raw_hbp_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward hbp18_cons, replace
gen hbp36_cons = raw_hbp_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward hbp36_cons, replace
gen hbp54_cons = raw_hbp_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward hbp54_cons, replace
gen hbp72_cons = raw_hbp_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward hbp72_cons, replace
gen hbp90_cons = raw_hbp_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward hbp90_cons, replace
gen hbp108_cons = raw_hbp_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward hbp108_cons, replace
gen hbp144_cons = raw_hbp_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward hbp144_cons, replace
gen hbp162_cons = raw_hbp_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward hbp162_cons, replace
gen hbp180_cons = raw_hbp_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward hbp180_cons, replace
gen hbp198_cons = raw_hbp_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward hbp198_cons, replace
gen hbp216_cons = raw_hbp_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward hbp216_cons, replace
gen hbp234_cons = raw_hbp_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward hbp234_cons, replace
gen hbp252_cons = raw_hbp_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward hbp252_cons, replace
gen hbp270_cons = raw_hbp_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward hbp270_cons, replace
gen hbp288_cons = raw_hbp_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward hbp288_cons, replace

* For intervals 3-18, code as 1 if the participant has been told by a doctor that they have high blood pressure or hypertension and the participant is currently taking any medicine for high blood pressure, and the participant was coded as NOT having hypertension at all prior comprehensive assessments (i.e., new condition)
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp18_cons==0 & interval==3
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp36_cons==0 & interval==4
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp54_cons==0 & interval==5
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp72_cons==0 & interval==6
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp90_cons==0 & interval==7
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp108_cons==0 & interval==9
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp144_cons==0 & interval==10
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp162_cons==0 & interval==11
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp180_cons==0 & interval==12
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp198_cons==0 & interval==13
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp216_cons==0 & interval==14
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp234_cons==0 & interval==15
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp252_cons==0 & interval==16
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp270_cons==0 & interval==17
replace highbl = 1 if mfu_cc1a==1 & mfu_cc1b==1 & hbp288_cons==0 & interval==18

* Code as 0 otherwise
replace highbl = 0 if highbl!=1
* Code as 0 if the participant responds "Don't know" to the question about having high blood pressure or the question about taking medicine for high blood pressure
replace highbl = 0 if mfu_cc1a==8 | mfu_cc1b==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having high blood pressure or the question about taking medicine for high blood pressure
replace highbl = . if inlist(mfu_cc1a,.,7) | mfu_cc1b==7
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace highbl = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen bpminus = highbl - raw_highbp

* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
gen hbp_cons = raw_highbp if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward hbp_cons, replace
* For each comprehensive assessment, code as 1 if the participant was newly coded as having hypertension at the corresponding comprehensive assessment or the participant was coded as having hypertension at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen hbp18 = 1 if (highbl==1 | hbp_cons==1) & interval==2
replace hbp18 = 0 if hbp18!=1 & interval==2
gen hbp36 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1) & interval==3
replace hbp36 = 0 if hbp36!=1 & interval==3
gen hbp54 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1) & interval==4
replace hbp54 = 0 if hbp54!=1 & interval==4
gen hbp72 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1) & interval==5
replace hbp72 = 0 if hbp72!=1 & interval==5
gen hbp90 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1) & interval==6
replace hbp90 = 0 if hbp90!=1 & interval==6
gen hbp108 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1) & interval==7
replace hbp108 = 0 if hbp108!=1 & interval==7
gen hbp144 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1) & interval==9
replace hbp144 = 0 if hbp144!=1 & interval==9
gen hbp162 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1) & interval==10
replace hbp162 = 0 if hbp162!=1 & interval==10
gen hbp180 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1) & interval==11
replace hbp180 = 0 if hbp180!=1 & interval==11
gen hbp198 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1) & interval==12
replace hbp198 = 0 if hbp198!=1 & interval==12
gen hbp216 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1) & interval==13
replace hbp216 = 0 if hbp216!=1 & interval==13
gen hbp234 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1 | hbp216_cons==1) & interval==14
replace hbp234 = 0 if hbp234!=1 & interval==14
gen hbp252 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1 | hbp216_cons==1 | hbp234_cons==1) & interval==15
replace hbp252 = 0 if hbp252!=1 & interval==15
gen hbp270 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1 | hbp216_cons==1 | hbp234_cons==1 | hbp252_cons==1) & interval==16
replace hbp270 = 0 if hbp270!=1 & interval==16
gen hbp288 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1 | hbp216_cons==1 | hbp234_cons==1 | hbp252_cons==1 | hbp270_cons==1) & interval==17
replace hbp288 = 0 if hbp288!=1 & interval==17
gen hbp306 = 1 if (highbl==1 | hbp_cons==1 | hbp18_cons==1 | hbp36_cons==1 | hbp54_cons==1 | hbp72_cons==1 | hbp90_cons==1 | hbp108_cons==1 | hbp144_cons==1 | hbp162_cons==1 | hbp180_cons==1 | hbp198_cons==1 | hbp216_cons==1 | hbp234_cons==1 | hbp252_cons==1 | hbp270_cons==1 | hbp288_cons==1) & interval==18
replace hbp306 = 0 if hbp306!=1 & interval==18

*** Myocardial infarction
* Code as 1 if the participant has been told by a doctor that they had a heart attack, or coronary, or myocardial infarction, and had to be hospitalized
gen heart = 1 if mfu_cc2==1
* Code as 0 if the participant responds "Suspect or possible" or "No"
replace heart = 0 if inlist(mfu_cc2,2,3)
* Code as 0 if the participant responds "Don't know"
replace heart = 0 if mfu_cc2==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having had a myocardial infarction
replace heart = . if inlist(mfu_cc2,.,7)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace heart = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen miminus = heart - raw_mi

* Carryforward observations (myocardial infarction and hospitalization at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen mi_cons = raw_mi if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward mi_cons, replace
gen mi18_cons = raw_mi_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward mi18_cons, replace
gen mi36_cons = raw_mi_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward mi36_cons, replace
gen mi54_cons = raw_mi_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward mi54_cons, replace
gen mi72_cons = raw_mi_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward mi72_cons, replace
gen mi90_cons = raw_mi_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward mi90_cons, replace
gen mi108_cons = raw_mi_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward mi108_cons, replace
gen mi144_cons = raw_mi_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward mi144_cons, replace
gen mi162_cons = raw_mi_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward mi162_cons, replace
gen mi180_cons = raw_mi_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward mi180_cons, replace
gen mi198_cons = raw_mi_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward mi198_cons, replace
gen mi216_cons = raw_mi_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward mi216_cons, replace
gen mi234_cons = raw_mi_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward mi234_cons, replace
gen mi252_cons = raw_mi_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward mi252_cons, replace
gen mi270_cons = raw_mi_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward mi270_cons, replace
gen mi288_cons = raw_mi_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward mi288_cons, replace

* For each comprehensive assessment, code as 1 if the participant was newly coded as having had a myocardial infarction and having been hospitalized at the corresponding comprehensive assessment or the participant was coded as having had a myocardial infarction at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen mi18 = 1 if (heart==1 | mi_cons==1) & interval==2
replace mi18 = 0 if mi18!=1 & interval==2
gen mi36 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1) & interval==3
replace mi36 = 0 if mi36!=1 & interval==3
gen mi54 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1) & interval==4
replace mi54 = 0 if mi54!=1 & interval==4
gen mi72 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1) & interval==5
replace mi72 = 0 if mi72!=1 & interval==5
gen mi90 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1) & interval==6
replace mi90 = 0 if mi90!=1 & interval==6
gen mi108 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1) & interval==7
replace mi108 = 0 if mi108!=1 & interval==7
gen mi144 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1) & interval==9
replace mi144 = 0 if mi144!=1 & interval==9
gen mi162 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1) & interval==10
replace mi162 = 0 if mi162!=1 & interval==10
gen mi180 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1) & interval==11
replace mi180 = 0 if mi180!=1 & interval==11
gen mi198 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1) & interval==12
replace mi198 = 0 if mi198!=1 & interval==12
gen mi216 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1) & interval==13
replace mi216 = 0 if mi216!=1 & interval==13
gen mi234 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1 | mi216_cons==1) & interval==14
replace mi234 = 0 if mi234!=1 & interval==14
gen mi252 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1 | mi216_cons==1 | mi234_cons==1) & interval==15
replace mi252 = 0 if mi252!=1 & interval==15
gen mi270 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1 | mi216_cons==1 | mi234_cons==1 | mi252_cons==1) & interval==16
replace mi270 = 0 if mi270!=1 & interval==16
gen mi288 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1 | mi216_cons==1 | mi234_cons==1 | mi252_cons==1 | mi270_cons==1) & interval==17
replace mi288 = 0 if mi288!=1 & interval==17
gen mi306 = 1 if (heart==1 | mi_cons==1 | mi18_cons==1 | mi36_cons==1 | mi54_cons==1 | mi72_cons==1 | mi90_cons==1 | mi108_cons==1 | mi144_cons==1 | mi162_cons==1 | mi180_cons==1 | mi198_cons==1 | mi216_cons==1 | mi234_cons==1 | mi252_cons==1 | mi270_cons==1 | mi288_cons==1) & interval==18
replace mi306 = 0 if mi306!=1 & interval==18

*** Congestive heart failure
* Code as 1 if the participant has been told by a doctor that they had heart failure or congestive heart failure
gen chf = 1 if mfu_cc3==1
* Code as 0 otherwise
replace chf = 0 if chf!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having had congestive heart failure
replace chf = . if inlist(mfu_cc3,7,.)
* Code as missing if the comprehensive assessment is not at baseline or 18-month follow-up (i.e., intervals 1-2)
replace chf = . if ! inlist(interval,1,2)

* Carryforward observations (congestive heart failure at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen chf18_cons = raw_chf_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward chf18_cons, replace
gen chf36_cons = raw_chf_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward chf36_cons, replace
gen chf54_cons = raw_chf_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward chf54_cons, replace
gen chf72_cons = raw_chf_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward chf72_cons, replace
gen chf90_cons = raw_chf_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward chf90_cons, replace
gen chf108_cons = raw_chf_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward chf108_cons, replace
gen chf144_cons = raw_chf_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward chf144_cons, replace
gen chf162_cons = raw_chf_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward chf162_cons, replace
gen chf180_cons = raw_chf_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward chf180_cons, replace
gen chf198_cons = raw_chf_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward chf198_cons, replace
gen chf216_cons = raw_chf_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward chf216_cons, replace
gen chf234_cons = raw_chf_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward chf234_cons, replace
gen chf252_cons = raw_chf_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward chf252_cons, replace
gen chf270_cons = raw_chf_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward chf270_cons, replace
gen chf288_cons = raw_chf_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward chf288_cons, replace

* For intervals 3-18, code as 1 if the participant has been told by a doctor that they had heart failure or congestive heart failure, and the participant was coded as NOT having had congestive heart failure at all prior comprehensive assessments (i.e., new condition)
replace chf = 1 if mfu_cc3==1 & chf18_cons==0 & interval==3
replace chf = 1 if mfu_cc3==1 & chf36_cons==0 & interval==4
replace chf = 1 if mfu_cc3==1 & chf54_cons==0 & interval==5
replace chf = 1 if mfu_cc3==1 & chf72_cons==0 & interval==6
replace chf = 1 if mfu_cc3==1 & chf90_cons==0 & interval==7
replace chf = 1 if mfu_cc3==1 & chf108_cons==0 & interval==9
replace chf = 1 if mfu_cc3==1 & chf144_cons==0 & interval==10
replace chf = 1 if mfu_cc3==1 & chf162_cons==0 & interval==11
replace chf = 1 if mfu_cc3==1 & chf180_cons==0 & interval==12
replace chf = 1 if mfu_cc3==1 & chf198_cons==0 & interval==13
replace chf = 1 if mfu_cc3==1 & chf216_cons==0 & interval==14
replace chf = 1 if mfu_cc3==1 & chf234_cons==0 & interval==15
replace chf = 1 if mfu_cc3==1 & chf252_cons==0 & interval==16
replace chf = 1 if mfu_cc3==1 & chf270_cons==0 & interval==17
replace chf = 1 if mfu_cc3==1 & chf288_cons==0 & interval==18

* Code as 0 otherwise
replace chf = 0 if chf!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having had congestive heart failure
replace chf = . if inlist(mfu_cc3,7,.)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace chf = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen chfminus = chf - raw_chf

* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
gen chf_cons = raw_chf if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward chf_cons, replace
* For each comprehensive assessment, code as 1 if the participant was newly coded as having had congestive heart failure at the corresponding comprehensive assessment or the participant was coded as having had congestive heart failure at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen chf18 = 1 if (chf==1 | chf_cons==1) & interval==2
replace chf18 = 0 if chf18!=1 & interval==2
gen chf36 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1) & interval==3
replace chf36 = 0 if chf36!=1 & interval==3
gen chf54 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1) & interval==4
replace chf54 = 0 if chf54!=1 & interval==4
gen chf72 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1) & interval==5
replace chf72 = 0 if chf72!=1 & interval==5
gen chf90 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1) & interval==6
replace chf90 = 0 if chf90!=1 & interval==6
gen chf108 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1) & interval==7
replace chf108 = 0 if chf108!=1 & interval==7
gen chf144 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1) & interval==9
replace chf144 = 0 if chf144!=1 & interval==9
gen chf162 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1) & interval==10
replace chf162 = 0 if chf162!=1 & interval==10
gen chf180 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1) & interval==11
replace chf180 = 0 if chf180!=1 & interval==11
gen chf198 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1) & interval==12
replace chf198 = 0 if chf198!=1 & interval==12
gen chf216 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1) & interval==13
replace chf216 = 0 if chf216!=1 & interval==13
gen chf234 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1 | chf216_cons==1) & interval==14
replace chf234 = 0 if chf234!=1 & interval==14
gen chf252 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1 | chf216_cons==1 | chf234_cons==1) & interval==15
replace chf252 = 0 if chf252!=1 & interval==15
gen chf270 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1 | chf216_cons==1 | chf234_cons==1 | chf252_cons==1) & interval==16
replace chf270 = 0 if chf270!=1 & interval==16
gen chf288 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1 | chf216_cons==1 | chf234_cons==1 | chf252_cons==1 | chf270_cons==1) & interval==17
replace chf288 = 0 if chf288!=1 & interval==17
gen chf306 = 1 if (chf==1 | chf_cons==1 | chf18_cons==1 | chf36_cons==1 | chf54_cons==1 | chf72_cons==1 | chf90_cons==1 | chf108_cons==1 | chf144_cons==1 | chf162_cons==1 | chf180_cons==1 | chf198_cons==1 | chf216_cons==1 | chf234_cons==1 | chf252_cons==1 | chf270_cons==1 | chf288_cons==1) & interval==18
replace chf306 = 0 if chf306!=1 & interval==18

*** Stroke
* Code as 1 if the participant has been told by a doctor that they had a stroke or brain hemorrhage and had to be hospitalized
gen stroke = 1 if mfu_cc4a==1
* Code as 0 if the participant responds "Suspect or possible" or "No"
replace stroke = 0 if inlist(mfu_cc4a,2,3)
* Code as 0 if the participant responds "Don't know"
replace stroke = 0 if mfu_cc4a==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having had a stroke
replace stroke = . if inlist(mfu_cc4a,.,7)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace stroke = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen stminus = stroke - raw_stroke

* Carryforward observations (stroke and hospitalization at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen stroke_cons = raw_stroke if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward stroke_cons, replace
gen stroke18_cons = raw_strok_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward stroke18_cons, replace
gen stroke36_cons = raw_strok_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward stroke36_cons, replace
gen stroke54_cons = raw_strok_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward stroke54_cons, replace
gen stroke72_cons = raw_strok_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward stroke72_cons, replace
gen stroke90_cons = raw_strok_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward stroke90_cons, replace
gen stroke108_cons = raw_strok_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward stroke108_cons, replace
gen stroke144_cons = raw_strok_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward stroke144_cons, replace
gen stroke162_cons = raw_strok_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward stroke162_cons, replace
gen stroke180_cons = raw_strok_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward stroke180_cons, replace
gen stroke198_cons = raw_strok_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward stroke198_cons, replace
gen stroke216_cons = raw_strok_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward stroke216_cons, replace
gen stroke234_cons = raw_strok_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward stroke234_cons, replace
gen stroke252_cons = raw_strok_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward stroke252_cons, replace
gen stroke270_cons = raw_strok_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward stroke270_cons, replace
gen stroke288_cons = raw_strok_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward stroke288_cons, replace

* For each comprehensive assessment, code as 1 if the participant was newly coded as having had a stroke and having been hospitalized at the corresponding comprehensive assessment or the participant was coded as having had a stroke at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen stroke18 = 1 if (stroke==1 | stroke_cons==1) & interval==2
replace stroke18 = 0 if stroke18!=1 & interval==2
gen stroke36 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1) & interval==3
replace stroke36 = 0 if stroke36!=1 & interval==3
gen stroke54 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1) & interval==4
replace stroke54 = 0 if stroke54!=1 & interval==4
gen stroke72 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1) & interval==5
replace stroke72 = 0 if stroke72!=1 & interval==5
gen stroke90 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1) & interval==6
replace stroke90 = 0 if stroke90!=1 & interval==6
gen stroke108 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1) & interval==7
replace stroke108 = 0 if stroke108!=1 & interval==7
gen stroke144 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1) & interval==9
replace stroke144 = 0 if stroke144!=1 & interval==9
gen stroke162 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1) & interval==10
replace stroke162 = 0 if stroke162!=1 & interval==10
gen stroke180 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1) & interval==11
replace stroke180 = 0 if stroke180!=1 & interval==11
gen stroke198 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1) & interval==12
replace stroke198 = 0 if stroke198!=1 & interval==12
gen stroke216 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1) & interval==13
replace stroke216 = 0 if stroke216!=1 & interval==13
gen stroke234 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1 | stroke216_cons==1) & interval==14
replace stroke234 = 0 if stroke234!=1 & interval==14
gen stroke252 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1 | stroke216_cons==1 | stroke234_cons==1) & interval==15
replace stroke252 = 0 if stroke252!=1 & interval==15
gen stroke270 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1 | stroke216_cons==1 | stroke234_cons==1 | stroke252_cons==1) & interval==16
replace stroke270 = 0 if stroke270!=1 & interval==16
gen stroke288 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1 | stroke216_cons==1 | stroke234_cons==1 | stroke252_cons==1 | stroke270_cons==1) & interval==17
replace stroke288 = 0 if stroke288!=1 & interval==17
gen stroke306 = 1 if (stroke==1 | stroke_cons==1 | stroke18_cons==1 | stroke36_cons==1 | stroke54_cons==1 | stroke72_cons==1 | stroke90_cons==1 | stroke108_cons==1 | stroke144_cons==1 | stroke162_cons==1 | stroke180_cons==1 | stroke198_cons==1 | stroke216_cons==1 | stroke234_cons==1 | stroke252_cons==1 | stroke270_cons==1 | stroke288_cons==1) & interval==18
replace stroke306 = 0 if stroke306!=1 & interval==18

*** Cancer
* Code as 1 if the participant has been told by a doctor that they had cancer or a malignant tumor, excluding minor skin cancers
gen cancer = 1 if mfu_cc5==1
* Code as 0 if the participant responds "Suspect or possible" or "No"
replace cancer = 0 if inlist(mfu_cc5,2,3)
* Code as 0 if the participant responds "Don't know"
replace cancer = 0 if mfu_cc5==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having had cancer
replace cancer = . if inlist(mfu_cc5,.,7)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace cancer = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen caminus = cancer - raw_cancer

* Carryforward observations (cancer at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen cancer_cons = raw_cancer if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward cancer_cons, replace
gen cancer18_cons = raw_cancr_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward cancer18_cons, replace
gen cancer36_cons = raw_cancr_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward cancer36_cons, replace
gen cancer54_cons = raw_cancr_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward cancer54_cons, replace
gen cancer72_cons = raw_cancr_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward cancer72_cons, replace
gen cancer90_cons = raw_cancr_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward cancer90_cons, replace
gen cancer108_cons = raw_cancr_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward cancer108_cons, replace
gen cancer144_cons = raw_cancr_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward cancer144_cons, replace
gen cancer162_cons = raw_cancr_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward cancer162_cons, replace
gen cancer180_cons = raw_cancr_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward cancer180_cons, replace
gen cancer198_cons = raw_cancr_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward cancer198_cons, replace
gen cancer216_cons = raw_cancr_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward cancer216_cons, replace
gen cancer234_cons = raw_cancr_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward cancer234_cons, replace
gen cancer252_cons = raw_cancr_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward cancer252_cons, replace
gen cancer270_cons = raw_cancr_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward cancer270_cons, replace
gen cancer288_cons = raw_cancr_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward cancer288_cons, replace

* For each comprehensive assessment, code as 1 if the participant was newly coded as having had cancer at the corresponding comprehensive assessment or the participant was coded as having had cancer at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen cancer18 = 1 if (cancer==1 | cancer_cons==1) & interval==2
replace cancer18 = 0 if cancer18!=1 & interval==2
gen cancer36 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1) & interval==3
replace cancer36 = 0 if cancer36!=1 & interval==3
gen cancer54 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1) & interval==4
replace cancer54 = 0 if cancer54!=1 & interval==4
gen cancer72 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1) & interval==5
replace cancer72 = 0 if cancer72!=1 & interval==5
gen cancer90 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1) & interval==6
replace cancer90 = 0 if cancer90!=1 & interval==6
gen cancer108 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1) & interval==7
replace cancer108 = 0 if cancer108!=1 & interval==7
gen cancer144 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1) & interval==9
replace cancer144 = 0 if cancer144!=1 & interval==9
gen cancer162 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1) & interval==10
replace cancer162 = 0 if cancer162!=1 & interval==10
gen cancer180 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1) & interval==11
replace cancer180 = 0 if cancer180!=1 & interval==11
gen cancer198 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1) & interval==12
replace cancer198 = 0 if cancer198!=1 & interval==12
gen cancer216 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1) & interval==13
replace cancer216 = 0 if cancer216!=1 & interval==13
gen cancer234 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1 | cancer216_cons==1) & interval==14
replace cancer234 = 0 if cancer234!=1 & interval==14
gen cancer252 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1 | cancer216_cons==1 | cancer234_cons==1) & interval==15
replace cancer252 = 0 if cancer252!=1 & interval==15
gen cancer270 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1 | cancer216_cons==1 | cancer234_cons==1 | cancer252_cons==1) & interval==16
replace cancer270 = 0 if cancer270!=1 & interval==16
gen cancer288 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1 | cancer216_cons==1 | cancer234_cons==1 | cancer252_cons==1 | cancer270_cons==1) & interval==17
replace cancer288 = 0 if cancer288!=1 & interval==17
gen cancer306 = 1 if (cancer==1 | cancer_cons==1 | cancer18_cons==1 | cancer36_cons==1 | cancer54_cons==1 | cancer72_cons==1 | cancer90_cons==1 | cancer108_cons==1 | cancer144_cons==1 | cancer162_cons==1 | cancer180_cons==1 | cancer198_cons==1 | cancer216_cons==1 | cancer234_cons==1 | cancer252_cons==1 | cancer270_cons==1 | cancer288_cons==1) & interval==18
replace cancer306 = 0 if cancer306!=1 & interval==18

*** Diabetes mellitus
* Code as 1 if the participant has been told by a doctor that they had diabetes, sugar in their urine, or high blood sugar ("Yes" or "Suspect or possible"), and the participant is now using medication that they swallow to treat or control their diabetes or the participant is now using insulin injections
gen diabetes_bl = 1 if inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)
* Code as 0 otherwise
replace diabetes_bl = 0 if diabetes_bl!=1
* Code as missing if the participant responds "Refused" or "Don't know" to the question about having had diabetes
replace diabetes_bl = . if inlist(mfu_cc6a,7,8)
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
gen diab_cons = diabetes_bl if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward diab_cons, replace
* Generate a new variable replicating the "diabetes_bl" variable for all baseline comprehensive assessments
gen diabetes = diabetes_bl if interval==1
* Code as 1 if the participant has been told by a doctor that they had diabetes, sugar in their urine, or high blood sugar ("Yes" or "Suspect or possible"), and the participant is now using medication that they swallow to treat or control their diabetes or the participant is now using insulin injections, and the participant was coded as NOT having diabetes at all prior comprehensive assessments (i.e., new condition)
replace diabetes = 1 if diab_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1))
* Code as 0 otherwise
replace diabetes = 0 if diabetes!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having had diabetes
replace diabetes = . if inlist(mfu_cc6a,.,7)
* Code as missing if the comprehensive assessment is not at baseline or 18-month follow-up (i.e., intervals 1-2)
replace diabetes = . if ! inlist(interval,1,2)

* Carryforward observations (diabetes at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen diab18_cons = raw_diab_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward diab18_cons, replace
gen diab36_cons = raw_diab_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward diab36_cons, replace
gen diab54_cons = raw_diab_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward diab54_cons, replace
gen diab72_cons = raw_diab_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward diab72_cons, replace
gen diab90_cons = raw_diab_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward diab90_cons, replace
gen diab108_cons = raw_diab_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward diab108_cons, replace
gen diab144_cons = raw_diab_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward diab144_cons, replace
gen diab162_cons = raw_diab_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward diab162_cons, replace
gen diab180_cons = raw_diab_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward diab180_cons, replace
gen diab198_cons = raw_diab_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward diab198_cons, replace
gen diab216_cons = raw_diab_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward diab216_cons, replace
gen diab234_cons = raw_diab_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward diab234_cons, replace
gen diab252_cons = raw_diab_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward diab252_cons, replace
gen diab270_cons = raw_diab_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward diab270_cons, replace
gen diab288_cons = raw_diab_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward diab288_cons, replace

* For intervals 3-18, code as 1 if the participant has been told by a doctor that they had diabetes, sugar in their urine, or high blood sugar ("Yes" or "Suspect or possible"), and the participant is now using medication that they swallow to treat or control their diabetes or the participant is now using insulin injections, and the participant was coded as NOT having diabetes at all prior comprehensive assessments (i.e., new condition)
replace diabetes = 1 if diab18_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==3
replace diabetes = 1 if diab36_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==4
replace diabetes = 1 if diab54_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==5
* Note that in the original syntax ("P:\projects\PEP\sas\FACE Master pgm\fu90face_3.sas" - not written by the authors of the current article) for the 90-month follow-up comprehensive assessment dataset compilation, "diab54_cons" was used in the following line of code rather than "diab72_cons" - this has been corrected here (the mistake in the comprehensive assessment dataset does not affect the raw_ccsumbl2 variable)
replace diabetes = 1 if diab72_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==6
replace diabetes = 1 if diab90_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==7
replace diabetes = 1 if diab108_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==9
replace diabetes = 1 if diab144_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==10
replace diabetes = 1 if diab162_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==11
replace diabetes = 1 if diab180_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==12
replace diabetes = 1 if diab198_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==13
replace diabetes = 1 if diab216_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==14
replace diabetes = 1 if diab234_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==15
replace diabetes = 1 if diab252_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==16
replace diabetes = 1 if diab270_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==17
replace diabetes = 1 if diab288_cons==0 & (inlist(mfu_cc6a,1,3) & (mfu_cc6b==1 | mfu_cc6c==1)) & interval==18

* Code as 0 otherwise
replace diabetes = 0 if diabetes!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having had diabetes
replace diabetes = . if inlist(mfu_cc6a,.,7)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace diabetes = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen diabminus = diabetes - raw_diabetes

* For each comprehensive assessment, code as 1 if the participant was newly coded as having had diabetes at the corresponding comprehensive assessment or the participant was coded as having had diabetes at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen diab18 = 1 if (diabetes==1 | diab_cons==1) & interval==2
replace diab18 = 0 if diab18!=1 & interval==2
gen diab36 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1) & interval==3
replace diab36 = 0 if diab36!=1 & interval==3
gen diab54 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1) & interval==4
replace diab54 = 0 if diab54!=1 & interval==4
gen diab72 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1) & interval==5
replace diab72 = 0 if diab72!=1 & interval==5
gen diab90 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1) & interval==6
replace diab90 = 0 if diab90!=1 & interval==6
gen diab108 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1) & interval==7
replace diab108 = 0 if diab108!=1 & interval==7
gen diab144 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1) & interval==9
replace diab144 = 0 if diab144!=1 & interval==9
gen diab162 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1) & interval==10
replace diab162 = 0 if diab162!=1 & interval==10
gen diab180 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1) & interval==11
replace diab180 = 0 if diab180!=1 & interval==11
gen diab198 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1) & interval==12
replace diab198 = 0 if diab198!=1 & interval==12
gen diab216 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1) & interval==13
replace diab216 = 0 if diab216!=1 & interval==13
gen diab234 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1 | diab216_cons==1) & interval==14
replace diab234 = 0 if diab234!=1 & interval==14
gen diab252 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1 | diab216_cons==1 | diab234_cons==1) & interval==15
replace diab252 = 0 if diab252!=1 & interval==15
gen diab270 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1 | diab216_cons==1 | diab234_cons==1 | diab252_cons==1) & interval==16
replace diab270 = 0 if diab270!=1 & interval==16
gen diab288 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1 | diab216_cons==1 | diab234_cons==1 | diab252_cons==1 | diab270_cons==1) & interval==17
replace diab288 = 0 if diab288!=1 & interval==17
gen diab306 = 1 if (diabetes==1 | diab_cons==1 | diab18_cons==1 | diab36_cons==1 | diab54_cons==1 | diab72_cons==1 | diab90_cons==1 | diab108_cons==1 | diab144_cons==1 | diab162_cons==1 | diab180_cons==1 | diab198_cons==1 | diab216_cons==1 | diab234_cons==1 | diab252_cons==1 | diab270_cons==1 | diab288_cons==1) & interval==18
replace diab306 = 0 if diab306!=1 & interval==18

*** Hip fracture
* Code as 1 if the participant has been told by a doctor that they had a broken or fractured hip and had to be hospitalized
gen hipf = 1 if mfu_cc7==1
* Code as 0 if the participant responds "Suspect or possible" or "No"
replace hipf = 0 if inlist(mfu_cc7,2,3)
* Code as 0 if the participant responds "Don't know"
replace hipf = 0 if mfu_cc7==8
* Code as missing if the participant refused to answer the question (or it was left blank) about having had a hip fracture
replace hipf = . if inlist(mfu_cc7,.,7)
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace hipf = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen hfminus = hipf - raw_hipfx

* Carryforward observations (hip fracture at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen hipfx_cons = raw_hipfx if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx_cons, replace
gen hipfx18_cons = raw_hipfx_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx18_cons, replace
gen hipfx36_cons = raw_hipfx_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx36_cons, replace
gen hipfx54_cons = raw_hipfx_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx54_cons, replace
gen hipfx72_cons = raw_hipfx_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx72_cons, replace
gen hipfx90_cons = raw_hipfx_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx90_cons, replace
gen hipfx108_cons = raw_hipfx_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx108_cons, replace
gen hipfx144_cons = raw_hipfx_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx144_cons, replace
gen hipfx162_cons = raw_hipfx_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx162_cons, replace
gen hipfx180_cons = raw_hipfx_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx180_cons, replace
gen hipfx198_cons = raw_hipfx_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx198_cons, replace
gen hipfx216_cons = raw_hipfx_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx216_cons, replace
gen hipfx234_cons = raw_hipfx_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx234_cons, replace
gen hipfx252_cons = raw_hipfx_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx252_cons, replace
gen hipfx270_cons = raw_hipfx_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx270_cons, replace
gen hipfx288_cons = raw_hipfx_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward hipfx288_cons, replace

* For each comprehensive assessment, code as 1 if the participant was newly coded as having had a hip fracture at the corresponding comprehensive assessment or the participant was coded as having had a hip fracture at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen hipfx18 = 1 if (hipf==1 | hipfx_cons==1) & interval==2
replace hipfx18 = 0 if hipfx18!=1 & interval==2
gen hipfx36 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1) & interval==3
replace hipfx36 = 0 if hipfx36!=1 & interval==3
gen hipfx54 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1) & interval==4
replace hipfx54 = 0 if hipfx54!=1 & interval==4
gen hipfx72 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1) & interval==5
replace hipfx72 = 0 if hipfx72!=1 & interval==5
gen hipfx90 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1) & interval==6
replace hipfx90 = 0 if hipfx90!=1 & interval==6
gen hipfx108 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1) & interval==7
replace hipfx108 = 0 if hipfx108!=1 & interval==7
gen hipfx144 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1) & interval==9
replace hipfx144 = 0 if hipfx144!=1 & interval==9
gen hipfx162 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1) & interval==10
replace hipfx162 = 0 if hipfx162!=1 & interval==10
gen hipfx180 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1) & interval==11
replace hipfx180 = 0 if hipfx180!=1 & interval==11
gen hipfx198 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1) & interval==12
replace hipfx198 = 0 if hipfx198!=1 & interval==12
gen hipfx216 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1) & interval==13
replace hipfx216 = 0 if hipfx216!=1 & interval==13
gen hipfx234 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1 | hipfx216_cons==1) & interval==14
replace hipfx234 = 0 if hipfx234!=1 & interval==14
gen hipfx252 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1 | hipfx216_cons==1 | hipfx234_cons==1) & interval==15
replace hipfx252 = 0 if hipfx252!=1 & interval==15
gen hipfx270 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1 | hipfx216_cons==1 | hipfx234_cons==1 | hipfx252_cons==1) & interval==16
replace hipfx270 = 0 if hipfx270!=1 & interval==16
gen hipfx288 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1 | hipfx216_cons==1 | hipfx234_cons==1 | hipfx252_cons==1 | hipfx270_cons==1) & interval==17
replace hipfx288 = 0 if hipfx288!=1 & interval==17
gen hipfx306 = 1 if (hipf==1 | hipfx_cons==1 | hipfx18_cons==1 | hipfx36_cons==1 | hipfx54_cons==1 | hipfx72_cons==1 | hipfx90_cons==1 | hipfx108_cons==1 | hipfx144_cons==1 | hipfx162_cons==1 | hipfx180_cons==1 | hipfx198_cons==1 | hipfx216_cons==1 | hipfx234_cons==1 | hipfx252_cons==1 | hipfx270_cons==1 | hipfx288_cons==1) & interval==18
replace hipfx306 = 0 if hipfx306!=1 & interval==18

*** Arthritis
* For all baseline comprehensive assessments, code as 1 if the participant has seen a doctor specifically for arthritis or rheumatism and they had pain and/or stiffness in their hands/fingers, shoulders, knees, hips, and/or back/spine
gen arth = 1 if inlist(mfu_cc8a,1,3) & (mfu_cc8b1==1 | mfu_cc8b2==1 | mfu_cc8b3==1 | mfu_cc8b4==1 | mfu_cc8b5==1) & interval==1
* Code as 0 if the participant has not seen a doctor specifically for arthritis or rheumatism, or if the participant has seen a doctor specifically for arthritis or rheumatism but they did not have pain and/or stiffness in their joints
replace arth = 0 if (mfu_cc8a==2 | (inlist(mfu_cc8a,1,3) & (mfu_cc8b1!=1 & mfu_cc8b2!=1 & mfu_cc8b3!=1 & mfu_cc8b4!=1 & mfu_cc8b5!=1))) & interval==1
* For all follow-up comprehensive assessments, code as 1 if the participant has seen a doctor specifically for arthritis or rheumatism and they had pain and/or stiffness in their hands/fingers, shoulders, knees, hips, and/or back/spine
replace arth = 1 if inlist(mfu_cc8a,1,3) & (mfu_cc8b1==1 | mfu_cc8b2==1 | mfu_cc8b3==1 | mfu_cc8b4==1 | mfu_cc8b5==1) & interval!=1
* Code as 0 if the participant has not seen a doctor specifically for arthritis or rheumatism, or if the participant has seen a doctor specifically for arthritis or rheumatism but they did not have pain and/or stiffness in their joints
replace arth = 0 if (mfu_cc8a==2 | (inlist(mfu_cc8a,1,3) & (mfu_cc8b1!=1 & mfu_cc8b2!=1 & mfu_cc8b3!=1 & mfu_cc8b4!=1 & mfu_cc8b5!=1))) & interval!=1
* Code as 0 if the participant responds "Don't know"
replace arth = 0 if mfu_cc8a==8 & interval!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having seen a doctor specifically for arthritis or rheumatism
replace arth = . if inlist(mfu_cc8a,.,7) & interval!=1
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace arth = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen arminus = arth - raw_arthrit

* Carryforward observations (arthritis at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen arth_cons = raw_arthrit if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward arth_cons, replace
gen arth18_cons = raw_arth_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward arth18_cons, replace
gen arth36_cons = raw_arth_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward arth36_cons, replace
gen arth54_cons = raw_arth_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward arth54_cons, replace
gen arth72_cons = raw_arth_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward arth72_cons, replace
gen arth90_cons = raw_arth_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward arth90_cons, replace
gen arth108_cons = raw_arth_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward arth108_cons, replace
gen arth144_cons = raw_arth_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward arth144_cons, replace
gen arth162_cons = raw_arth_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward arth162_cons, replace
gen arth180_cons = raw_arth_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward arth180_cons, replace
gen arth198_cons = raw_arth_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward arth198_cons, replace
gen arth216_cons = raw_arth_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward arth216_cons, replace
gen arth234_cons = raw_arth_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward arth234_cons, replace
gen arth252_cons = raw_arth_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward arth252_cons, replace
gen arth270_cons = raw_arth_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward arth270_cons, replace
gen arth288_cons = raw_arth_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward arth288_cons, replace

* For each comprehensive assessment, code as 1 if the participant was newly coded as having arthritis at the corresponding comprehensive assessment or the participant was coded as having arthritis at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen arth18 = 1 if (arth==1 | arth_cons==1) & interval==2
replace arth18 = 0 if arth18!=1 & interval==2
gen arth36 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1) & interval==3
replace arth36 = 0 if arth36!=1 & interval==3
gen arth54 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1) & interval==4
replace arth54 = 0 if arth54!=1 & interval==4
gen arth72 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1) & interval==5
replace arth72 = 0 if arth72!=1 & interval==5
gen arth90 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1) & interval==6
replace arth90 = 0 if arth90!=1 & interval==6
gen arth108 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1) & interval==7
replace arth108 = 0 if arth108!=1 & interval==7
gen arth144 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1) & interval==9
replace arth144 = 0 if arth144!=1 & interval==9
gen arth162 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1) & interval==10
replace arth162 = 0 if arth162!=1 & interval==10
gen arth180 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1) & interval==11
replace arth180 = 0 if arth180!=1 & interval==11
gen arth198 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1) & interval==12
replace arth198 = 0 if arth198!=1 & interval==12
gen arth216 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1) & interval==13
replace arth216 = 0 if arth216!=1 & interval==13
gen arth234 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1 | arth216_cons==1) & interval==14
replace arth234 = 0 if arth234!=1 & interval==14
gen arth252 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1 | arth216_cons==1 | arth234_cons==1) & interval==15
replace arth252 = 0 if arth252!=1 & interval==15
gen arth270 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1 | arth216_cons==1 | arth234_cons==1 | arth252_cons==1) & interval==16
replace arth270 = 0 if arth270!=1 & interval==16
gen arth288 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1 | arth216_cons==1 | arth234_cons==1 | arth252_cons==1 | arth270_cons==1) & interval==17
replace arth288 = 0 if arth288!=1 & interval==17
gen arth306 = 1 if (arth==1 | arth_cons==1 | arth18_cons==1 | arth36_cons==1 | arth54_cons==1 | arth72_cons==1 | arth90_cons==1 | arth108_cons==1 | arth144_cons==1 | arth162_cons==1 | arth180_cons==1 | arth198_cons==1 | arth216_cons==1 | arth234_cons==1 | arth252_cons==1 | arth270_cons==1 | arth288_cons==1) & interval==18
replace arth306 = 0 if arth306!=1 & interval==18

*** Chronic lung disease
* For all baseline comprehensive assessments, code as 1 if the participant has been told by a doctor that they have chronic lung disease such as chronic bronchitis, COPD, asthma, or emphysema ("Yes"), or the participant has been told by a doctor that they possibly have chronic lung disease ("Suspect or possible") and the participant's lung disease limits their usual activities such as household chores
gen copd = 1 if (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1)) & interval==1
* Code as 0 otherwise
replace copd = 0 if copd!=1 & interval==1
* Code as missing if either question was left blank
replace copd = . if mfu_cc9a==. & mfu_cc9b==. & interval==1
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
gen copd_cons = copd if interval==1
tsset STUDYID interval 
bysort STUDYID: carryforward copd_cons, replace
* For all 18-month follow-up comprehensive assessments, code as 1 if the participant has been told by a doctor that they have chronic lung disease such as chronic bronchitis, COPD, asthma, or emphysema ("Yes"), or the participant has been told by a doctor that they possibly have chronic lung disease ("Suspect or possible") and the participant's lung disease limits their usual activities such as household chores, and the participant was coded as NOT having chronic lung disease at the baseline comprehensive assessment (i.e., new condition)
replace copd = 1 if (copd_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==2
* Code as 0 otherwise
replace copd = 0 if copd!=1 & interval==2
* Code as missing if the participant refused to answer the question (or it was left blank) about having chronic lung disease
replace copd = . if inlist(mfu_cc9a,.,7)
* Code as missing if the comprehensive assessment is not at baseline or 18-month follow-up (i.e., intervals 1-2)
replace copd = . if ! inlist(interval,1,2)

* Carryforward observations (chronic lung disease at the current comprehensive assessment or any prior comprehensive assessment) with respect to the time variable "interval" (i.e., to all subsequent comprehensive assessments) by participant ID
gen lungd18_cons = raw_lungd_18 if interval==2
tsset STUDYID interval 
bysort STUDYID: carryforward lungd18_cons, replace
gen lungd36_cons = raw_lungd_36 if interval==3
tsset STUDYID interval 
bysort STUDYID: carryforward lungd36_cons, replace
gen lungd54_cons = raw_lungd_54 if interval==4
tsset STUDYID interval 
bysort STUDYID: carryforward lungd54_cons, replace
gen lungd72_cons = raw_lungd_72 if interval==5
tsset STUDYID interval 
bysort STUDYID: carryforward lungd72_cons, replace
gen lungd90_cons = raw_lungd_90 if interval==6
tsset STUDYID interval 
bysort STUDYID: carryforward lungd90_cons, replace
gen lungd108_cons = raw_lungd_108 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward lungd108_cons, replace
gen lungd144_cons = raw_lungd_144 if interval==9
tsset STUDYID interval 
bysort STUDYID: carryforward lungd144_cons, replace
gen lungd162_cons = raw_lungd_162 if interval==10
tsset STUDYID interval 
bysort STUDYID: carryforward lungd162_cons, replace
gen lungd180_cons = raw_lungd_180 if interval==11
tsset STUDYID interval 
bysort STUDYID: carryforward lungd180_cons, replace
gen lungd198_cons = raw_lungd_198 if interval==12
tsset STUDYID interval 
bysort STUDYID: carryforward lungd198_cons, replace
gen lungd216_cons = raw_lungd_216 if interval==13
tsset STUDYID interval 
bysort STUDYID: carryforward lungd216_cons, replace
gen lungd234_cons = raw_lungd_234 if interval==14
tsset STUDYID interval 
bysort STUDYID: carryforward lungd234_cons, replace
gen lungd252_cons = raw_lungd_252 if interval==15
tsset STUDYID interval 
bysort STUDYID: carryforward lungd252_cons, replace
gen lungd270_cons = raw_lungd_270 if interval==16
tsset STUDYID interval 
bysort STUDYID: carryforward lungd270_cons, replace
gen lungd288_cons = raw_lungd_288 if interval==17
tsset STUDYID interval 
bysort STUDYID: carryforward lungd288_cons, replace

* For intervals 3-18, code as 1 if the participant has been told by a doctor that they have chronic lung disease such as chronic bronchitis, COPD, asthma, or emphysema ("Yes"), or the participant has been told by a doctor that they possibly have chronic lung disease ("Suspect or possible") and the participant's lung disease limits their usual activities such as household chores, and the participant was coded as NOT having chronic lung disease at all prior comprehensive assessments (i.e., new condition)
replace copd = 1 if (lungd18_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==3
replace copd = 1 if (lungd36_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==4
replace copd = 1 if (lungd54_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==5
replace copd = 1 if (lungd72_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==6
replace copd = 1 if (lungd90_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==7
replace copd = 1 if (lungd108_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==9
replace copd = 1 if (lungd144_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==10
replace copd = 1 if (lungd162_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==11
replace copd = 1 if (lungd180_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==12
replace copd = 1 if (lungd198_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==13
replace copd = 1 if (lungd216_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==14
replace copd = 1 if (lungd234_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==15
replace copd = 1 if (lungd252_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==16
replace copd = 1 if (lungd270_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==17
replace copd = 1 if (lungd288_cons==0 & (mfu_cc9a==1 | (mfu_cc9a==3 & mfu_cc9b==1))) & interval==18

* Code as 0 otherwise
replace copd = 0 if copd!=1
* Code as missing if the participant refused to answer the question (or it was left blank) about having chronic lung disease
replace copd = . if inlist(mfu_cc9a,.,7)
* Generate a new variable replicating the "copd" variable
gen lung_d = copd
* Code as 0 if the participant responds "Don't know"
replace lung_d = 0 if mfu_cc9a==8
* If mfu_cc1a or mfu_cc1b; mfu_cc2; mfu_cc3; mfu_cc4a; mfu_cc5; mfu_cc6a or mfu_cc6b or mfu_cc6c; mfu_cc7; mfu_cc8a; and mfu_cc9a are coded as "Don't know", treat observation as a missing case
replace lung_d = . if STUDYID==2007 & interval==2
* Compare values with variable from combined comprehensive assessment dataset
gen lungminus = lung_d - raw_lung_d
* If mfu_cc9a is coded as "Suspect or possible" and mfu_cc9b is coded as "Yes", but chronic lung disease at the previous comprehensive assessment was left blank, code as 1
replace lung_d = 1 if STUDYID==510 & interval==3
* Compare values with variable from combined comprehensive assessment dataset
gen lungminus2 = lung_d - raw_lung_d

* For each comprehensive assessment, code as 1 if the participant was newly coded as having chronic lung disease at the corresponding comprehensive assessment or the participant was coded as having chronic lung disease at any prior comprehensive assessment(s)
* Code as 0 otherwise
gen lungd18 = 1 if (lung_d==1 | copd_cons==1) & interval==2
replace lungd18 = 0 if lungd18!=1 & interval==2
gen lungd36 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1) & interval==3
replace lungd36 = 0 if lungd36!=1 & interval==3
gen lungd54 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1) & interval==4
replace lungd54 = 0 if lungd54!=1 & interval==4
gen lungd72 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1) & interval==5
replace lungd72 = 0 if lungd72!=1 & interval==5
gen lungd90 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1) & interval==6
replace lungd90 = 0 if lungd90!=1 & interval==6
gen lungd108 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1) & interval==7
replace lungd108 = 0 if lungd108!=1 & interval==7
gen lungd144 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1) & interval==9
replace lungd144 = 0 if lungd144!=1 & interval==9
gen lungd162 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1) & interval==10
replace lungd162 = 0 if lungd162!=1 & interval==10
gen lungd180 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1) & interval==11
replace lungd180 = 0 if lungd180!=1 & interval==11
gen lungd198 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1) & interval==12
replace lungd198 = 0 if lungd198!=1 & interval==12
gen lungd216 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1) & interval==13
replace lungd216 = 0 if lungd216!=1 & interval==13
gen lungd234 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1 | lungd216_cons==1) & interval==14
replace lungd234 = 0 if lungd234!=1 & interval==14
gen lungd252 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1 | lungd216_cons==1 | lungd234_cons==1) & interval==15
replace lungd252 = 0 if lungd252!=1 & interval==15
gen lungd270 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1 | lungd216_cons==1 | lungd234_cons==1 | lungd252_cons==1) & interval==16
replace lungd270 = 0 if lungd270!=1 & interval==16
gen lungd288 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1 | lungd216_cons==1 | lungd234_cons==1 | lungd252_cons==1 | lungd270_cons==1) & interval==17
replace lungd288 = 0 if lungd288!=1 & interval==17
gen lungd306 = 1 if (lung_d==1 | copd_cons==1 | lungd18_cons==1 | lungd36_cons==1 | lungd54_cons==1 | lungd72_cons==1 | lungd90_cons==1 | lungd108_cons==1 | lungd144_cons==1 | lungd162_cons==1 | lungd180_cons==1 | lungd198_cons==1 | lungd216_cons==1 | lungd234_cons==1 | lungd252_cons==1 | lungd270_cons==1 | lungd288_cons==1) & interval==18
replace lungd306 = 0 if lungd306!=1 & interval==18

*** Sum
tab raw_ccsumbl2
* At baseline and each follow-up comprehensive assessment, generate a count of the number of chronic conditions
gen chronic3 = (hbp18 + mi18 + chf18 + stroke18 + cancer18 + diab18 + hipfx18 + lungd18 + arth18) if interval==2
replace chronic3 = (hbp36 + mi36 + chf36 + stroke36 + cancer36 + diab36 + hipfx36 + lungd36 + arth36) if interval==3
replace chronic3 = (hbp54 + mi54 + chf54 + stroke54 + cancer54 + diab54 + hipfx54 + lungd54 + arth54) if interval==4
replace chronic3 = (hbp72 + mi72 + chf72 + stroke72 + cancer72 + diab72 + hipfx72 + lungd72 + arth72) if interval==5
replace chronic3 = (hbp90 + mi90 + chf90 + stroke90 + cancer90 + diab90 + hipfx90 + lungd90 + arth90) if interval==6
replace chronic3 = (hbp108 + mi108 + chf108 + stroke108 + cancer108 + diab108 + hipfx108 + lungd108 + arth108) if interval==7
replace chronic3 = (hbp144 + mi144 + chf144 + stroke144 + cancer144 + diab144 + hipfx144 + lungd144 + arth144) if interval==9
replace chronic3 = (hbp162 + mi162 + chf162 + stroke162 + cancer162 + diab162 + hipfx162 + lungd162 + arth162) if interval==10
replace chronic3 = (hbp180 + mi180 + chf180 + stroke180 + cancer180 + diab180 + hipfx180 + lungd180 + arth180) if interval==11
replace chronic3 = (hbp198 + mi198 + chf198 + stroke198 + cancer198 + diab198 + hipfx198 + lungd198 + arth198) if interval==12
replace chronic3 = (hbp216 + mi216 + chf216 + stroke216 + cancer216 + diab216 + hipfx216 + lungd216 + arth216) if interval==13
replace chronic3 = (hbp234 + mi234 + chf234 + stroke234 + cancer234 + diab234 + hipfx234 + lungd234 + arth234) if interval==14
replace chronic3 = (hbp252 + mi252 + chf252 + stroke252 + cancer252 + diab252 + hipfx252 + lungd252 + arth252) if interval==15
replace chronic3 = (hbp270 + mi270 + chf270 + stroke270 + cancer270 + diab270 + hipfx270 + lungd270 + arth270) if interval==16
replace chronic3 = (hbp288 + mi288 + chf288 + stroke288 + cancer288 + diab288 + hipfx288 + lungd288 + arth288) if interval==17
replace chronic3 = (hbp306 + mi306 + chf306 + stroke306 + cancer306 + diab306 + hipfx306 + lungd306 + arth306) if interval==18
replace chronic3 = (highbl + heart + chf + stroke + cancer + diabetes + hipf + arth + lung_d) if interval==1
* Compare values with variable from combined comprehensive assessment dataset
gen ch3minus = chronic3 - raw_ccsumbl2

* Lifestyle risk factors
** Alcohol consumption (time-constant)
* Code items 2 to 5 as missing if the participant responded "Refused" or "Don't know"
* Code items 2 to 5 as 0 if the question was "Not applicable"
gen alc2_n = mfu_alc2
replace alc2_n = . if inlist(alc2_n,7,8)
replace alc2_n = 0 if inlist(alc2_n,9)
gen alc3_n = mfu_alc3
replace alc3_n = . if inlist(alc3_n,7,8)
replace alc3_n = 0 if inlist(alc3_n,9)
gen alc4_n = mfu_alc4
replace alc4_n = . if inlist(alc4_n,7,8)
replace alc4_n = 0 if inlist(alc4_n,9)
gen alc5_n = mfu_alc5
replace alc5_n = . if inlist(alc5_n,7,8)
replace alc5_n = 0 if inlist(alc5_n,9)
* Sum items
gen alc_sum = mfu_alc1+alc2_n+alc3_n+alc4_n+alc5_n
* Code as 0 (lower risk) if the participant had a score of 4 or less
gen alc_bi = 0 if inlist(alc_sum,0,1,2,3,4)
* Code as 1 (higher risk) if the participant had a score of 5 or more
replace alc_bi = 1 if alc_sum >=5 & alc_sum!=.
* Compare values with variable from combined comprehensive assessment dataset
gen alcminus = raw_alc_bl - alc_bi
* Generate a new variable duplicating the alcohol consumption variable at baseline
gen alc_cons = alc_bi if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward alc_cons, replace

** Smoking (time-varying)
* Code as 0 (lower risk) if the participant reported having never smoked
gen smoking = 0 if mfu_smo1==1
* Code as 1 (higher risk) if the participant reported being a former or current smoker
replace smoking = 1 if inlist(mfu_smo1,2,3)
* Hard codes documented in "P:\projects\PEP\sas\FACE Master pgm\fu18face_3.sas", "P:\projects\PEP\sas\FACE Master pgm\fu36face_3.sas", and "P:\projects\PEP\sas\FACE Master pgm\fu54face_3.sas"
replace smoking = 1 if inlist(STUDYID,1402,2570) & interval==2
replace smoking = 0 if STUDYID==1888 & interval==3
replace smoking = 1 if inlist(STUDYID,1402,1646,2946,3170) & interval==3
replace smoking = 0 if inlist(STUDYID,291,331,1223,1888,2076) & interval==4
replace smoking = 1 if inlist(STUDYID,1252,1259,2853,2946,3027,3102) & interval==4
* Compare values with variable from combined comprehensive assessment dataset
gen smokminus = smoking - raw_smoker_bl

** Low physical activity (time-varying)
* Score by following the instructions for the Physical Activity Scale for the Elderly (Washburn RA, Smith KW, Jette AM, Janney CA. The physical activity scale for the elderly (PASE): development and evaluation. J Clin Epidemiol. 1993;46:153–62.)
gen mpase1w = 0 if mfu_mpase1==1
replace mpase1w = 0.11 if mfu_mpase1==2 & mfu_mpase1a==1
replace mpase1w = 0.32 if mfu_mpase1==2 & mfu_mpase1a==2
replace mpase1w = 0.64 if mfu_mpase1==2 & mfu_mpase1a==3
replace mpase1w = 1.07 if mfu_mpase1==2 & mfu_mpase1a==4
replace mpase1w = 0.25 if mfu_mpase1==3 & mfu_mpase1a==1
replace mpase1w = 0.75 if mfu_mpase1==3 & mfu_mpase1a==2
replace mpase1w = 1.50 if mfu_mpase1==3 & mfu_mpase1a==3
replace mpase1w = 2.50 if mfu_mpase1==3 & mfu_mpase1a==4
replace mpase1w = 0.43 if mfu_mpase1==4 & mfu_mpase1a==1
replace mpase1w = 1.29 if mfu_mpase1==4 & mfu_mpase1a==2
replace mpase1w = 2.57 if mfu_mpase1==4 & mfu_mpase1a==3
replace mpase1w = 4.29 if mfu_mpase1==4 & mfu_mpase1a==4
replace mpase1w = mpase1w*20
* Hard code documented in "P:\projects\PEP\sas\FACE Master pgm\baseface_3.sas"
replace mfu_mpase1a = 1 if STUDYID==1884 & interval==1
replace mpase1w = 0.11*20 if STUDYID==1884 & interval==1
* Compare values with variable from combined comprehensive assessment dataset
gen mpa1minus = mpase1w - raw_mpase1w

gen mpase2w = 0 if mfu_mpase2==1
replace mpase2w = 0.11 if mfu_mpase2==2 & mfu_mpase2a==1
replace mpase2w = 0.32 if mfu_mpase2==2 & mfu_mpase2a==2
replace mpase2w = 0.64 if mfu_mpase2==2 & mfu_mpase2a==3
replace mpase2w = 1.07 if mfu_mpase2==2 & mfu_mpase2a==4
replace mpase2w = 0.25 if mfu_mpase2==3 & mfu_mpase2a==1
replace mpase2w = 0.75 if mfu_mpase2==3 & mfu_mpase2a==2
replace mpase2w = 1.50 if mfu_mpase2==3 & mfu_mpase2a==3
replace mpase2w = 2.50 if mfu_mpase2==3 & mfu_mpase2a==4
replace mpase2w = 0.43 if mfu_mpase2==4 & mfu_mpase2a==1
replace mpase2w = 1.29 if mfu_mpase2==4 & mfu_mpase2a==2
replace mpase2w = 2.57 if mfu_mpase2==4 & mfu_mpase2a==3
replace mpase2w = 4.29 if mfu_mpase2==4 & mfu_mpase2a==4
replace mpase2w = mpase2w*21
* Compare values with variable from combined comprehensive assessment dataset
gen mpa2minus = mpase2w - raw_mpase2w

gen mpase3w = 0 if mfu_mpase3==1
replace mpase3w = 0.11 if mfu_mpase3==2 & mfu_mpase3a==1
replace mpase3w = 0.32 if mfu_mpase3==2 & mfu_mpase3a==2
replace mpase3w = 0.64 if mfu_mpase3==2 & mfu_mpase3a==3
replace mpase3w = 1.07 if mfu_mpase3==2 & mfu_mpase3a==4
replace mpase3w = 0.25 if mfu_mpase3==3 & mfu_mpase3a==1
replace mpase3w = 0.75 if mfu_mpase3==3 & mfu_mpase3a==2
replace mpase3w = 1.50 if mfu_mpase3==3 & mfu_mpase3a==3
replace mpase3w = 2.50 if mfu_mpase3==3 & mfu_mpase3a==4
replace mpase3w = 0.43 if mfu_mpase3==4 & mfu_mpase3a==1
replace mpase3w = 1.29 if mfu_mpase3==4 & mfu_mpase3a==2
replace mpase3w = 2.57 if mfu_mpase3==4 & mfu_mpase3a==3
replace mpase3w = 4.29 if mfu_mpase3==4 & mfu_mpase3a==4
replace mpase3w = mpase3w*23
* Compare values with variable from combined comprehensive assessment dataset
gen mpa3minus = mpase3w - raw_mpase3w

gen mpase4w = 0 if mfu_mpase4==1
replace mpase4w = 0.11 if mfu_mpase4==2 & mfu_mpase4a==1
replace mpase4w = 0.32 if mfu_mpase4==2 & mfu_mpase4a==2
replace mpase4w = 0.64 if mfu_mpase4==2 & mfu_mpase4a==3
replace mpase4w = 1.07 if mfu_mpase4==2 & mfu_mpase4a==4
replace mpase4w = 0.25 if mfu_mpase4==3 & mfu_mpase4a==1
replace mpase4w = 0.75 if mfu_mpase4==3 & mfu_mpase4a==2
replace mpase4w = 1.50 if mfu_mpase4==3 & mfu_mpase4a==3
replace mpase4w = 2.50 if mfu_mpase4==3 & mfu_mpase4a==4
replace mpase4w = 0.43 if mfu_mpase4==4 & mfu_mpase4a==1
replace mpase4w = 1.29 if mfu_mpase4==4 & mfu_mpase4a==2
replace mpase4w = 2.57 if mfu_mpase4==4 & mfu_mpase4a==3
replace mpase4w = 4.29 if mfu_mpase4==4 & mfu_mpase4a==4
replace mpase4w = mpase4w*23
* Compare values with variable from combined comprehensive assessment dataset
gen mpa4minus = mpase4w - raw_mpase4w

gen mpase5w = 0 if mfu_mpase5==1
replace mpase5w = 0.11 if mfu_mpase5==2 & mfu_mpase5a==1
replace mpase5w = 0.32 if mfu_mpase5==2 & mfu_mpase5a==2
replace mpase5w = 0.64 if mfu_mpase5==2 & mfu_mpase5a==3
replace mpase5w = 1.07 if mfu_mpase5==2 & mfu_mpase5a==4
replace mpase5w = 0.25 if mfu_mpase5==3 & mfu_mpase5a==1
replace mpase5w = 0.75 if mfu_mpase5==3 & mfu_mpase5a==2
replace mpase5w = 1.50 if mfu_mpase5==3 & mfu_mpase5a==3
replace mpase5w = 2.50 if mfu_mpase5==3 & mfu_mpase5a==4
replace mpase5w = 0.43 if mfu_mpase5==4 & mfu_mpase5a==1
replace mpase5w = 1.29 if mfu_mpase5==4 & mfu_mpase5a==2
replace mpase5w = 2.57 if mfu_mpase5==4 & mfu_mpase5a==3
replace mpase5w = 4.29 if mfu_mpase5==4 & mfu_mpase5a==4
replace mpase5w = mpase5w*30
* Compare values with variable from combined comprehensive assessment dataset
gen mpa5minus = mpase5w - raw_mpase5w

* Recode as 0 if the participant responded "No", "Refused", or "Don't know"
recode mfu_mpase6 mfu_mpase7 mfu_mpase8a mfu_mpase8b mfu_mpase8c mfu_mpase8d (2=0)(7=0)(8=0), prefix(new)
gen mpase6w = newmfu_mpase6*25
* Compare values with variable from combined comprehensive assessment dataset
gen mpa6minus = mpase6w - raw_mpase6w
gen mpase7w = newmfu_mpase7*25
* Compare values with variable from combined comprehensive assessment dataset
gen mpa7minus = mpase7w - raw_mpase7w
gen mpase8aw = newmfu_mpase8a*30
* Compare values with variable from combined comprehensive assessment dataset 
gen mpa8aminus = mpase8aw - raw_mpase8aw
gen mpase8bw = newmfu_mpase8b*36
* Compare values with variable from combined comprehensive assessment dataset
gen mpa8bminus = mpase8bw - raw_mpase8bw
gen mpase8cw = newmfu_mpase8c*20
* Compare values with variable from combined comprehensive assessment dataset
gen mpa8cminus = mpase8cw - raw_mpase8cw
gen mpase8dw = newmfu_mpase8d*35
* Compare values with variable from combined comprehensive assessment dataset
gen mpa8dminus = mpase8dw - raw_mpase8dw

* Generate a new variable duplicating the variable "How many hours per week did you work for pay and/or as a volunteer?"
gen newmpase9b = mfu_mpase9b
* For intervals 2 to 16, code as 0 if the participant responded "No", "Refused", or "Don't know" to the question "During the past 7 days, did you work for pay or as a volunteer?" and responded "Refused", "Don't know", or "Not applicable" to the question "How many hours per week did you work for pay and/or as a volunteer?"
replace newmpase9b = 0 if inlist(mfu_mpase9a,2,7,8) & inlist(newmpase9b,99,97,98) & inlist(interval,2,3,4,5,6,7,9,10,11,12,13,14,15,16)
* Hard code documented in "P:\projects\PEP\Evelyne\Analysis\fu270face_3.sas"
replace newmpase9b = 0 if STUDYID==129 & interval==16
* For intervals 17 and 18, code as 0 if the participant responded "No", "Refused", or "Don't know" to the question "During the past 7 days, did you work for pay or as a volunteer?" and responded "Refused", "Don't know", or "Not applicable" to the question "How many hours per week did you work for pay and/or as a volunteer?" (or left it blank) 
replace newmpase9b = 0 if inlist(mfu_mpase9a,2,7,8) & inlist(newmpase9b,.,99,97,98) & inlist(interval,17,18)
* For interval 1, code as missing
replace newmpase9b = . if interval==1
* Generate a new variable duplicating the variable "How many hours per week did you work for pay and/or as a volunteer?" at baseline
gen newmpase9c = mfu_mpase9c if interval==1
* Code as 0 if the participant responded "No", "Refused", or "Don't know" to the question "During the past 7 days, did you work for pay or as a volunteer?" and responded "Refused", "Don't know", or "Not applicable" to the question "How many hours per week did you work for pay and/or as a volunteer?"
replace newmpase9c = 0 if inlist(mfu_mpase9a,2,7,8) & inlist(newmpase9c,99,97,98)
gen mpase9w = (newmpase9b/7)*21 if interval!=1
replace mpase9w = (newmpase9c/7)*21 if interval==1
* Compare values with variable from combined comprehensive assessment dataset
gen mpa9minus = mpase9w - raw_mpase9cw

* Sum items
gen mpase_new = mpase1w + mpase2w + mpase3w + mpase4w + mpase5w + mpase6w + mpase7w + mpase8aw + mpase8bw + mpase8cw + mpase8dw + mpase9w
* Compare values (in terms of precision) with variable from combined comprehensive assessment dataset
gen mpminus = mpase_new - raw_mpasebl
gen mpase_final = raw_mpasebl
* Code as 0 (lower risk) if the participant scored 64 or more and was a man
gen low_pa = 0 if mpase_final>=64 & mpase_final!=. & sex_cons==0
* Code as 0 (lower risk) if the participant scored 52 or more and was a woman
replace low_pa = 0 if mpase_final>=52 & mpase_final!=. & sex_cons==1
* Code as 1 (higher risk) if the participant scored less than 64 and was a man
replace low_pa = 1 if mpase_final<64 & sex_cons==0
* Code as 1 (higher risk) if the participant scored less than 52 and was a woman
replace low_pa = 1 if mpase_final<52 & sex_cons==1

** Obesity (time-varying)
* Convert height in feet to inches
gen ht_inch = mfu_HT1*12
replace ht_inch = ht_inch+mfu_HT2
* Convert height in inches to meters
gen meters = ht_inch/39.37
* Generate a new variable duplicating the height (in meters) variable at baseline
gen hei_cons = meters if interval==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "interval"
tsset STUDYID interval 
* Carryforward observations with respect to the time variable "interval" (i.e., from baseline to the follow-up comprehensive assessments) by participant ID
bysort STUDYID: carryforward hei_cons, replace
* Convert weight in pounds to kilograms
gen weight = mfu_wt1a/2.205
* Observations coded as "Refused" or "Don't know" were treated as missing cases
replace weight = . if inlist(mfu_wt1a,997,998)
* Calculate body mass index (BMI) using the standard formula
gen BMI_raw = weight/(hei_cons*hei_cons)
* Compare values with variable from combined comprehensive assessment dataset
gen bmiminus = BMI_raw - raw_BMI_bl
* Code as 0 (lower risk) if the participant had a BMI below 30 kg/m2
gen obesity = 0 if BMI_raw <30.00
* Code as 1 (higher risk) if the participant had a BMI above or equal to 30 kg/m2
replace obesity = 1 if BMI_raw >=30.00 & BMI_raw!=.
* Compare values with variable from combined comprehensive assessment dataset
gen obminus = BMI_ge30 - obesity

* Disability at the comprehensive assessments
replace mfu_pf1a = 1 if interval==1
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to bathe (wash and dry your whole body)?"
gen bathing = 0 if mfu_pf1a==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace bathing = 1 if inlist(mfu_pf1a,2,3)
* Code as 0 if the participant responds "No help"
replace bathing = 0 if mfu_bath3==1 & interval>=3
* Code as 1 if the participant responds "Help" or "Unable to do"
replace bathing = 1 if inlist(mfu_bath3,2,3) & interval>=3

replace mfu_pf2a = 1 if interval==1
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to dress (like putting on a shirt or shoes, buttoning and zippering)?"
gen dressing = 0 if mfu_pf2a==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace dressing = 1 if inlist(mfu_pf2a,2,3)

replace mfu_pf3a = 1 if interval==1
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to get in and out of a chair?"
gen transferring = 0 if mfu_pf3a==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace transferring = 1 if inlist(mfu_pf3a,2,3)

replace mfu_pf4a = 1 if interval==1 
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to walk around your house or apartment?"
gen waround = 0 if mfu_pf4a==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace waround = 1 if inlist(mfu_pf4a,2,3)

** Sum
* Generate a count of the number of essential activities of daily living (ADL) requiring personal assistance
gen adldep = bathing + dressing + transferring + waround
* Code as 0 if the participant is fully independent 
gen adldep_bi = 0 if adldep==0
* Code as 1 if the participant is dependent in one or more ADL
replace adldep_bi = 1 if inlist(adldep,1,2,3,4)

* Overwrite dataset, by replacing the previously saved file
save comprehensive_analyses.dta, replace
clear 

* Import monthly data
import sas using "P:\projects\PEP\Master\pepmonth_le123124\pepmonth_le123124.sas7bdat"
* Keep data pertaining only to decedents
keep if Died==1
* Keep data from the first monthly interview
keep if intbloc==1
* Rename StudyID variable to ensure consistency with updated master dataset
rename StudyID STUDYID
* Keep relevant variables
keep STUDYID DDate 
* Rename DDate variable to differentiate it from the less recent DDate variable in the updated master dataset
rename DDate DDate2
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Save corrected date of death dataset with a new name
save deaths.dta
clear

* Use updated master dataset
use comprehensive_analyses.dta 
* Merge updated master dataset with corrected date of death dataset
merge m:1 STUDYID using deaths.dta, generate(merge_death)
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 5168 observations
* Overwrite dataset, by replacing the previously saved file
save comprehensive_analyses.dta, replace

* Drop interval 8 (no comprehensive assessments took place at the 126-month follow-up owing to lack of funds)
drop if interval==8
* Count total number of participants and observations
unique STUDYID 
* 754 individuals, 4867 observations
* Amount of missing data
sum age_fix
tab edu_cons_bi if interval==1
tab inc_bimi if interval==1 
tab adi_cons if interval==1
tab alc_cons if interval==1
tab smoking 
tab low_pa
tab obesity
tab sex_cons if interval==1
tab eth_bi if interval==1
sum raw_ccsumbl2
clear

* Import monthly data
import sas using "P:\projects\PEP\Master\pepmonth_le123124\pepmonth_le123124.sas7bdat"
* Rename StudyID variable to ensure consistency with updated master dataset
rename StudyID STUDYID
* Generate a variable that assigns the observation number (i.e., 1 for first data collection timepoint, 2 for second data collection timepoint) to each row by participant ID
bysort STUDYID(intbloc): gen obsnr_m = _n
* Generate a variable that assigns the number of total observations to each row of data for a given participant
bysort STUDYID: gen obscount_m = _N

** Disability during the monthly interviews
gen act1n = ACT1
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to bathe (wash and dry your whole body)?"
replace act1n = 0 if act1n==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace act1n = 1 if inlist(act1n,2,3)
* Observations coded as "Refused" or "Don't know" were treated as missing cases
replace act1n = . if inlist(act1n,7,8)
gen act2n = ACT2
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to walk around your home or apartment?"
replace act2n = 0 if act2n==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace act2n = 1 if inlist(act2n,2,3)
* Observations coded as "Refused" or "Don't know" were treated as missing cases
replace act2n = . if inlist(act2n,7,8)
gen act3n = ACT3
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to dress (like putting on a shirt or shoes, buttoning and zipping)?"
replace act3n = 0 if act3n==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace act3n = 1 if inlist(act3n,2,3)
* Observations coded as "Refused" or "Don't know" were treated as missing cases
replace act3n = . if inlist(act3n,7,8)
gen act4n = ACT4
* Code as 0 if the participant responds "No help" to the question "At the present time, do you need help from another person to get in and out of a chair?"
replace act4n = 0 if act4n==1
* Code as 1 if the participant responds "Help" or "Unable to do"
replace act4n = 1 if inlist(act4n,2,3)
* Observations coded as "Refused" or "Don't know" were treated as missing cases
replace act4n = . if inlist(act4n,7,8)

*** Sum
* Generate a count of the number of ADL requiring personal assistance
gen essential = act1n + act2n + act3n + act4n
* Create a binary variable (fully independent versus dependent in one or more ADL)
gen essential_bi = essential
replace essential_bi = 1 if inlist(essential_bi,2,3,4)
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 87704 observations
* Save dataset with a new name
save monthly.dta
clear

* Use updated master dataset
use comprehensive_analyses.dta
* Keep interview dates of comprehensive assessments and other relevant variables
keep STUDYID interval intdateF2F 
* Reshape data into wide format for observations identified by participant ID and add interval as an identifying time period
reshape wide intdateF2F, i(STUDYID) j(interval)
* Generate a new variable called interval and assign the number 1 to each observation
generate interval = 1
* Save interview dates dataset with a new name
save wide_intdateF2F.dta
clear

* Use monthly dataset
use monthly.dta 
* Merge monthly dataset with interview dates dataset
merge m:1 STUDYID using wide_intdateF2F.dta, generate(merge_date)
* Keep if matched
keep if merge_date==3
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 87704 observations
* Overwrite dataset, by replacing the previously saved file
save monthly.dta, replace
clear 

* Import temporary interview dates 
import sas using "P:\projects\PEP\sas\OTHER Source pgm\f2fdates_306.sas7bdat"
* Change working directory
cd "P:\projects\PEP\OMalkowski\Active life expectancy"
* Rename StudyID variable to ensure consistency with monthly dataset
rename StudyID STUDYID
* Save temporary interview dates dataset with a new name
save wide_tmpdates.dta
clear 

* Use monthly dataset
use monthly.dta
* Merge monthly dataset with temporary interview dates dataset
merge m:1 STUDYID using wide_tmpdates.dta, generate(merge_date2)
* Keep if matched
keep if merge_date2==3
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 87704 observations
* Overwrite dataset, by replacing the previously saved file
save monthly.dta, replace

* Generate a variable that allows data from the comprehensive assessments to be merged with and carried forward to all monthly observations between consecutive comprehensive assessments
gen interval4 = 1 if intdate>=tmpdate0 & intdate<tmpdate18
replace interval4 = 2 if intdate>=tmpdate18 & intdate<tmpdate36
replace interval4 = 3 if intdate>=tmpdate36 & intdate<tmpdate54
replace interval4 = 4 if intdate>=tmpdate54 & intdate<tmpdate72
replace interval4 = 5 if intdate>=tmpdate72 & intdate<tmpdate90
replace interval4 = 6 if intdate>=tmpdate90 & intdate<tmpdate108
replace interval4 = 7 if intdate>=tmpdate108 & intdate<tmpdate126
replace interval4 = 8 if intdate>=tmpdate126 & intdate<tmpdate144
replace interval4 = 9 if intdate>=tmpdate144 & intdate<tmpdate162
replace interval4 = 10 if intdate>=tmpdate162 & intdate<tmpdate180
replace interval4 = 11 if intdate>=tmpdate180 & intdate<tmpdate198
replace interval4 = 12 if intdate>=tmpdate198 & intdate<tmpdate216
replace interval4 = 13 if intdate>=tmpdate216 & intdate<tmpdate234
replace interval4 = 14 if intdate>=tmpdate234 & intdate<tmpdate252
replace interval4 = 15 if intdate>=tmpdate252 & intdate<tmpdate270
replace interval4 = 16 if intdate>=tmpdate270 & intdate<tmpdate288
replace interval4 = 17 if intdate>=tmpdate288 & intdate<tmpdate306
replace interval4 = 18 if intdate>=tmpdate306 & intdate<.
* Two participants died before their first monthly interview, but took part in the baseline comprehensive assessment
replace interval4 = 1 if STUDYID==1523 & intbloc==1
replace interval4 = 1 if STUDYID==2409 & intbloc==1
* Overwrite dataset, by replacing the previously saved file
save monthly.dta, replace
clear

* Use updated master dataset
use comprehensive_analyses.dta
* Carryforward observations with respect to the time variable "interval" (i.e., from interval 7 to the follow-up comprehensive assessments) by participant ID, and replace values at interval 8 with values from interval 7
gen raw_ccsumbl2_cons = raw_ccsumbl2 if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward raw_ccsumbl2_cons, replace
replace raw_ccsumbl2 = raw_ccsumbl2_cons if interval==8
gen smoking_cons = smoking if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward smoking_cons, replace
replace smoking = smoking_cons if interval==8
gen low_pa_cons = low_pa if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward low_pa_cons, replace
replace low_pa = low_pa_cons if interval==8
gen obesity_cons = obesity if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward obesity_cons, replace
replace obesity = obesity_cons if interval==8
gen adldep_bi_cons = adldep_bi if interval==7
tsset STUDYID interval 
bysort STUDYID: carryforward adldep_bi_cons, replace
replace adldep_bi = adldep_bi_cons if interval==8
* Overwrite dataset, by replacing the previously saved file
save comprehensive_analyses.dta, replace
* Keep necessary variables from the comprehensive assessments
keep STUDYID interval edu_cons_bi inc_bimi adi_cons age_fix age_fix_dec sex_cons eth_bi raw_ccsumbl2 alc_cons smoking low_pa obesity adldep_bi DDate2 BDates
* Rename variable to ensure consistency with the monthly dataset
rename interval interval4
* Save comprehensive assessment variables dataset with a new name
save comprehensive_merge.dta
clear

* Use monthly dataset
use monthly.dta
* Merge monthly dataset with comprehensive assessment variables dataset
merge m:1 STUDYID interval4 using comprehensive_merge.dta, generate(merge_f2f)
* Keep all observations from the monthly dataset
keep if inlist(merge_f2f,1,3)
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 87704 observations
* Save dataset with a new name
save monthly_analysis.dta

* Time to death from monthly interview (i.e., date of death minus date of monthly interview rounded to the nearest integer) in months and years
gen timetodeath = (DDate-intdate)/(365/12)
replace timetodeath = round(timetodeath,1)
gen timetodeath_yr = timetodeath/12

* Time to death from baseline (i.e., date of death minus date of baseline comprehensive assessment) in months and years
gen timetodeath_bl2 = (DDate-intdateF2F1)/(365/12)
gen timetodeath_bl2_yr = timetodeath_bl2/12
* Calculate the median time to death from baseline
sum timetodeath_bl2_yr if intbloc==1,d
* Perform a Shapiro-Wilk test for normality
swilk timetodeath_bl2_yr if intbloc==1
* Calculate the interquartile range
tabstat timetodeath_bl2_yr if intbloc==1, statistics(iqr)

* Time to refusal from baseline (i.e., date of refusal minus date of baseline comprehensive assessment) in months
gen timebaserefusal = (daterefuse-intdateF2F1)/(365/12)
* Keep one observation per participant and limit observations to permanent refusers
replace timebaserefusal = . if intbloc!=1
replace timebaserefusal = . if permrefuser==0
* Calculate the median time to refusal from baseline
sum timebaserefusal,d 
* Perform a Shapiro-Wilk test for normality
swilk timebaserefusal
* Calculate the interquartile range
tabstat timebaserefusal, statistics(iqr)
* Overwrite dataset, by replacing the previously saved file
save monthly_analysis.dta, replace

* Keep necessary variables for discrete-time multistate modeling analyses
keep STUDYID interval edu_cons_bi inc_bimi adi_cons age_fix age_fix_dec sex_cons eth_bi raw_ccsumbl2 alc_cons smoking low_pa obesity adldep_bi DDate2 BDates intdate intbloc interval4 DDate Died essential_bi timetodeath timetodeath_yr timetodeath_bl2 timetodeath_bl2_yr timebaserefusal permrefuser daterefuse
* Assigns a number in ascending order to each row of observations
gen ascnr = _n
* Generate a variable that assigns the observation number (i.e., 1 for first data collection timepoint, 2 for second data collection timepoint) to each row by participant ID
bysort STUDYID(intdate): gen obsnr = _n
* Generate a variable that assigns the number of total observations to each row of data for a given participant
bysort STUDYID: gen obscount = _N
* Count total number of participants and observations
unique STUDYID 
* 754 individuals, 87704 observations 
* Save analysis dataset with a new name
save multistate.dta
clear

* Use updated master dataset
use comprehensive_analyses.dta 
* Keep baseline data only
keep if interval==1
* Keep relevant variables
keep STUDYID interval edu_cons_bi inc_bimi adi_cons age_fix age_fix_dec sex_cons eth_bi raw_ccsumbl2 alc_cons smoking low_pa obesity adldep_bi DDate2 BDates intdateF2F
* Generate a new variable called intbloc and assign the number 0 to each observation (as the baseline comprehensive assessment precedes the first block of monthly interviews)
gen intbloc=0
* Generate a new variable with the same name as the binary ADL variable in the monthly dataset and assign the number 0 to each observation (as all participants were nondisabled at baseline)
gen essential_bi=0
* Save baseline ADL dataset with a new name
save base_adl.dta
clear

* Use analysis dataset
use multistate.dta
* Merge monthly dataset with baseline ADL dataset
merge 1:1 STUDYID intbloc using base_adl.dta, generate(merge_adl)
* Count total number of participants and observations
unique STUDYID
* 754 individuals, 88458 observations
* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Declare a panel dataset with participant ID "STUDYID" and time variable "intbloc"
tsset STUDYID intbloc
* Generate a completely balanced dataset (i.e., all participants have a row for each intbloc)
tsfill, full
* Count total number of participants and observations
unique STUDYID 
* 754 individuals, 240526 obsevations
* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc

* Generate a variable duplicating the binary ADL variable
gen state = essential_bi
* Generate a variable duplicating any variable assessed during the comprehensive assessments with no missing data (in this case biological sex)
gen constant = sex_cons
* Generate a variable duplicating the binary, time-constant alcohol consumption variable to provide a reference for which participants were missing data on alcohol consumption at baseline
gen constant2 = alc_cons

* Create lagged versions of the following variables by participant ID
by STUDYID: gen obsnr_l = L.obsnr
by STUDYID: gen obscount_l = L.obscount
by STUDYID: gen Died_l = L.Died
by STUDYID: gen timetodeath_l = L.timetodeath
by STUDYID: gen permrefuser_l = L.permrefuser

* Code as dead if (1) the current state variable (fully independent versus dependent in one or more ADL) is blank, (2) the previous observation was the participant's final monthly interview, (3) the participant has since died, (4) and the participant's date of death is within two months of their final monthly interview (or the baseline comprehensive assessment for those who died before their first monthly interview)
replace state = 2 if state==. & obsnr_l==obscount_l & Died_l==1 & inlist(timetodeath_l,0,1)
tab permrefuser_l if state==. & obsnr_l==obscount_l & Died_l==1
tab timetodeath_l if state==. & obsnr_l==obscount_l & Died_l==1 & permrefuser_l==1
tab timetodeath_l if state==. & obsnr_l==obscount_l & Died_l==1 & permrefuser_l==0
replace state = 2 if state==. & obsnr_l==obscount_l & Died_l==1 & inlist(timetodeath_l,2)
tab STUDYID if state==. & obsnr_l==obscount_l & Died_l==1
tab STUDYID if state==. & obsnr_l==obscount_l & Died_l==1 & permrefuser_l==0
tab STUDYID if state==1 & obsnr_l==obscount_l & Died_l==1
replace state = 2 if state==. & obsnr_l==186 & obscount_l==187 & L.Died==1 & inlist(timetodeath_l,0,1)
replace state = 2 if intbloc==1 & STUDYID==2409
replace state = 2 if intbloc==1 & STUDYID==1523

* Generate a new variable duplicating the date of birth variable at the time of each participant's first monthly interview
gen BDates_cons = BDates if obsnr==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "intbloc"
tsset STUDYID intbloc
* Carryforward observations with respect to the time variable "intbloc" (i.e., from the first monthly interview to the follow-up monthly interviews) by participant ID
bysort STUDYID: carryforward BDates_cons, replace
* Replace any missing values with the participant's date of birth
replace BDates_cons=BDates if BDates_cons==.

* Generate a new variable duplicating the date of death variable at the time of each participant's first monthly interview
gen DDates_cons = DDate2 if obsnr==1
* Declare a panel dataset with participant ID "STUDYID" and time variable "intbloc"
tsset STUDYID intbloc
* Carryforward observations with respect to the time variable "intbloc" (i.e., from the first monthly interview to the follow-up monthly interviews) by participant ID
bysort STUDYID: carryforward DDates_cons, replace
* Replace any missing values with the participant's date of death
replace DDates_cons=DDate2 if DDates_cons==.

* Age (months)
format BDates_cons %td
format intdate %td
gen age_months_dec = datediff_frac(BDates_cons,intdate,"month")
gen age_months = floor(age_months_dec)
replace age_fix_dec = age_fix_dec*12
replace age_fix_dec = floor(age_fix_dec)
replace age_months = age_fix_dec if intbloc==0
format DDates_cons %td
gen age_months_death = datediff_frac(BDates_cons,DDates_cons,"month")
gen age_months_death_fl = floor(age_months_death)
replace age_months = age_months_death_fl if state==2

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc 
* Generate a new age in months variable (i.e., calculated at baseline and incremented by one month at each subsequent telephone interview) to be used in the discrete-time multistate modeling analyses, as we assume that longitudinal data are observed in regular intervals
by STUDYID: gen newage = age_months[1] + _n-1

* Create a new variable replacing the numeric state values with character strings
gen state2 = "Nondisabled" if state==0
replace state2 = "Disabled" if state==1
replace state2 = "Dead" if state==2

* For the following time-constant variables, replace any missing values with the corresponding (time-constant) value
bysort STUDYID(intbloc): replace edu_cons_bi = edu_cons_bi[_n-1] if missing(edu_cons_bi)
bysort STUDYID(intbloc): replace inc_bimi = inc_bimi[_n-1] if missing(inc_bimi)
bysort STUDYID(intbloc): replace adi_cons = adi_cons[_n-1] if missing(adi_cons)
bysort STUDYID(intbloc): replace sex_cons = sex_cons[_n-1] if missing(sex_cons)
bysort STUDYID(intbloc): replace eth_bi = eth_bi[_n-1] if missing(eth_bi)
bysort STUDYID(intbloc): replace alc_cons = alc_cons[_n-1] if missing(alc_cons)

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Generate a new variable duplicating the smoking variable
by STUDYID: gen last_nm_smok = smoking
* For a given participant, replace with the value from the previous row of data (from the same participant) if smoking data were missing for the current row
by STUDYID: replace last_nm_smok = last_nm_smok[_n-1] if missing(last_nm_smok)
* Replace with a missing value if smoking data were missing at the corresponding comprehensive assessment (i.e., at the comprehensive assessment preceding the respective monthly interview)
replace last_nm_smok = . if constant!=. & smoking==.

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Generate a new variable duplicating the low physical activity variable
by STUDYID: gen last_nm_pa = low_pa
* For a given participant, replace with the value from the previous row of data (from the same participant) if low physical activity data were missing for the current row
by STUDYID: replace last_nm_pa = last_nm_pa[_n-1] if missing(last_nm_pa)
* Replace with a missing value if low physical activity data were missing at the corresponding comprehensive assessment (i.e., at the comprehensive assessment preceding the respective monthly interview)
replace last_nm_pa = . if constant!=. & low_pa==.

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Generate a new variable duplicating the obesity variable
by STUDYID: gen last_nm_ob = obesity
* For a given participant, replace with the value from the previous row of data (from the same participant) if obesity data were missing for the current row
by STUDYID: replace last_nm_ob = last_nm_ob[_n-1] if missing(last_nm_ob)
* Replace with a missing value if obesity data were missing at the corresponding comprehensive assessment (i.e., at the comprehensive assessment preceding the respective monthly interview)
replace last_nm_ob = . if constant!=. & obesity==.

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Generate a new variable duplicating the number of chronic conditions variable
by STUDYID: gen last_nm_cc = raw_ccsumbl2
* For a given participant, replace with the value from the previous row of data (from the same participant) if data on the number of chronic conditions were missing for the current row
by STUDYID: replace last_nm_cc = last_nm_cc[_n-1] if missing(last_nm_cc)
* Replace with a missing value if data on the number of chronic conditions were missing at the corresponding comprehensive assessment (i.e., at the comprehensive assessment preceding the respective monthly interview)
replace last_nm_cc = . if constant!=. & raw_ccsumbl2==.

* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc
* Generate a new variable duplicating the age in years variable
by STUDYID: gen last_nm_age = age_fix
* For a given participant, replace with the value from the previous row of data (from the same participant) if age in years data were missing for the current row
by STUDYID: replace last_nm_age = last_nm_age[_n-1] if missing(last_nm_age)
* Replace with a missing value if age in years data were missing at the corresponding comprehensive assessment (i.e., at the comprehensive assessment preceding the respective monthly interview)
replace last_nm_age = . if constant!=. & age_fix==.

* Compare the age in months variables
gen ageminus = newage-age_months
tab ageminus if state!=.
tab ageminus if state!=. & L.state!=.

* Calculate the median time (and interquartile range) between monthly interviews in days
gen interview = intdate 
replace interview = intdateF2F if intbloc==0
replace interview = DDate if inlist(STUDYID,1523,2409) & intbloc==1
bysort STUDYID(intbloc): gen days_diff = interview-interview[_n-1]
sum days_diff,d
tabstat days_diff, statistics(iqr)
* Save dataset with a new name
save intermediate.dta

* Keep relevant variables
keep STUDYID intbloc age_months newage state last_nm_age last_nm_cc last_nm_ob last_nm_pa last_nm_smok alc_cons eth_bi sex_cons adi_cons inc_bimi edu_cons_bi state2 permrefuser 
* Sort by participant ID and intbloc (lowest to highest)
sort STUDYID intbloc 
* Increment the age in months variable by one month for each subsequent row containing missing data
local missing_count = 1 
while `missing_count' > 0 {
	replace age_months = age_months[_n-1] + 1 if missing(age_months)
	count if missing(age_months)
	local missing_count = r(N)
}
* Generate time-constant versions of the following time-varying variables for use in the baseline-only discrete-time multistate modeling analyses
gen cc_cons = last_nm_cc if intbloc==0
tsset STUDYID intbloc
bysort STUDYID: carryforward cc_cons, replace
gen sm_cons = last_nm_smok if intbloc==0
tsset STUDYID intbloc
bysort STUDYID: carryforward sm_cons, replace
gen pa_cons = last_nm_pa if intbloc==0
tsset STUDYID intbloc
bysort STUDYID: carryforward pa_cons, replace
gen ob_cons = last_nm_ob if intbloc==0
tsset STUDYID intbloc
bysort STUDYID: carryforward ob_cons, replace
* Save dataset with a new name
save intermediate2.dta

* Amount of missing data 
gen has_val_alc = !missing(alc_cons)
bysort STUDYID: egen ever_had_alc = max(has_val_alc)
list STUDYID if ever_had_alc==0
gen has_val_smo = !missing(last_nm_smok)
bysort STUDYID: egen ever_had_smo = max(has_val_smo)
list STUDYID if ever_had_smo==0
gen has_val_pa = !missing(last_nm_pa)
bysort STUDYID: egen ever_had_pa = max(has_val_pa)
list STUDYID if ever_had_pa==0
gen has_val_ob = !missing(last_nm_ob)
bysort STUDYID: egen ever_had_ob = max(has_val_ob)
list STUDYID if ever_had_ob==0

* Total sample size after transitions starting or ending in a missing value are dropped
unique STUDYID if L.state!=. & state!=.
* Total sample size after transitions with incomplete data on any of the lifestyle risk factors (for the adjusted analyses) are dropped
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons!=. & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.edu_cons_bi!=.
* Sample size for adjusted discrete-time multistate modeling analyses among men
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.edu_cons_bi!=.
* 266 individuals, 27943 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.inc_bimi!=.
* 266 individuals, 27943 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.adi_cons!=.
* 266 individuals, 27943 observations

* Sample size for adjusted discrete-time multistate modeling analyses among women
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.edu_cons_bi!=.
* 486 individuals, 58307 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.inc_bimi!=.
* 486 individuals, 58307 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.adi_cons!=.
* 486 individuals, 58307 observations

* Sample size for baseline-only discrete-time multistate modeling analyses among men
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.edu_cons_bi!=.
* 266 individuals, 28092 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.inc_bimi!=.
* 266 individuals, 28092 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==0 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.adi_cons!=.
* 266 individuals, 28092 observations

* Sample size for baseline-only discrete-time multistate modeling analyses among women
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.edu_cons_bi!=.
* 486 individuals, 59221 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.inc_bimi!=.
* 486 individuals, 59221 observations
unique STUDYID if L.state!=. & state!=. & L.newage!=. & L.sex_cons==1 & L.eth_bi!=. & L.alc_cons!=. & L.sm_cons!=. & L.pa_cons!=. & L.ob_cons!=. & L.cc_cons!=. & L.adi_cons!=.
* 486 individuals, 59221 observations

* Compare the age in months variables
gen ageminus = age_months-newage
tab ageminus if L.state!=. & state!=. & L.newage!=. & L.sex_cons!=. & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.adi_cons!=.
sort STUDYID intbloc
gen gap = D.age_months
tab gap if L.state!=. & state!=. & L.newage!=. & L.sex_cons!=. & L.eth_bi!=. & L.alc_cons!=. & L.last_nm_smok!=. & L.last_nm_pa!=. & L.last_nm_ob!=. & L.last_nm_cc!=. & L.adi_cons!=.
* Overwrite dataset, by replacing the previously saved file
save intermediate2.dta, replace

* Baseline characteristics of participants by sex and/or indicator of SES (Table 1)
keep if intbloc==0
bysort sex_cons: tab eth_bi 
bysort sex_cons: tab alc_cons 
bysort sex_cons: tab last_nm_smok 
bysort sex_cons: tab last_nm_pa
bysort sex_cons: tab last_nm_ob 
bysort sex_cons: sum last_nm_cc
bysort sex_cons: sum last_nm_age

bysort sex_cons: tab edu_cons_bi sex_cons 
bysort sex_cons: tab edu_cons_bi eth_bi 
bysort sex_cons: tab edu_cons_bi alc_cons 
bysort sex_cons: tab edu_cons_bi last_nm_smok 
bysort sex_cons: tab edu_cons_bi last_nm_pa
bysort sex_cons: tab edu_cons_bi last_nm_ob 

bysort sex_cons: tab inc_bimi sex_cons 
bysort sex_cons: tab inc_bimi eth_bi 
bysort sex_cons: tab inc_bimi alc_cons 
bysort sex_cons: tab inc_bimi last_nm_smok 
bysort sex_cons: tab inc_bimi last_nm_pa
bysort sex_cons: tab inc_bimi last_nm_ob 

bysort sex_cons: tab adi_cons sex_cons 
bysort sex_cons: tab adi_cons eth_bi 
bysort sex_cons: tab adi_cons alc_cons 
bysort sex_cons: tab adi_cons last_nm_smok 
bysort sex_cons: tab adi_cons last_nm_pa
bysort sex_cons: tab adi_cons last_nm_ob 

bysort sex_cons: sum last_nm_cc if edu_cons_bi==0
bysort sex_cons: sum last_nm_cc if edu_cons_bi==1
bysort sex_cons: sum last_nm_cc if inc_bimi==0
bysort sex_cons: sum last_nm_cc if inc_bimi==1
bysort sex_cons: sum last_nm_cc if adi_cons==0
bysort sex_cons: sum last_nm_cc if adi_cons==1

bysort sex_cons: sum last_nm_age if edu_cons_bi==0
bysort sex_cons: sum last_nm_age if edu_cons_bi==1
bysort sex_cons: sum last_nm_age if inc_bimi==0
bysort sex_cons: sum last_nm_age if inc_bimi==1
bysort sex_cons: sum last_nm_age if adi_cons==0
bysort sex_cons: sum last_nm_age if adi_cons==1
clear

use intermediate2.dta
* Baseline characteristics of participants who remained in, versus withdrew from, the study (Supplementary Table S2)
bysort STUDYID(intbloc): replace permrefuser = permrefuser[_n+1] if permrefuser==.
keep if intbloc==0
tab permrefuser sex_cons, chi2
tab permrefuser eth_bi, chi2
tab permrefuser eth_bi, exact
tab permrefuser edu_cons_bi, chi2
tab permrefuser inc_bimi, chi2
tab permrefuser adi_cons, chi2
tab permrefuser alc_cons, chi2
tab permrefuser last_nm_smok, chi2
tab permrefuser last_nm_pa, chi2
tab permrefuser last_nm_ob, chi2 

swilk last_nm_age if permrefuser==0
swilk last_nm_age if permrefuser==1
swilk last_nm_cc if permrefuser==0
swilk last_nm_cc if permrefuser==1
bysort permrefuser: sum last_nm_age
bysort permrefuser: sum last_nm_cc
ttest last_nm_age, by(permrefuser) welch
ttest last_nm_cc, by(permrefuser) welch
clear

* Baseline characteristics of participants by sex and/or indicator of SES (Table 1), complete breakdown of race or ethnicity
* Use updated master dataset
use comprehensive_analyses.dta 
keep if interval==1
bysort sex_cons: tab eth_cons
bysort sex_cons: tab edu_cons_bi eth_cons 
bysort sex_cons: tab inc_bimi eth_cons
bysort sex_cons: tab adi_cons eth_cons
clear

* Run discrete-time multistate modeling code from relevant R scripts in RStudio