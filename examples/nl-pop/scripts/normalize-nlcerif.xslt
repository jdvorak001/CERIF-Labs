<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL" xpath-default-namespace="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="OrgUnit">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:variable name="id" select="@id"/>
			<xsl:if test="not( ancestor-or-self::*/preceding-sibling::*/descendant-or-self::OrgUnit[@id=$id] )">
				<xsl:apply-templates/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="Team">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="PrincipalInvestigator"/>
			<xsl:apply-templates select="Contact"/>
			<xsl:apply-templates select="Researcher"/>
			<xsl:apply-templates select="Supervisor"/>
			<xsl:apply-templates select="CoSupervisor"/>
			<xsl:apply-templates select="DoctoralStudent"/>
<!-- 
			<xsl:apply-templates select=""/>
 -->
		</xsl:copy>
 	</xsl:template>

</xsl:stylesheet>