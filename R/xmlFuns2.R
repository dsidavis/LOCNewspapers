readABBYY =
    #
    # Read the ABBYY XML files (.txt) into a data frame
    # containing the information for each <String>  element.
    # For now, we discard the TextBlock and TextLine until we know we need
    # information from them that is not in the String elements.
    #
    # Todo: Include the Font information, the <SP> and <HYP> information.
    #
function(file, doc = xmlParse(fixXML(file), asText = TRUE))
{
    str = xpathApply(doc, "//x:String", getStringDF, namespaces = "x")

    ans = as.data.frame(do.call(rbind, str), stringsAsFactors = FALSE)
    nv = c("HEIGHT", "WIDTH", "HPOS", "VPOS")
    ans[nv] = lapply(ans[nv], as.numeric)
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
    ll = gsub('""', "''\"", ll)
    # Now fix the "...&..."
    ## gregexpr('="[^"]+")
    ll
}
