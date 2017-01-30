<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#default a xs" xmlns:a="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL">

	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="url" select="/html/head/link[@rel='canonical']/@href"/>
	<xsl:variable name="recordId" select="substring-after( $url, '/RecordID/' )"/>
	<xsl:variable name="nlDoc" select="document( //ul[@id='MetaNav']/li/a[string(.)='Nederlands']/@href )"/>

	<xsl:template match="/">

<FundingAwardNotice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL ../schemas/p-o-p-profile-schema.xsd">
	<xsl:text>
   </xsl:text>
	<xsl:comment> A fictitious project funding award notice based on a real-world project, see <xsl:value-of select="$url"/><xsl:text> </xsl:text></xsl:comment>
	<xsl:text>
</xsl:text>

    <Project id="{generate-id()}">
    	<xsl:variable name="enTitle" select="normalize-space( //div[@class='meta-info']/table/tr[th='Title']/td )"/>
    	<xsl:variable name="nlTitle" select="normalize-space( $nlDoc//div[@class='meta-info']/table/tr[th='Titel']/td )"/>
    	<Title xml:lang="en"><xsl:value-of select="$enTitle"/></Title>
    	<xsl:if test="$nlTitle ne $enTitle">
    		<Title xml:lang="nl"><xsl:value-of select="$nlTitle"/></Title>
    	</xsl:if>
    	<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#narcis"><xsl:value-of select="$recordId"/></Identifier>
    	<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#source-url"><xsl:value-of select="$url"/></Identifier>
    	
    	<xsl:variable name="dates" select="//div[@class='meta-info']/table/tr[th='Period']/td"/>
    	<xsl:variable name="startDate" select="replace( substring-before( $dates, '-' ), ' ', '' )"/>
    	<xsl:variable name="endDate" select="replace( substring-after( $dates, '-' ), ' ', '' )"/>
    	<xsl:variable name="startYear" select="replace( $startDate, '.*/', '' )"/>
    	<xsl:variable name="startMonth" select="replace( substring-before( concat( '01/', $startDate ), concat( '/', $startYear ) ), '/.*', '' )"/>
    	<xsl:if test="matches( $startYear, '[0-9][0-9][0-9][0-9]' )">
    		<StartDate><xsl:value-of select="concat( $startYear, '-', $startMonth, '-01' )"/></StartDate>
    	</xsl:if>
    	<xsl:if test="$endDate ne 'unknown'">
	    	<xsl:variable name="endYear" select="replace( $endDate, '.*/', '' )"/>
	    	<xsl:variable name="endMonth" select="replace( substring-before( concat( '12/', $endDate ), concat( '/', $endYear ) ), '/.*', '' )"/>
	    	<EndDate><xsl:value-of select="xs:date( concat( $endYear, '-', $endMonth, '-01' ) ) + xs:yearMonthDuration('P1M') - xs:dayTimeDuration('P1D')"/></EndDate>
    	</xsl:if>
    	
    	<xsl:variable name="funders" select="//div[@class='meta-info']/table/tr[th='Financier']/td"/>
    	<xsl:if test="$funders">
			<Funders>
				<xsl:for-each select="$funders">
					<Funder>
						<xsl:call-template name="orgChainUp"/>
					</Funder>
				</xsl:for-each>
			</Funders>
		</xsl:if>

		<Consortium>
			<xsl:for-each select="//div[@class='meta-info' and preceding-sibling::h2[1] eq 'Related organisations']/table/tr[th ne 'Financier' and th ne 'Commissioner']/td">
				<xsl:element name="{string(preceding-sibling::th)}">
					<xsl:call-template name="orgChainUp"/>
				</xsl:element>
			</xsl:for-each>
		</Consortium>
		
		<Team>
			<xsl:for-each select="//div[@class='meta-info' and preceding-sibling::h2[1] eq 'Related people']/table/tr/td">
				<xsl:variable name="roleTitle" select="string( preceding-sibling::th )"/>
				<xsl:variable name="role">
					<xsl:choose>
						<xsl:when test="$roleTitle eq 'Project leader'">PrincipalInvestigator</xsl:when>
						<xsl:when test="$roleTitle eq 'Supervisor'">Supervisor</xsl:when>
						<xsl:when test="$roleTitle eq 'Co-supervisor'">CoSupervisor</xsl:when>
						<xsl:when test="$roleTitle eq 'Doctoral/PhD student'">DoctoralStudent</xsl:when>
						<xsl:when test="$roleTitle eq 'Researcher'">Researcher</xsl:when>
						<xsl:when test="$roleTitle eq 'Contact person'">Contact</xsl:when>
						<xsl:otherwise>0<xsl:message>Unknown person role of '<xsl:value-of select="$roleTitle"/>'</xsl:message></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$role ne '0'">
					<xsl:element name="{$role}">
						<DisplayName><xsl:value-of select="string(.)"/></DisplayName>
						<xsl:call-template name="personWithAffiliations"/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</Team>
		
		<xsl:for-each select="//div[@class='meta-info' and preceding-sibling::h2[1] eq 'Classification']/table/tr/th">
			<Subject xmlns="urn:xmlns:nl:pop-project:vocab:Subjects#"><xsl:value-of select="."/></Subject>
		</xsl:for-each>
		
		<xsl:for-each select="//div[@class='meta-info' and preceding-sibling::h2[1] eq 'Abstract']/table/tr/td">
			<Abstract xml:lang="en"><xsl:apply-templates mode="copy"/></Abstract>
		</xsl:for-each>
		
	</Project>
