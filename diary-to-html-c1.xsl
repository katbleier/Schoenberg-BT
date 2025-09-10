<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <!-- Root template -->
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//tei:title[@type='uniform']"/></title>
        <meta charset="UTF-8"/>
        <style>
          body { 
          font-family: Georgia, serif; 
          max-width: 800px; 
          margin: 0 auto; 
          padding: 20px; 
          line-height: 1.6; 
          }
          .header { 
          border-bottom: 2px solid #333; 
          padding-bottom: 20px; 
          margin-bottom: 30px; 
          }
          .entry { 
          margin-bottom: 30px; 
          padding: 20px; 
          border-left: 3px solid #ccc; 
          background-color: #fafafa; 
          }
          .entry-date { 
          font-weight: bold; 
          color: #666; 
          margin-bottom: 15px; 
          font-size: 1.2em; 
          }
          .underline { text-decoration: underline; }
          .strikethrough { text-decoration: line-through; }
          .addition { 
          color: #006600; 
          font-style: italic; 
          }
          .person { 
          font-weight: bold; 
          color: #0066cc; 
          }
          .place { 
          font-style: italic; 
          color: #cc6600; 
          }
          .title { 
          font-style: italic; 
          color: #990099; 
          }
          .org { 
          font-variant: small-caps; 
          color: #006666; 
          }
          .note { 
          font-size: 0.9em; 
          color: #666; 
          background-color: #f0f0f0; 
          padding: 5px; 
          margin: 10px 0; 
          border-left: 3px solid #999; 
          }
          .page-break { 
          color: #999; 
          font-size: 0.8em; 
          margin: 10px 0; 
          text-align: center; 
          }
          .metadata { 
          font-size: 0.9em; 
          color: #666; 
          margin-bottom: 20px; 
          }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="//tei:TEI"/>
      </body>
    </html>
  </xsl:template>
  
  <!-- TEI root -->
  <xsl:template match="tei:TEI">
    <div class="header">
      <h1><xsl:value-of select="tei:teiHeader//tei:title[@type='uniform']"/></h1>
      <div class="metadata">
        <p><strong>Author:</strong> 
          <xsl:value-of select="tei:teiHeader//tei:author/tei:forename"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="tei:teiHeader//tei:author/tei:surname"/>
        </p>
        <p><strong>Source:</strong> <xsl:value-of select="tei:teiHeader//tei:title[@type='source']"/></p>
        <p><strong>Institution:</strong> <xsl:value-of select="tei:teiHeader//tei:institution"/></p>
        <p><strong>Shelf Mark:</strong> <xsl:value-of select="tei:teiHeader//tei:idno[@type='shelfmark']"/></p>
      </div>
    </div>
    <xsl:apply-templates select="tei:text/tei:body"/>
  </xsl:template>
  
  <!-- Diary entries -->
  <xsl:template match="tei:pb"> 
    <div class="page">
      <h3>Page <xsl:value-of select="@n"/></h3>
      <img src="{@facs}" alt="Facsimile page {@n}" style="max-width:100%; height:auto;"/>
    </div>
  </xsl:template>
  
  <!-- Entry headers/dates -->
  <xsl:template match="tei:head">
    <div class="entry-date">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <!-- Paragraphs -->
  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <!-- Dates -->
  <xsl:template match="tei:date">
    <span class="date">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <!-- Text formatting -->
  <xsl:template match="tei:hi[@rend='#u']">
    <span class="underline"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="tei:del[@rend='strikethrough']">
    <span class="strikethrough"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="tei:add">
    <span class="addition"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- People -->
  <xsl:template match="tei:persName">
    <span class="person">
      <xsl:choose>
        <xsl:when test="@ref">
          <a href="{@ref}" target="_blank"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  
  <!-- Places -->
  <xsl:template match="tei:placeName">
    <span class="place">
      <xsl:choose>
        <xsl:when test="@ref">
          <a href="{@ref}" target="_blank"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  
  <!-- Titles (music, books, etc.) -->
  <xsl:template match="tei:title">
    <span class="title"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- Organizations -->
  <xsl:template match="tei:orgName">
    <span class="org"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- Abbreviations and expansions -->
  <xsl:template match="tei:abbr">
    <abbr title="{following-sibling::tei:expan}">
      <xsl:apply-templates/>
    </abbr>
  </xsl:template>
  
  <xsl:template match="tei:expan">
    <!-- Skip expansions as they're handled in abbr template -->
  </xsl:template>
  
  <!-- Notes -->
  <xsl:template match="tei:note">
    <div class="note">
      <strong>Note:</strong> <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <!-- Page breaks -->
  <xsl:template match="tei:pb">
    <div class="page">
      <h3>Page <xsl:value-of select="@n"/></h3>
      <xsl:if test="@facs">
        <a href="{@facs}" target="_blank">
          <img src="{@facs}" alt="Facsimile page {@n}" style="max-width:100%; height:auto;" loading="lazy"/>
        </a>
      </xsl:if>
    </div>
  </xsl:template>
  
  <!-- Default text handling -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
</xsl:stylesheet>