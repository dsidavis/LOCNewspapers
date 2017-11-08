readABBYY =
    #
    # Read the ABBYY XML files (.txt) into a data frame
    # containing the information for each <String>  element.
    # For now, we discard the TextBlock and TextLine until we know we need
    # information from them that is not in the String elements.
    #
    # Todo: Include the <SP> and <HYP> information.
    #
function(file, doc = xmlParse(fixXML(file), asText = TRUE))
{
    str = xpathApply(doc, "//x:String", getStringDF, namespaces = "x")
  
    ans = as.data.frame(do.call(rbind, str), stringsAsFactors = FALSE)
    nv = c("HEIGHT", "WIDTH", "HPOS", "VPOS")
    ans[nv] = lapply(ans[nv], as.numeric)

    # Add the font size information for each string
    sty = getNodeSet(doc, "//x:Styles/x:TextStyle", "x")
    fontsize = as.numeric(sapply(sty, xmlGetAttr, "FONTSIZE"))
    names(fontsize) = sapply(sty, xmlGetAttr, "ID")    
    ans$fontSize = fontsize[ans$STYLEREFS]
    
    ans
}

getStringDF =
function(node)
{
    tmp = xmlAttrs(node)
    if(!("SUBS_CONTENT" %in% names(tmp)))
        tmp[c("SUBS_CONTENT", "SUBS_TYPE")] = NA_character_
    
    as.data.frame(as.list(tmp), stringsAsFactors = FALSE)
}


fixXML =
function(file, lines = readLines(file))
{
    # ll = gsub('""', "''\"", ll)
    ll = gsub('CONTENT="([^ ]*?)"([^ ]*?)" ', 'CONTENT="\\1&quot;\\2" ', lines, perl = TRUE)
    # Now fix the "...&..."
    ll = gsub('CONTENT="([^ ]*?)&([^ ]*?)" ', 'CONTENT="\\1&amp;\\2" ', ll, perl = TRUE)
    ll = gsub('CONTENT="([^ ]*?)\\<([^ ]*?)" ', 'CONTENT="\\1&lt;\\2" ', ll, perl = TRUE)        
    ## gregexpr('="[^"]+")
    ll
}
