<?xml version="1.0" encoding="utf-8"?>

<!--
This is an XSL stylesheet which converts mscript XML files into HTML.
Use the XSLT command to perform the conversion.

Copyright 1984-2008 The MathWorks, Inc.
$Revision: 1.1.6.19 $  $Date: 2008/06/24 17:11:46 $
-->

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> <!ENTITY reg "&#174;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mwsh="http://www.mathworks.com/namespace/mcode/v1/syntaxhighlight.dtd"
  exclude-result-prefixes="mwsh">
  <xsl:output method="html"
    indent="yes" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:strip-space elements="mwsh:code"/>

<xsl:variable name="title">
  <xsl:variable name="dTitle" select="//steptitle[@style='document']"/>
  <xsl:choose>
    <xsl:when test="$dTitle"><xsl:value-of select="$dTitle"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="mscript/m-file"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<xsl:template match="mscript">
<html>

  <!-- head -->
  <head>
<xsl:comment>
This HTML is auto-generated from an M-file.
To make changes, update the M-file and republish this document.
      </xsl:comment>

    <title><xsl:value-of select="$title"/></title>

    <meta name="generator">
      <xsl:attribute name="content">MATLAB <xsl:value-of select="version"/></xsl:attribute>
    </meta>
    <meta name="date">
      <xsl:attribute name="content"><xsl:value-of select="date"/></xsl:attribute>
    </meta>
    <meta name="m-file">
      <xsl:attribute name="content"><xsl:value-of select="m-file"/></xsl:attribute>
    </meta>

    <xsl:call-template name="stylesheet"/>

  </head>

  <body>
    
    <xsl:call-template name="header"/>

    <div class="content">

    <!-- Determine if the there should be an introduction section. -->
    <xsl:variable name="hasIntro" select="count(cell[@style = 'overview'])"/>

    <!-- If there is an introduction, display it. -->
    <xsl:if test = "$hasIntro">
      <h1><xsl:apply-templates select="cell[1]/steptitle"/></h1>
      <xsl:comment>introduction</xsl:comment>
      <xsl:apply-templates select="cell[1]/text"/>
      <xsl:comment>/introduction</xsl:comment>
    </xsl:if>
    
    <xsl:variable name="body-cells" select="cell[not(@style = 'overview')]"/>

    <!-- Include contents if there are titles for any subsections. -->
    <xsl:if test="count(cell/steptitle[not(@style = 'document')])">
      <xsl:call-template name="contents">
        <xsl:with-param name="body-cells" select="$body-cells"/>
      </xsl:call-template>
    </xsl:if>
    
    <!-- Loop over each cell -->
    <xsl:for-each select="$body-cells">
        <!-- Title of cell -->
        <xsl:if test="steptitle">
          <xsl:variable name="headinglevel">
            <xsl:choose>
              <xsl:when test="steptitle[@style = 'document']">h1</xsl:when>
              <xsl:otherwise>h2</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="{$headinglevel}">
            <xsl:apply-templates select="steptitle"/>
            <xsl:if test="not(steptitle[@style = 'document'])">
              <a>
                <xsl:attribute name="name">
                  <xsl:value-of select="position()"/>
                </xsl:attribute>
              </a>
            </xsl:if>
          </xsl:element>
        </xsl:if>

        <!-- Contents of each cell -->
        <xsl:apply-templates select="text"/>
        <xsl:apply-templates select="mcode-xmlized"/>
        <xsl:apply-templates select="mcodeoutput|img"/>

    </xsl:for-each>

    <xsl:call-template name="footer"/>

    </div>
    
    <xsl:apply-templates select="originalCode"/>

  </body>
</html>
</xsl:template>

<xsl:template name="stylesheet">
  <style type="text/css">

body {
  background-color: white;
  margin:10px;
}

h1 {
  color: #990000; 
  font-size: x-large;
}

h2 {
  color: #990000;
  font-size: medium;
}

/* Make the text shrink to fit narrow windows, but not stretch too far in 
wide windows. */ 
p,h1,h2,div.content div {
  max-width: 600px;
  /* Hack for IE6 */
  width: auto !important; width: 600px;
}

pre.codeinput {
  background: #EEEEEE;
  padding: 10px;
}
@media print {
  pre.codeinput {word-wrap:break-word; width:100%;}
} 

