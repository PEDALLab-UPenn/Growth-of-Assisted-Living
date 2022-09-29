
//Step 7. Create Files to calculate % change for graphs
use "$output/AnalyticDataset_R&R_REPLICATION.dta", clear
	keep cbsacode year adjbeds yrly_snfbeds_adj censusregion metro
	duplicates drop
	tab cbsacode year, m
	tab metro censusregion if cbsacode == "17140" | cbsacode == "31140" | cbsacode == "37980" | cbsacode == "49660"
	replace censusregion = "Midwest" if cbsacode == "17140"
	replace censusregion = "Midwest" if cbsacode == "31140"
	replace censusregion = "Northeast" if cbsacode == "37980"
	replace censusregion = "Midwest" if cbsacode == "49660"
	duplicates drop
	keep if year == 2015 | year == 2019
	reshape wide adjbeds yrly_snfbeds_adj, i(cbsacode) j (year)
	gen pcnt_change_adjbeds = (adjbeds2019 - adjbeds2015) / adjbeds2015 * 100
	gen pcnt_change_snfbeds = (yrly_snfbeds_adj2019 - yrly_snfbeds_adj2015) / yrly_snfbeds_adj2015 * 100
	bysort censusregion: gen pcnt_change_adjbeds_reg = (adjbeds2019 - adjbeds2015) / adjbeds2015 * 100
	bysort censusregion: gen pcnt_change_snfbeds_reg = (yrly_snfbeds_adj2019 - yrly_snfbeds_adj2015) / yrly_snfbeds_adj2015 * 100
	sum pcnt_change_adjbeds_reg pcnt_change_snfbeds_reg
	tab censusregion, sum (pcnt_change_adjbeds_reg)
	tab censusregion, sum (pcnt_change_snfbeds_reg)
