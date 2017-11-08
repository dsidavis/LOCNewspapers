In addition to be named file.txt rather than file.xml,
the XML generated from Abbyy is not necessarily valid XML.
We can use the xmllint command line tool to see where errors occur
```
xmllint --noout Newspaper\ Article\ 4\ Text\ Page\ 11.txt 
```
```
Newspaper Article 4 Text Page 11.txt:44: parser error : attributes construct error
10.0" HEIGHT="116.0" WIDTH="696.0" HPOS="5364.0" VPOS="48.0" CONTENT="excluded."
```
The err is on line 44. The line reads:
```
<String ID="TB.0519.1_0_7" STYLEREFS="TS_10.0" HEIGHT="116.0" WIDTH="696.0" HPOS="5364.0" VPOS="48.0" CONTENT="excluded."" WC="1.0"/>
```
Note the two " at the end of the CONTENT attribute.
This is from the text "I shall order them excluded" at the very top of the page
which is actually on a page underneath the main page. This text ends in ''
and Abbyy did not escape the closing quote in the text as &quot;&quot; but just ".

So we could replace all "" with `&quot;&quot;"` before we read the XML.

We also have CONTENT="$t.0&.".  Again, the & needs to be escaped as `&amp;`.

We also have ""Nishop" which is again a " which needs to be escaped.


Then the XML parses correctly.


The XML documents have a root node named `alto`.
This has three children:  Description, Styles and Layout.
The Description provides the metadata for the document about when it was scanned.
This includes a MeasurementUnit.

The Styles node contains zero or more TextStyle nodes  of the form.
```
  <TextStyle ID="TS_10.0" FONTSIZE="10.0"/>
```
This gives an ID label and a font size.
Text elements will reference this ID value.

The Layout node has a Page node.
Most of these documents will have a single Page node.
The Page node has attributes giving the dimensions of the page.

The Page node has a PrintSpace.
This contains a sequence of TextBlock nodes.

