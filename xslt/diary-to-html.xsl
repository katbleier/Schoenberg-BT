<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
  
  <xsl:template match="/">
    <html lang="de">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><xsl:value-of select="//tei:titleStmt/tei:title[@type='uniform']"/></title>
        <link rel="stylesheet" href="css/style.css"/>
      </head>
      <body>
        <header>
          <h1><xsl:value-of select="//tei:titleStmt/tei:title[@type='uniform']"/></h1>
          <h2><xsl:value-of select="//tei:titleStmt/tei:title[@type='source']"/></h2>
          <p class="author">
            von <xsl:value-of select="//tei:author/tei:forename"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="//tei:author/tei:surname"/>
          </p>
          <p class="editor">
            Herausgegeben von <xsl:value-of select="//tei:editor/tei:forename"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="//tei:editor/tei:surname"/>
          </p>
        </header>
        
        <nav>
          <ul>
            <li><a href="#entries">Einträge</a></li>
            <li><a href="#people">Personen</a></li>
            <li><a href="#places">Orte</a></li>
            <li><a href="#about">Über das Tagebuch</a></li>
          </ul>
        </nav>
        
        <main>
          <section id="entries">
            <h2>Tagebucheinträge</h2>
            <xsl:apply-templates select="//tei:div[@type='entry']"/>
          </section>
          
          <section id="people">
            <h2>Erwähnte Personen</h2>
            <xsl:call-template name="person-index"/>
          </section>
          
          <section id="places">
            <h2>Erwähnte Orte</h2>
            <xsl:call-template name="place-index"/>
          </section>
          
          <section id="about">
            <h2>Über das Tagebuch</h2>
            <xsl:apply-templates select="//tei:sourceDesc"/>
          </section>
        </main>
        
        <footer>
          <p>
            <xsl:text>Lizenz: </xsl:text>
            <a href="{//tei:licence/@target}">
              <xsl:value-of select="//tei:licence/text()"/>
            </a>
          </p>
        </footer>
        
        <script src="js/script.js"></script>
      </body>
    </html>
  </xsl:template>
  
  <!-- Template for diary entries -->
  <xsl:template match="tei:div[@type='entry']">
    <article class="entry">
      <xsl:if test="tei:pb">
        <div class="page-break">
          <a href="{tei:pb/@facs}" target="_blank" class="facsimile-link">
            [Seite <xsl:value-of select="tei:pb/@n"/>]
          </a>
        </div>
      </xsl:if>
      
      <header class="entry-header">
        <xsl:apply-templates select="tei:head"/>
      </header>
      
      <div class="entry-content">
        <xsl:apply-templates select="tei:p"/>
      </div>
    </article>
  </xsl:template>
  
  <!-- Template for entry headers -->
  <xsl:template match="tei:head">
    <h3>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  
  <!-- Template for dates -->
  <xsl:template match="tei:date">
    <time datetime="{@when-iso}">
      <xsl:apply-templates/>
    </time>
  </xsl:template>
  
  <!-- Template for paragraphs -->
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!-- Template for person names -->
  <xsl:template match="tei:persName">
    <span class="person" data-ref="{@ref}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <!-- Template for place names -->
  <xsl:template match="tei:placeName">
    <span class="place" data-ref="{@ref}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <!-- Template for titles -->
  <xsl:template match="tei:title">
    <cite class="title title-{@type}">
      <xsl:apply-templates/>
    </cite>
  </xsl:template>
  
  <!-- Template for organizations -->
  <xsl:template match="tei:orgName">
    <span class="organization">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <!-- Template for deletions -->
  <xsl:template match="tei:del">
    <del class="deletion deletion-{@rend}">
      <xsl:apply-templates/>
    </del>
  </xsl:template>
  
  <!-- Template for additions -->
  <xsl:template match="tei:add">
    <ins class="addition addition-{@place}">
      <xsl:apply-templates/>
    </ins>
  </xsl:template>
  
  <!-- Template for highlighting -->
  <xsl:template match="tei:hi">
    <span class="highlight highlight-{@rend}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <!-- Template for editorial notes -->
  <xsl:template match="tei:note[@type='commentary']">
    <span class="editorial-note" title="Redaktionelle Anmerkung: {.}">
      [Anm. d. Hrsg.]
    </span>
  </xsl:template>
  
  <!-- Person index template -->
  <xsl:template name="person-index">
    <ul class="person-list">
      <xsl:for-each-group select="//tei:persName" group-by="normalize-space(.)">
        <xsl:sort select="current-grouping-key()"/>
        <li>
          <strong><xsl:value-of select="current-grouping-key()"/></strong>
          <xsl:if test="current-group()/@ref">
            <a href="{current-group()[1]/@ref}" target="_blank" class="external-link">
              [GND]
            </a>
          </xsl:if>
          <span class="mention-count">
            (<xsl:value-of select="count(current-group())"/>
            <xsl:text> Erwähnung</xsl:text>
            <xsl:if test="count(current-group()) > 1">en</xsl:if>)
          </span>
        </li>
      </xsl:for-each-group>
    </ul>
  </xsl:template>
  
  <!-- Place index template -->
  <xsl:template name="place-index">
    <ul class="place-list">
      <xsl:for-each-group select="//tei:placeName" group-by="normalize-space(.)">
        <xsl:sort select="current-grouping-key()"/>
        <li>
          <strong><xsl:value-of select="current-grouping-key()"/></strong>
          <xsl:if test="current-group()/@ref">
            <a href="{current-group()[1]/@ref}" target="_blank" class="external-link">
              [GeoNames]
            </a>
          </xsl:if>
        </li>
      </xsl:for-each-group>
    </ul>
  </xsl:template>
  
  <!-- Source description template -->
  <xsl:template match="tei:sourceDesc">
    <div class="source-info">
      <h3>Quelle</h3>
      <p>
        <strong>Aufbewahrungsort:</strong>
        <xsl:value-of select=".//tei:settlement/tei:placeName"/>,
        <xsl:value-of select=".//tei:institution"/>
      </p>
      <p>
        <strong>Sammlung:</strong>
        <xsl:value-of select=".//tei:collection"/>
      </p>
      <p>
        <strong>Signatur:</strong>
        <xsl:value-of select=".//tei:idno[@type='shelfmark']"/>
      </p>
      <xsl:if test=".//tei:altIdentifier/tei:idno[@type='URI']">
        <p>
          <strong>URI:</strong>
          <a href="{.//tei:altIdentifier/tei:idno[@type='URI']}">
            <xsl:value-of select=".//tei:altIdentifier/tei:idno[@type='URI']"/>
          </a>
        </p>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>