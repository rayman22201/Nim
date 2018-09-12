import pegs

let logPeg = peg"""
    log <- {datetime} '-' {clocktime} \s bracketcode \s 'trace:' \s {logcode} \s clientname \s {rest}
    datetime <- \d#4 '-' \d#2 '-' \d#2 'T' \d \d ':' \d#2 ':' \d#2 '.' \d#7
    clocktime <- \d#2 ':' \d#2 ## this is a comment! yay! mooo
    bracketCode <- '[' {\d+} ']'
    logcode <- \d#2 '-' \d+
    clientname <- 'client[' {@} ']'
    rest <- .+ """

let teststr = """2018-07-13T04:59:09.3424280-05:00 [343] trace: 12-0001 client[DEVAMSR1:action_do_publish:Alerts:nvfix:0x24965a0] publish command received: {"c":"delta_publish","t":"Alerts","o":"update_only"}20015=CLEARED11=PS06O605296-1337=420221543339=041=52=150273939832258=Open60=1502739398322DownstreamSessionStatus=SelfHelp=90015=90016=SystemType=SOR20012=Prolonged Pending Ack20010=PPA:SOR:Child:1034728350879685463020013=CRITICAL20016=SystemEXBAlertCreateTime=20017=20014=OpenSourceInternalID=10347283508796854630"""

if testStr =~ logPeg:
  echo "match"
  echo matches
