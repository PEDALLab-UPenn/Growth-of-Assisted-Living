
 //Step 1. Combine Segment Files from 2014-2019
import excel "$origdata/Property Segment Level Inventory Data 2Q2020.xlsx", sheet("Primary") cellrange(A2:E755355) firstrow  case(lower) clear 
save "$output/SegLevInv_Primary.dta", replace

import excel "$origdata/Property Segment Level Inventory Data 2Q2020.xlsx", sheet("Secondary") cellrange(A2:E392569) firstrow case(lower) clear
save "$output/SegLevInv_Secondary.dta", replace

import excel "$origdata/Property Segment Level Inventory Data 2Q2020.xlsx", sheet("Additional") cellrange(A2:E30183) firstrow case(lower) clear
save "$output/SegLevInv_Additional.dta", replace

use "$output/SegLevInv_Primary.dta", clear
	append using "$output/SegLevInv_Secondary.dta"  ///
		 "$output/SegLevInv_Additional.dta"
	drop if propertyid == "" | propertyid == "© 2020 National Investment Center for Seniors Housing & Care, Inc. (NIC). All rights reserved. Data believed to be accurate but not guaranteed; subject to future revision." | propertyid == "This report is a part of the NIC MAP® Data Service (NIC MAP). Distribution of this report or any part of this report without prior written consent or license by NIC is strictly prohibited." | propertyid == "Subject to the NIC Terms of Use. For license information please contact NIC at 410-267-0504."
save "$output/SegLevInv.dta", replace  

//Step 2. Prepare Property Info Inventory       
import excel "/origdata/NICMAP/2020/NICMAP_Property_Inventory_2Q2020.xlsx", cellrange(A2:R16231) firstrow clear
	rename *, lower
	duplicates tag propertyid , generate(trouble)
	tab trouble, m
	tab propertystatus, m
save "$output/PropInfo.dta", replace


//Step 3. Medicaid Reimbursement State Categories

import excel "$output/ALF_states_Medicaid.xlsx", sheet("Sheet1") cellrange(A1:C45) firstrow clear
	sort state
	*replace statename = "West Virginia" in 45
	*replace statecategory = 0 in 45
	*replace state = "WV" in 45
save "$output/ALFMedicaidStates_Static.dta", replace


//Step 4. Prepare Property Traits over time 
import excel "/origdata/NICMAP/2020/Property Traits Across Time 2Q2020.xlsx", sheet("Sheet1") cellrange(A2:L784906) firstrow clear case(lower)
	drop if propertyid == "" | propertyid == "© 2020 National Investment Center for Seniors Housing & Care, Inc. (NIC). All rights reserved. Data believed to be accurate but not guaranteed; subject to future revision." | propertyid == "This report is a part of the NIC MAP® Data Service (NIC MAP). Distribution of this report or any part of this report without prior written consent or license by NIC is strictly prohibited." | propertyid == "Subject to the NIC Terms of Use. For license information please contact NIC at 410-267-0504."
save "$output/PropTraits.dta", replace

