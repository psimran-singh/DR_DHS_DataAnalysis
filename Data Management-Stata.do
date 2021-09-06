use "C:\Users\Simran\Desktop\Dominican Republic\Household Member's Recode\DRPR61FL",clear
keep hv115 hv025 hhid hvidx hv009 hv010 hv011 hv012 hv013 hv014 hv015 hv217 hv218 hv219 hv220 hv244 hv245 hv246 hv247 hv270 hv271 sh36 sh40 sh54 sh55a sh55b hv101 hv102 hv103 hv104 hv105 hv106 hv107 hv108 hv109 hv111 hv112 hv113 hv114 hv115 hv116 hv121 hv122 hv123 hv124 hv125 hv126 hv127 hv128 hv129 sheduc sh23 sh24 sh24a sh24b sh24c sh24d sh24e sh24f sh24g sh24h sh24x sh25 sh26 sh28 sh29a sh29b sh29c sh29d sh29e sh29f sh29g sh29h sh29i sh29j sh29k sh29l sh29m sh29n sh29x sh30a sh30b sh31 sh31a sh33a sh33b sh34 sh34b sml07i sml07f ha0 ha1 ha50 ha54 ha60 ha65 ha66 ha67 ha68 hc61 hc62 hc64 hc68 hb65 hb66 hb67 hb68 sgresult sgweight singrth singrthp singrhi svivig1 svivig2 svalpro squintip sallinci sg101 sg103 sg104 sg105 sg106 sg107 sg108 sg109 sg110 sg111 sg112a sg112b sg113a sg113b sg113c sg113d sg114a sg114b sg115 sg116a sg116b sg116c sg116d sg117a sg117b sg118a sg118b sg119a sg119b sg120a sg120b singresoo singresoe sregaliap sbonifica sifuente1 sifuente2 sifuente3 sifuente4 singresotp singresoip singresoib sgastoti singresoipa hv024
ssc install outreg2
set matsize 5000

//Create region dummy variables
gen region0=0
replace region0=1 if hv024==0
gen region1=0
replace region1=1 if hv024==1
gen region2=0
replace region2=1 if hv024==2
gen region3=0
replace region3=1 if hv024==3
gen region4=0
replace region4=1 if hv024==4
gen region5=0
replace region5=1 if hv024==5
gen region6=0
replace region6=1 if hv024==6
gen region7=0
replace region7=1 if hv024==7
gen region8=0
replace region8=1 if hv024==8
gen rural=0
replace rural=1 if hv025==2

//Create female head of household dummy variable
gen femalehead=hv219==2

//Recode marital status of head of household variables
*Married
gen marriage=1 
replace marriage=0 if hv115!=1
gen head=hv101==1
gen hhpmarried=1 if head==1 & marriage==1
by hhid, sort: egen hhmarried=sum(hhpmarried)
*Together
gen together=1
replace together=0 if hv115!=2
gen hhptogether=1 if head==1 & together==1
by hhid, sort: egen hhtogether=sum(hhptogether)

//Recode education of head of household variable
gen sh25_1=sh25
replace sh25_1=4 if sh25==4 | sh25==5 | sh25==6 | sh25==7
drop if sh25==8
gen hhpprekeduc=0
replace hhpprekeduc=1 if head==1 & sh25_1==1
gen hhpprimeduc=0
replace hhpprimeduc=1 if head==1 & sh25_1==2
gen hhpsecoeduc=0
replace hhpsecoeduc=1 if head==1 & sh25_1==3
gen hhphigheduc=0
replace hhphigheduc=1 if head==1 & sh25_1==4

by hhid, sort: egen hhprekeduc=sum(hhpprekeduc)
by hhid, sort: egen hhprimeeduc=sum(hhpprimeduc)
by hhid, sort: egen hhsecoeduc=sum(hhpsecoeduc)
by hhid, sort: egen hhhigheduc=sum(hhphigheduc)


//Recode child of head variable
gen childofhead=hv101==3
replace childofhead=0 if childofhead==.

//Recode individual's gender variable
gen female=hv104==2
replace female=0 if female==.

//Recode older sibling variable
gen childage=0
replace childage=hv105 if childofhead==1
by hhid, sort: egen zage=max(childage) if hv104==1
gen oldestmale=1 if hv104==1 & childage==zage
replace oldestmale=0 if oldestmale==.
gen oldermalesib=1 if oldestmale==0
replace oldermalesib=0 if oldermalesib==.

//Recode birth order
by hhid, sort: egen birthorder=rank(childage), field

//Create female head-marital status interaction terms
gen FemMarHH=femalehead*hhmarried
gen FemTogHH=femalehead*hhtogether

//Create female head-female child interaction terms
gen FemHeadFem=femalehead*female

//Restrict the Data Set
*Only sons/daughters of head of household
keep if childofhead==1
*Only children aged 6-14
keep if hv105>5 & hv105<15
*Get rid of missing values for child's educ
keep if hv108<90


//Preliminary Regression
*Main Independent Variable
//hv108: education completed in single years
*Main Dependent Variable
//femalehead: household head is female
*Individual's Controls
//female: individual is female
//hv105: age of individual
//oldermalesib: individual has older male sibling
//birthorder: birth order of the individual
*Household Controls
//hv220: age of head of household
//hv009: number of household members
//hv271: wealth index score
//hhmarried: individual's head of household is married
//hhtogether: individual's head of household is cohabitating with partner
//hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc: education completed by head of household in single years
//region1-region8: region dummy variables
*Interaction Terms
//FemMarTogHH: interaction term of marital status variable and female-headship variable

quietly su hv108 femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarHH FemTogHH rural region1 region2 region3 region4 region5 region6 region7 region8
quietly outreg2 using "C:\Users\Simran\Desktop\Outreg\PrelimSum.doc", replace sum(log) label keep(hv108 birthorder femalehead female hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarHH FemTogHH FemHeadFem rural region1 region2 region3 region4 region5 region6 region7 region8)

quietly reg hv108 femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc rural region1 region2 region3 region4 region5 region6 region7 region8, robust
estimate store B
outreg2[B] using "C:\Users\Simran\Desktop\Outreg\PrelimReg.doc", replace ctitle(Education Completed in Single Years [1]) label sortvar(femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarTogHH rural region1 region2 region3 region4 region5 region6 region7 region8)

quietly reg hv108 femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarHH FemTogHH rural region1 region2 region3 region4 region5 region6 region7 region8, robust
estimate store A
outreg2[A] using "C:\Users\Simran\Desktop\Outreg\PrelimReg.doc", append ctitle(Education Completed in Single Years [2]) label sortvar(femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarTogHH rural region1 region2 region3 region4 region5 region6 region7 region8)


//Secondary Regression
*Same regression as above with additional interaction term
//FemHeadFem: interaction term of female-headship variable and child female variable

reg hv108 femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarHH FemTogHH FemHeadFem rural region1 region2 region3 region4 region5 region6 region7 region8, robust
estimate store C
outreg2[C] using "C:\Users\Simran\Desktop\Outreg\PrelimReg.doc", append ctitle(Education Completed in Single Years [3]) label sortvar(femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarTogHH FemHeadFem rural region1 region2 region3 region4 region5 region6 region7 region8)

//Third Regression
areg hv108 femalehead female birthorder hv220 hv105 hv009 hv271 hhmarried hhtogether oldermalesib hhprekeduc hhprimeeduc hhsecoeduc hhhigheduc FemMarHH FemTogHH FemHeadFem rural, absorb(hv024) robust
