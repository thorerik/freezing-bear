# Check raid status on HP machines
hpacucli ctrl all show  
hpacucli ctrl slot=0 pd all show  
hpacucli ctrl slot=0 show detail  
hpacucli ctrl slot=0 physicaldrive 1I:1:2 show detail  