//Step 5. Combine Files to Create Panel of Facilities
use  "$output/PropTraits.dta", clear
	//Merge in Segement Level Invetory
	merge 1:m propertyid quarter using "$output/SegLevInv.dta"
	drop _merge
	destring propertyid, gen(propertyid2)
	rename propertyid propertyid_char
	rename propertyid2 propertyid

	//Merge in Property Info
	merge m:1 propertyid using "$output/PropInfo.dta"
	keep if _merge == 3
	drop _merge
	

	//Merge in Medicaid States Categories   
	merge m:1 state using "$output/ALFMedicaidStates_Static.dta"
	tab state _merge
	keep if  _merge == 3
	drop _merge

	
	//Create Year and Quarter Variables and Restrict Sample to be for CBSAs observed for Years 2015-2019 
	//and use 1st quarter only 
	//with property construction status as expansion or open 
	gen year = substr(quarter, 3, 4)
	gen quarterofyr = substr(quarter, 1, 1)
	drop quarter
	destring year , replace
	destring quarterofyr, gen(quarter)
	gen t = 1
	bysort cbsacode: egen firstyrobs = min(year)
	tab firstyrobs
	keep if year > 2014 & year < 2020
	keep if quarter == 1 
	keep if propertyconstructionstatus == "Expansion" | propertyconstructionstatus == "Open"
	tab year quarter, m

	//Merge in CBSA Level Pop estimates and SNF estimates
	merge m:1 cbsacode year using "$output/PopEstimates65+.dta"
	tab year _merge

	keep if _merge == 3
	drop _merge

	//Designate Properties as  NC, AL, MC, or IL
	gen num_seg = 1 if propertytype == "Majority NC" & segment == "Nursing Care"
	replace num_seg = 100 if propertytype == "Majority NC" & segment == "Memory Care"
	replace num_seg = 10000 if propertytype == "Majority NC" & segment == "Independent Living" 
	replace num_seg = 10000 if propertytype == "Majority NC" & segment == "Assisted Living"
	replace num_seg = 10000 if propertytype != "Majority NC"
	bysort propertyid year : egen flag_nh = sum(num_seg)
	tab flag_nh, m
	gen todrop = 0
	replace todrop = 1 if flag_nh < 10000
	tab todrop
	drop if todrop == 1
	gen num_al_seg = 1 if propertytype == "Majority AL" & segment == "Nursing Care"
	replace num_al_seg = 0 if propertytype == "Majority AL" & segment == "Memory Care"
	replace num_al_seg = 0 if propertytype == "Majority AL" & segment == "Independent Living" 
	replace num_al_seg = 0 if propertytype == "Majority AL" & segment == "Assisted Living"
	replace num_al_seg = 0 if propertytype != "Majority AL"
	bysort propertyid year : egen flag_al = sum(num_al_seg)
	tab flag_al, m
	gen num_il_seg = 1 if propertytype == "Majority IL" & segment == "Nursing Care"
	replace num_il_seg = 0 if propertytype == "Majority IL" & segment == "Memory Care"
	replace num_il_seg = 0 if propertytype == "Majority IL" & segment == "Independent Living" 
	replace num_il_seg = 0 if propertytype == "Majority IL" & segment == "Assisted Living"
	replace num_il_seg = 0 if propertytype != "Majority IL"
	bysort propertyid year : egen flag_il = sum(num_il_seg)
	tab flag_il, m
	bysort propertyid year: gen classification = propertytype if todrop == 0
	bysort propertyid year: replace classification = "CCRC" if propertytype == "Majority NC" &  todrop == 0
	bysort propertyid year: replace classification = "CCRC" if propertytype == "Majority AL" & flag_al > 0 & todrop == 0
	bysort propertyid year: replace classification = "CCRC" if propertytype == "Majority IL" & flag_il > 0 & todrop == 0
	drop segment* num_seg num_al_seg num_il_seg
	duplicates drop
	duplicates tag propertyid year, generate(trouble2)
	tab trouble2 // Good no issues.
	tab classification year, m
	        
	//Create Facility Characteristics of Interest
	gen profit = 0
	replace profit = 1 if profitstatus == "Profit"
	rename chain chain_original
	gen chain = 0
	replace chain = 1 if chain_original != "Single"
	tab chain_original chain, m
	gen rent = 0
	replace rent = 1 if primarypaymentmethod == "Rent"
	tab primarypaymentmethod rent, m
	tab year, sum(openinventory)
	gen censusregion = "West" if region == "Pacific" | region == "Mountain" | region == "Southwest"
	replace censusregion = "Midwest" if region == "West North Central" | region == "East North Central"
	replace censusregion = "South" if region == "Southeast" | region == "Mid-Atlantic"
	replace censusregion = "Northeast" if region == "Northeast" 
	tab region censusregion, m

	//Calculate number of beds per MSA and per capita
	bysort cbsacode year: egen totalbedsMSA = sum(openinventory) 
	bysort cbsacode year: gen adjbeds = totalbedsMSA / yrly_cbsa_pop * 10000
	tab year, sum(adjbeds)
	
	tab year classification
	bysort censusregion: tab year, sum(adjbeds) 
	bysort censusregion: tab year classification
	
	tab metro year , m 

save "$output/AnalyticDataset_R&R_REPLICATION.dta", replace
	
