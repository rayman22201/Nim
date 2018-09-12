import re

let htm = """<P class=MsoNormal 
style="MARGIN-BOTTOM: 0pt; LINE-HEIGHT: normal; TEXT-AUTOSPACE: ; mso-pagination: none; mso-layout-grid-align: none"><B><SPAN 
lang=de 
style='FONT-SIZE: 33pt; FONT-FAMILY: "TimesNewRoman,Bold","serif"; mso-bidi-font-family: "TimesNewRoman,Bold"; mso-ansi-language: #0007'>Teil 
II<o:p></o:p></SPAN></B></P>"""

var matchesSeq : seq[string] = @[]
echo match(htm, re("""\<P.*\#0007\'>(.*)\<\/P>""", {reMultiLine, reDotAll, reExtended}), matchesSeq)
echo "seq: ", matchesSeq

var matchesArr : array[20, string]
echo match(htm, re("""\<P.*\#0007\'>(.*)\<\/P>""", {reMultiLine, reDotAll, reExtended}), matchesArr)
echo "array: ", matchesArr

if htm =~ re("""\<P.*\#0007\'>(.*)\<\/P>""", {reMultiLine, reDotAll, reExtended}):
  echo "template (uses array): ", matches

