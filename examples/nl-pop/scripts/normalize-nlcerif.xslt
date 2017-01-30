<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL" xpath-default-namespace="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="OrgUnit">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:variable name="id" select="@id" />
			<xsl:if test="not( ancestor-or-self::*/preceding-sibling::*/descendant-or-self::OrgUnit[@id=$id] )">
				<xsl:apply-templates />
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Team">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="PrincipalInvestigator" />
			<xsl:apply-templates select="Contact" />
			<xsl:apply-templates select="Researcher" />
			<xsl:apply-templates select="Supervisor" />
			<xsl:apply-templates select="CoSupervisor" />
			<xsl:apply-templates select="DoctoralStudent" />
			<!-- <xsl:apply-templates select=""/> -->
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Abstract[../Identifier[@type='urn:xmlns:nl:pop-project:vocab:IdentifierTypes#narcis'] eq 'OND1353009']">
		<Costs>
			<Cost>
				<Funding id="d3566767-6192-470e-b456-b99879d18aa3">
					<Type scheme="urn:xmlns:nl:pop-project:vocab:FundingTypes#">ProjectCostsCoveredByFunder</Type>
					<Name xml:lang="en">The costs of the project "The end of membership as we know it? Organized sports and sustainable social ties" covered by the funding from NWO</Name>
					<CoveredBy>
						<OrgUnit id="d3" />
					</CoveredBy>
					<ApplicationWithin>
						<Funding id="2491">
							<Type scheme="urn:xmlns:nl:pop-project:vocab:FundingTypes#">Call</Type>
							<Acronym>SPORT 2012 GW</Acronym>
							<Name xml:lang="en">Sport: Participation/SPORT 2012 GW</Name>
							<CoveredBy>
								<OrgUnit id="d3" />
							</CoveredBy>
						</Funding>
					</ApplicationWithin>
				</Funding>
			</Cost>
		</Costs>
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="Abstract[../Identifier[@type='urn:xmlns:nl:pop-project:vocab:IdentifierTypes#narcis'] eq 'OND1353032']">
		<Costs>
			<Cost>
				<Funding id="d3566767-6192-470e-b456-b99879d18aa3">
					<Type scheme="urn:xmlns:nl:pop-project:vocab:FundingTypes#">ProjectCostsCoveredByFunder</Type>
					<Name xml:lang="en">The costs of the project ""I am 70% heterosexual and 30% attracted to women": 'Unveiling the contruction of sexuality for women who have sex with women in South African Townships'" covered by the funding from NWO</Name>
					<CoveredBy>
						<OrgUnit id="d3051" />
					</CoveredBy>
					<ApplicationWithin>
						<Funding id="2062">
							<Type scheme="urn:xmlns:nl:pop-project:vocab:FundingTypes#">Call</Type>
							<Acronym>2012 MaGW</Acronym>
							<Name xml:lang="en">Research Talent/2012 MaGW</Name>
							<CoveredBy>
								<OrgUnit id="d3051" />
							</CoveredBy>
						</Funding>
					</ApplicationWithin>
				</Funding>
			</Cost>
		</Costs>
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>