<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />

	<xsl:param name="today" />
	<xsl:variable name="source" select="'http://www.narcis.nl/drilldownitems/coll/organisation/Language/EN/ddall/dd_cat'" />

	<xsl:variable name="nlDoc" select="document( //ul[@id='MetaNav']/li/a[string(.)='Nederlands']/@href )" />
	<xsl:variable name="nlRoot" select="$nlDoc//ul[@id='mktree']" />

	<xsl:template match="/">
		<xs:schema xmlns="urn:xmlns:nl:pop-project:vocab:Subjects#" xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" targetNamespace="urn:xmlns:nl:pop-project:vocab:Subjects#"
			xsi:schemaLocation="urn:xmlns:org:eurocris:cerif-1.6-2 http://www.eurocris.org/Uploads/Web%20pages/CERIF-1.6/CERIF_1.6_2.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xs:element name="Subject">
				<xs:annotation>
					<xs:documentation xml:lang="en">The discipline classification used in NARCIS</xs:documentation>
					<xs:appinfo>
						<CERIF xmlns="urn:xmlns:org:eurocris:cerif-1.6-2" date="{$today}" sourceDatabase="{$source}">
							<cfClassScheme>
								<cfClassSchemeId>175eb804-9f90-495b-a192-5d3c82d2f247<xsl:comment> NARCIS discipline classification </xsl:comment></cfClassSchemeId>
								<cfName cfLangCode="en" cfTrans="o">The discipline classification used in NARCIS</cfName>
							</cfClassScheme>
						</CERIF>
					</xs:appinfo>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xsl:apply-templates select="//ul[@id='mktree']//li" />
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:schema>
	</xsl:template>

	<xsl:template match="li">
		<xsl:variable name="code" select="substring-after( span/a/@href, '../../../../../../search/coll/organisation/Language/EN/dd_cat/' )" />
		<xs:enumeration value="{$code}">
			<xs:annotation>
				<xs:documentation xml:lang="en">
					<xsl:apply-templates select="span/a" mode="directTextOnly" />
				</xs:documentation>
				<xsl:variable name="nlNode" select="$nlRoot//li[ends-with(span/a/@href,concat('/',$code))]" />
				<xs:documentation xml:lang="nl">
					<xsl:apply-templates select="$nlNode/span/a" mode="directTextOnly" />
				</xs:documentation>
				<xs:appinfo>
					<CERIF xmlns="urn:xmlns:org:eurocris:cerif-1.6-2" date="{$today}" sourceDatabase="{$source}">
						<cfClass xmlns="urn:xmlns:org:eurocris:cerif-1.6-2">
							<cfClassId>
								<xsl:value-of select="$code" />
							</cfClassId>
							<cfClassSchemeId>175eb804-9f90-495b-a192-5d3c82d2f247<xsl:comment> NARCIS discipline classification </xsl:comment></cfClassSchemeId>
							<cfTerm cfLangCode="en" cfTrans="h">
								<xsl:apply-templates select="span/a" mode="directTextOnly" />
							</cfTerm>
							<cfTerm cfLangCode="nl" cfTrans="o">
								<xsl:apply-templates select="$nlNode/span/a" mode="directTextOnly" />
							</cfTerm>
							<cfTermSrc cfLangCode="en" cfTrans="o">NARCIS</cfTermSrc>
							<xsl:if test="ancestor::li">
								<cfClass_Class>
									<cfClassId1><xsl:value-of select="substring-after( ancestor::li[1]/span/a/@href, '../../../../../../search/coll/organisation/Language/EN/dd_cat/' )" /></cfClassId1>
									<cfClassSchemeId1>175eb804-9f90-495b-a192-5d3c82d2f247</cfClassSchemeId1>
									<cfClassId>385d4406-5a17-4cba-bb61-1178a6eb27aa<xsl:comment> skos:broader </xsl:comment></cfClassId>
									<cfClassSchemeId>ede6f6d4-e009-42c5-85ab-b3b34808da39<xsl:comment> SKOS semantic relations </xsl:comment></cfClassSchemeId>
								</cfClass_Class>
							</xsl:if>
						</cfClass>
					</CERIF>
				</xs:appinfo>
			</xs:annotation>
		</xs:enumeration>
	</xsl:template>

	<xsl:template match="a" mode="directTextOnly">
		<xsl:apply-templates mode="directTextOnly" />
	</xsl:template>

	<xsl:template match="text()" mode="directTextOnly">
		<xsl:value-of select="normalize-space(.)" />
	</xsl:template>

	<xsl:template match="*" mode="directTextOnly" />

</xsl:stylesheet>