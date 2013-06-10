<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>
<xsl:param name="referringInstance">
  <!-- the instances that refers to every object instance created here,
       ie. the instance that represents the TEI doc;
       if you give a non-prefixed URI, include surrounding brackets: <http:my.example/123> -->
</xsl:param>
<xsl:param name="instanceURIPrefix"> 
  <!-- a URI prefix that will be used for every instance created here -->
</xsl:param>



<xsl:template match="/">
  <!-- starting template: scans the doc for occurences of the tags
       that shall be converted and calls the conversion template for each -->
  <xsl:for-each select="//term">
    <!-- a <term> tag -->
    <xsl:call-template name="term">
      <xsl:with-param name="instClass">ecrm:E55_Type</xsl:with-param>
      <xsl:with-param name="nameClass">ecrm:E75_Conceptual_Object_Appellation</xsl:with-param>
      <xsl:with-param name="nameProp">ecrm:P1_is_identified_by</xsl:with-param>
      <xsl:with-param name="dtNameProp">ecrm:P3_has_note</xsl:with-param>
      <xsl:with-param name="referProp">ecrm:P67i_is_refered_to_by</xsl:with-param>
    </xsl:call-template>
  </xsl:for-each>

  <xsl:for-each select="//rs">
    <!-- a <rs> tag -->
    <xsl:call-template name="term">
      <xsl:with-param name="instClass">ecrm:E1_CRM_Entity</xsl:with-param>
      <xsl:with-param name="nameClass">ecrm:E41_Appellation</xsl:with-param>
      <xsl:with-param name="nameProp">ecrm:P1_is_identified_by</xsl:with-param>
      <xsl:with-param name="dtNameProp">ecrm:P3_has_note</xsl:with-param>
      <xsl:with-param name="referProp">ecrm:P67i_is_refered_to_by</xsl:with-param>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>



<xsl:template name="term">
  <!-- creates an object instance with an associated name instance
       and links it to the global referring instance. There are all together
       5 class and properties that can be varied: -->
  <xsl:param name="instClass">
    <!-- the class of the object instance -->
  </xsl:param>
  <xsl:param name="nameClass">
    <!-- the class of the name instance -->
  </xsl:param>
  <xsl:param name="nameProp">
    <!-- the property that links object and name --> 
  </xsl:param>
  <xsl:param name="dtNameProp">
    <!-- the datatype property that links the name instance to its string value -->
  </xsl:param>
  <xsl:param name="referProp">
    <!-- the property that links the object instance to the referring instance -->
  </xsl:param>
 
  <xsl:variable name="id" select="generate-id()"/>
  <xsl:variable name="inst" select="concat($instanceURIPrefix, 'inst', $id)"/>
  <xsl:variable name="name" select="concat($instanceURIPrefix, 'name', $id)"/>
  <xsl:variable name="text">
    <xsl:text>"""</xsl:text>
    <xsl:call-template name="encodeLiteral">
      <xsl:with-param name="text"><xsl:value-of select="."/></xsl:with-param>
    </xsl:call-template>
    <xsl:text>"""</xsl:text>
  </xsl:variable>

  <xsl:value-of select="concat($inst, ' a ', $instClass, ' . ')"/><xsl:text>
</xsl:text>
  <xsl:value-of select="concat($name, ' a ', $nameClass, ' . ')"/><xsl:text>
</xsl:text>
  <xsl:value-of select="concat($inst, ' ', $nameProp, ' ', $name, ' . ')"/><xsl:text>
</xsl:text>
  <xsl:value-of select="concat($inst, ' ', $referProp, ' ', $referringInstance, ' . ')"/><xsl:text>
</xsl:text>
  <xsl:value-of select="concat($name, ' ', $dtNameProp, ' ', $text, ' . ')"/><xsl:text>

</xsl:text>

</xsl:template>



<xsl:template name="encodeLiteral">
  <xsl:param name="text" />
  <xsl:call-template name="string-replace-all">
    <xsl:with-param name="text">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$text" />
        <xsl:with-param name="replace" select="'\'" />
        <xsl:with-param name="by" select="'\\'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="replace" select="'&quot;'" />
    <xsl:with-param name="by" select="'\&quot;'" />
  </xsl:call-template>
</xsl:template>

     

<xsl:template name="string-replace-all">
  <!-- taken from codesling : http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx -->
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text"
        select="substring-after($text,$replace)" />
        <xsl:with-param name="replace" select="$replace" />
        <xsl:with-param name="by" select="$by" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet> 
