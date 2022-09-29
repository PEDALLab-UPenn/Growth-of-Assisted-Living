clear
set seed 50416

global origdata "NICMAP"
global dofiles "Do Files"
global output "Output"

//Part 1. Construct Data Set
do "$dofiles/1_DataSet_Construction.do"

//Part 2. Produce Tables
do "$dofiles/2_Tables.do"

//Part 3. Produce Figure
do "$dofiles/3_Figure.do"
