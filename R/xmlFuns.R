# These are functions to read the OCR'ed text from the library of congress
# files.
#
library(XML)

getLines = 
function(doc)
{
   if(is.character(doc))
      doc = htmlParse(doc)

   xpathSApply(doc, "//textblock", processBlock)# , namespaces = "x")
}

processBlock =
function(node)
{
  sapply(node[ names(node) == "textline"], processTextLine)
}

processTextLine =
function(node, collapse = "")
{
   x = xmlSApply(node, function(x) if(xmlName(x) == "string") xmlGetAttr(x, "content") else " ")
   if(length(collapse) && !is.na(collapse))
       paste(x, collapse = collapse)
   else
       x
}
   
