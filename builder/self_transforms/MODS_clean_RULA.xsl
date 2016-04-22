<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:etd="http://www.ndltd.org/standards/metadata/etdms/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" exclude-result-prefixes="etd xsi">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>

	<!--
	  -
	  - METADATA EDITS GO BELOW HERE
	  -
	-->

	<!-- THESIS COLLECTION-SPECIFIC EDITS -->

		<!-- Replace "Degree grantor" with "Degree granting institution" -->
		<xsl:template match="text()[. = 'Degree grantor']">
			<xsl:text>Degree granting institution</xsl:text>
		</xsl:template>

		<!-- Remove empty <extension> elements & children -->
		<xsl:template match="mods:extension[. = '']"/>

	<!-- RESEARCH COLLECTION-SPECIFIC EDITS -->

		<!-- 3: normalize <typeOfResource> values -->
		<!--
		<xsl:template match="mods:typeOfResource">
			<mods:typeOfResource>text</mods:typeOfResource>

			<xsl:if test=". != 'text'">
				<mods:genre>
					<xsl:value-of select="."/>
				</mods:genre>
			</xsl:if>
		</xsl:template>
		-->

	<!-- GENERAL/UNIVERSAL EDITS -->

		<!-- Remove <subtitle> elements -->
		<xsl:template match="mods:subTitle"/>

		<!-- Remove empty <abstract> elements -->
		<xsl:template match="mods:abstract[. = '']"/>

		<!-- Remove empty <dateOther> elements -->
		<xsl:template match="mods:dateOther[. = '']"/>

		<!-- Remove empty <identifier> elements -->
		<xsl:template match="mods:identifier[. = '']"/>

		<!-- Remove empty <note> elements -->
		<xsl:template match="mods:note[. = '']"/>

		<!-- Remove empty <subject> elements -->
		<xsl:template match="mods:subject[. = '']"/>

		<!-- Remove empty <topic> elements -->
		<xsl:template match="mods:topic[. = '']"/>

		<!-- Remove empty <geographic> elements -->
		<xsl:template match="mods:geographic[. = '']"/>

		<!-- Remove empty <temporal> elements -->
		<xsl:template match="mods:temporal[. = '']"/>

		<!-- Remove empty <url> under <location> -->
		<xsl:template match="mods:location">
			<mods:location/>
		</xsl:template>

		<!-- Remove duplicate <abstract> elements -->
		<xsl:template match="mods:abstract[. = following::mods:abstract]"/>
		<xsl:template match="mods:abstract[. = preceding::mods:abstract]"/>

		<!-- Correct personal <name> elements -->
		<xsl:template match="mods:name[@type = 'personal']" name="name_personal">
			<xsl:choose>
				<xsl:when test="not(mods:namePart[@type = 'given' or @type = 'family'])"/>
				<xsl:when test="mods:namePart[@type = 'given'] = '' and
								mods:namePart[@type = 'family'] = ''"/>
				<xsl:otherwise>
					<mods:name type="personal">
						<xsl:apply-templates/>
					</mods:name>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

		<!-- Correct corporate <name> elements -->
		<xsl:template match="mods:name[@type = 'corporate']" name="name_corporate">
			<xsl:choose>
				<xsl:when test="mods:namePart[@type = 'given' or @type = 'family']"/>
				<xsl:when test="mods:namePart = ''"/>
				<xsl:otherwise>
					<mods:name type="corporate">
						<xsl:apply-templates/>
					</mods:name>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

		<!-- Correct untyped <name> elements -->
		<xsl:template match="mods:name[not(@type) or @type = '']">
			<xsl:choose>
				<xsl:when test="mods:namePart[@type = 'given' or @type = 'family']">
					<xsl:call-template name="name_personal"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="name_corporate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

		<!-- Correct copyright license statement -->
		<xsl:template match="mods:accessCondition">
			<xsl:choose>
				<!-- For now, theses don't have license information -->
				<xsl:when test="//mods:genre = 'thesis'"/>
				<xsl:when test=". = 'C'">
					<mods:accessCondition type="restrictionOnAccess">All Rights Reserved</mods:accessCondition>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

	<!--
	  -
	  - DO NOT MODIFY ANYTHING BELOW THIS LINE
	  - UNLESS YOU KNOW WHAT YOU ARE DOING!
	  -
	-->

	<!-- Canonical identity transform -->
	<!--
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	-->

	<!-- Namespace-aware identity transform -->
	<!-- Copy elements -->
	<xsl:template match="*" priority="-1">
	   <xsl:element name="{name()}">
	      <xsl:apply-templates select="node()|@*"/>
	   </xsl:element>
	</xsl:template>

	<!-- Copy all other nodes -->
	<xsl:template match="node()|@*" priority="-2">
	   <xsl:copy />
	</xsl:template>

	<!-- add namespace prefix -->
	<xsl:template match="mods:*">
		<xsl:element name="mods:{local-name()}" namespace="http://www.loc.gov/mods/v3">
			<xsl:copy-of select="namespace::*"/>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