span.keyword {color: #0000FF}
span.comment {color: #228B22}
span.string {color: #A020F0}
span.untermstring {color: #B20000}
span.syscmd {color: #B28C00}

pre.codeoutput {
  color: #666666;
  padding: 10px;
}

pre.error {
  color: red;
}

p.footer {
  text-align: right;
  font-size: xx-small;
  font-weight: lighter;
  font-style: italic;
  color: gray;
}

  </style>
</xsl:template>

<!-- Header -->
<xsl:template name="header">
</xsl:template>

<!-- Footer -->
<xsl:template name="footer">
    <p class="footer">

    </p>
</xsl:template>

<!-- Contents -->
<xsl:template name="contents">
  <xsl:param name="body-cells"/>
  <h2>Sample outputs</h2>
  <div><ul>
    <xsl:for-each select="$body-cells">
      <xsl:if test="./steptitle">        
        <li><a><xsl:attribute name="href">#<xsl:value-of select="position()"/></xsl:attribute><xsl:apply-templates select="steptitle"/></a></li>
      </xsl:if>
    </xsl:for-each>
  </ul></div>
</xsl:template>


<!-- HTML Tags in text sections -->
<xsl:template match="p">
  <p><xsl:apply-templates/></p>
</xsl:template>
<xsl:template match="ul">
  <div><ul><xsl:apply-templates/></ul></div>
</xsl:template>
<xsl:template match="ol">
  <div><ol><xsl:apply-templates/></ol></div>
</xsl:template>
<xsl:template match="li">
  <li><xsl:apply-templates/></li>
</xsl:template>
<xsl:template match="pre">
  <xsl:choose>
    <xsl:when test="@class='error'">
      <pre class="error"><xsl:apply-templates/></pre>
    </xsl:when>
    <xsl:otherwise>
      <pre><xsl:apply-templates/></pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="b">
  <b><xsl:apply-templates/></b>
</xsl:template>
<xsl:template match="i">
  <i><xsl:apply-templates/></i>
</xsl:template>
<xsl:template match="tt">
  <tt><xsl:apply-templates/></tt>
</xsl:template>
<xsl:template match="a">
  <a>
    <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>
<xsl:template match="html">
    <xsl:value-of select="@text" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="latex"/>

<!-- Code input and output -->

<xsl:template match="mcode-xmlized">
  <pre class="codeinput"><xsl:apply-templates/><xsl:text><!-- g162495 -->
</xsl:text></pre>
</xsl:template>

<xsl:template match="mcodeoutput">
  <xsl:choose>
    <xsl:when test="substring(.,0,7)='&lt;html&gt;'">
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:when>
    <xsl:otherwise>
      <pre class="codeoutput"><xsl:apply-templates/></pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Figure and model snapshots and equations -->
<xsl:template match="img[@class='equation']">
  <img>
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
  </img>
</xsl:template>

<xsl:template match="img">
  <img vspace="5" hspace="5">
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
    <xsl:text> </xsl:text>
  </img>
</xsl:template>

<!-- Stash original code in HTML for easy slurping later. -->

<xsl:template match="originalCode">
  <xsl:variable name="xcomment">
    <xsl:call-template name="globalReplace">
      <xsl:with-param name="outputString" select="."/>
      <xsl:with-param name="target" select="'--'"/>
      <xsl:with-param name="replacement" select="'REPLACE_WITH_DASH_DASH'"/>
    </xsl:call-template>
  </xsl:variable>
<xsl:comment>
##### SOURCE BEGIN #####
<xsl:value-of select="$xcomment"/>
##### SOURCE END #####
</xsl:comment>
</xsl:template>

<!-- Colors for syntax-highlighted input code -->

<xsl:template match="mwsh:code">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="mwsh:keywords">
  <span class="keyword"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:strings">
  <span class="string"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:comments">
  <span class="comment"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:unterminated_strings">
  <span class="untermstring"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:system_commands">
  <span class="syscmd"><xsl:value-of select="."/></span>
</xsl:template>


<!-- Footer information -->

<xsl:template match="copyright">
  <xsl:value-of select="."/>
</xsl:template>
<xsl:template match="revision">
  <xsl:value-of select="."/>
</xsl:template>

<!-- Search and replace  -->
<!-- From http://www.xml.com/lpt/a/2002/06/05/transforming.html -->

<xsl:template name="globalReplace">
  <xsl:param name="outputString"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($outputString,$target)">
      <xsl:value-of select=
        "concat(substring-before($outputString,$target),$replacement)"/>
      <xsl:call-template name="globalReplace">
        <xsl:with-param name="outputString" 
          select="substring-after($outputString,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replacement" 
          select="$replacement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$outputString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