</FundingAwardNotice>
	</xsl:template>
	
	<xsl:template match="node()|@*" mode="copy">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="copy"/>
			<xsl:apply-templates mode="copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="td">
		<xsl:param name="elName"/>
		<xsl:element name="{$elName}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="orgChainUp">
		<xsl:variable name="orgDoc" select="document( a/@href )"/>
		<xsl:variable name="nlOrgDoc" select="$orgDoc/document( //ul[@id='MetaNav']/li/a[string(.)='Nederlands']/@href )"/>
		<xsl:variable name="orgUrl" select="substring-before( $orgDoc/html/head/link[@rel='canonical']/@href, '/Language/en' )"/>
		<xsl:variable name="orgId" select="substring-after( $orgUrl, '/RecordID/' )"/>
		<OrgUnit id="{$orgDoc/generate-id()}">
			<xsl:variable name="acronym" select="$orgDoc//div[@class='meta-info']/table/tr[th='Acronym']/td"/>
			<xsl:apply-templates select="$acronym"><xsl:with-param name="elName" select="'Acronym'"/></xsl:apply-templates>
			<xsl:variable name="enName1" select="$orgDoc//h1"/>
			<xsl:variable name="enName">
				<xsl:choose>
					<xsl:when test="starts-with( $acronym, 'NWO-' )"><xsl:value-of select="normalize-space( replace( replace( $enName1, concat( '\(', substring-after( $acronym, 'NWO-' ), '\)$' ), '' ), concat( '- ', substring-after( $acronym, 'NWO-' ), '$' ), '' ) )"/></xsl:when>
					<xsl:when test="$acronym"><xsl:value-of select="normalize-space( replace( replace( $enName1, concat( '\(', $acronym, '\)$' ), '' ), concat( '- ', $acronym, '$' ), '' ) )"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$enName1"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<Name xml:lang="en"><xsl:value-of select="$enName"/></Name>
			<xsl:variable name="nlName1" select="$nlOrgDoc//h1"/>
			<xsl:variable name="nlName">
				<xsl:choose>
					<xsl:when test="starts-with( $acronym, 'NWO-' )"><xsl:value-of select="normalize-space( replace( replace( $nlName1, concat( '\(', substring-after( $acronym, 'NWO-' ), '\)$' ), '' ), concat( '- ', substring-after( $acronym, 'NWO-' ), '$' ), '' ) )"/></xsl:when>
					<xsl:when test="$acronym"><xsl:value-of select="normalize-space( replace( replace( $nlName1, concat( '\(', $acronym, '\)$' ), '' ), concat( '- ', $acronym, '$' ), '' ) )"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$nlName1"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$enName ne $nlName">
				<Name xml:lang="nl"><xsl:value-of select="$nlName"/></Name>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1236737'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100003246</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1237024'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100003958</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1236141'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100001722</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1238854'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100001826</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1234893'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100002999</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1243855'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100003001</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1234875'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100003195</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1234888'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100003245</Identifier>
			</xsl:if>
			<xsl:if test="$orgId eq 'ORG1234721'">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId">http://dx.doi.org/10.13039/501100000780</Identifier>
			</xsl:if>
