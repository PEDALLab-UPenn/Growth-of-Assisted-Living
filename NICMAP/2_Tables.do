
//Step 6. Produce Tables for Paper
	table1 , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/Table1_R&R_REPLICATION07252022.xls", replace)
	
	table1 if censusregion == "Midwest" , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/RegionalDiff_0_R&R_REPLICATION07252022.xls", replace)
	
	table1 if censusregion == "West" , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/RegionalDiff_1_R&R_REPLICATION07252022.xls", replace)

	table1 if censusregion == "South" , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/RegionalDiff_2_R&R_REPLICATION07252022.xls", replace)

	table1 if censusregion == "Northeast", vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/RegionalDiff_3_R&R_REPLICATION07252022.xls", replace)


	table1 if statecategory == 0 , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/StateMedicaidClassifications_0_R&R_REPLICATION07252022.xls", replace)

	table1 if statecategory == 1 , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/StateMedicaidClassifications_1_R&R_REPLICATION07252022.xls", replace)

	table1 if statecategory == 2 , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/StateMedicaidClassifications_2_R&R_REPLICATION07252022.xls", replace)

	table1 if statecategory == 3 , vars( ///
	classification cat \ ///
	openinventory contn \ ///
	profit contn \ ///
	chain contn  \ ///
	rent contn \ ///
	adjbeds contn \ ///
	yrly_snfbeds_adj contn ///
	) by(year) format(%10.2f) cf(%10.2f) saving("$output/StateMedicaidClassifications_3_R&R_REPLICATION07252022.xls", replace)
