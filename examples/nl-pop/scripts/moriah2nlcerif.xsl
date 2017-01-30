<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#default a" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://value.moriah.vsoi.dans.knaw.nl" xmlns="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL" >
	<xsl:template match="/">
		<xsl:for-each select="/a:projects/a:project">
			<xsl:variable name="filename" select="concat( 'sample-', format-number( count( preceding-sibling::a:project ) + 1, '00' ), '.xml' )"/>
			<xsl:result-document href="{$filename}" method="xml" indent="yes">
<FundingAwardNotice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL ./schemas/p-o-p-profile-schema.xsd">
	<xsl:text>
   </xsl:text>
	<xsl:comment>A fictitious project funding award notice based on a real-world project, see<xsl:value-of select="comment()[1]"/></xsl:comment>
	<xsl:text>
</xsl:text>

    <Project>
    	<xsl:apply-templates select="a:title"/>
    	<xsl:apply-templates select="a:id"/>
    	<xsl:apply-templates select="a:startDate"/>
    	<xsl:apply-templates select="a:endDate"/>

		<Funders>
			<Funder>
				<OrgUnit id="87a63334-0943-4669-a3a4-151826c45c97">
					<Acronym>NWO</Acronym>
					<Name xml:lang="en">Netherlands Organisation for Scientific Research</Name>
					<Name xml:lang="nl">Nederlandse Organisatie voor Wetenschappelijk Onderzoek</Name>
					<FundRefId>http://dx.doi.org/10.13039/501100003246</FundRefId>
				</OrgUnit>
			</Funder>
		</Funders>

		<Consortium>
		</Consortium>
	</Project>
</FundingAwardNotice>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="a:title">
	    <xsl:element name="Title">
	    	<xsl:attribute name="xml:lang">
	    		<xsl:choose>
			    	<xsl:when test="@xml:lang">
			    		 <xsl:value-of select="lower-case(@xml:lang)"/>
			    	</xsl:when>
			    	<xsl:otherwise>
			    		<xsl:text>en</xsl:text>
			    	</xsl:otherwise>
	    		</xsl:choose>
	    	</xsl:attribute>
	    	<xsl:value-of select="."/>
	    </xsl:element>
	</xsl:template>

	<xsl:template match="a:id">
	    <Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#{@authority}"><xsl:value-of select="."/></Identifier>
	</xsl:template>

	<xsl:template match="a:startDate | a:endDate">
	    <xsl:element name="{concat( upper-case( substring( local-name(), 1, 1 ) ), substring( local-name(), 2 ) )}"><xsl:value-of select="."/></xsl:element>
	</xsl:template>
	
</xsl:stylesheet>