<!-- 
			<xsl:if test="$orgId eq ''">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#FundRefId"></Identifier>
			</xsl:if>
 -->			
			<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#narcis"><xsl:value-of select="$orgId"/></Identifier>
	    	<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#source-url"><xsl:value-of select="$orgUrl"/></Identifier>
			<xsl:for-each select="$orgDoc//div[@class='meta-info']/table/tr[th='Part of'][1]/td">
				<PartOf>
					<xsl:call-template name="orgChainUp"/>
				</PartOf>
			</xsl:for-each>
		</OrgUnit>
	</xsl:template>
	
	<xsl:template name="personWithAffiliations">
		<xsl:variable name="persDoc" select="document( a/@href )"/>
		<xsl:variable name="persId" select="substring-after( substring-before( a/@href, '/Language/en' ), '/RecordID/' )"/>
		<Person id="{$persDoc/generate-id()}">
			<PersonName>
				<xsl:variable name="name" select="replace( $persDoc//a[@rel='nofollow']/span, '(Register|Login) as ', '' )"/>
				<xsl:variable name="lastX">
					<xsl:choose>
						<xsl:when test="contains( $name, ') ' )"><xsl:value-of select="normalize-space( substring-after( $name, ') ' ) )"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="normalize-space( substring-after( $name, ' ' ) )"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="firstName" select="normalize-space( substring-before( $name, $lastX ) )"/>
				<xsl:variable name="familyName">
					<xsl:choose>
						<xsl:when test="starts-with( $lastX, &quot;van der &quot; )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van der &quot; ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;von der &quot; )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;von der &quot; ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;van den &quot; )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van den &quot; ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;von den &quot; )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;von den &quot; ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;van het &quot; )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van het &quot; ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;van de &quot;  )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van de &quot;  ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;von de &quot;  )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;von de &quot;  ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;van 't &quot;  )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van 't &quot;  ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;van &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;van &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;von &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;von &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;op der &quot;  )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;op der &quot;  ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;op den &quot;  )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;op den &quot;  ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;op de &quot;   )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;op de &quot;   ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;het &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;het &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;ter &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;ter &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;ten &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;ten &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;te &quot;      )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;te &quot;      ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;der &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;der &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;den &quot;     )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;den &quot;     ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;de &quot;      )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;de &quot;      ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;op 't &quot;   )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;op 't &quot;   ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;'t &quot;      )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;'t &quot;      ) )"/></xsl:when>
						<xsl:when test="starts-with( $lastX, &quot;d' &quot;      )"><xsl:value-of select="normalize-space( substring-after( $name, &quot;d' &quot;      ) )"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$lastX"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<FamilyNames><xsl:value-of select="$familyName"/></FamilyNames>
				<FirstNames><xsl:value-of select="$firstName"/></FirstNames>
				<xsl:if test="$lastX ne $familyName">
					<OtherNames><xsl:value-of select="normalize-space( substring-before( $lastX, $familyName ) )"/></OtherNames>
				</xsl:if>
			</PersonName>
			<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#narcis"><xsl:value-of select="$persId"/></Identifier>
	    	<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#source-url">http://www.narcis.nl/person/RecordID/<xsl:value-of select="$persId"/></Identifier>
			<xsl:for-each select="$persDoc//div[@class='meta-info']/table/tr[th/span eq 'ISNI']/td">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#isni"><xsl:value-of select="normalize-space( substring-after( ., 'ISNI' ) )"/></Identifier>
			</xsl:for-each>
			<xsl:for-each select="$persDoc//div[@class='meta-info']/table/tr[th/span eq 'Digital Author ID']/td">
				<Identifier type="urn:xmlns:nl:pop-project:vocab:IdentifierTypes#dai"><xsl:value-of select="."/></Identifier>
			</xsl:for-each>
		</Person>
		<xsl:for-each select="$persDoc//div[@class='meta-info' and preceding-sibling::h2[1] eq 'Active as']/table/tr[th='Organisation']/td">
			<Affiliation>
				<xsl:call-template name="orgChainUp"/>
			</Affiliation>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>