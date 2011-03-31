<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="common.xsl" />

    <xsl:output method="xml" />
		
	<xsl:template match="/*">
		<ingredients>
		<xsl:for-each select="category"><xsl:copy-of select="." /></xsl:for-each>
		</ingredients>
	</xsl:template>
</xsl:stylesheet>
