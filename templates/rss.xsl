<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="common.xsl" />

	<xsl:template match="/*">
	<rss version="2.0">
		<channel>
			<title>Kuchařka</title>
			<description>Kuchařka Jany, Ondry a jejich kamarádů</description>
			<link>http://kucharka.zarovi.cz/</link>
			
			<xsl:for-each select="//recipe">
			<item>
				<title><xsl:value-of select="@name" /></title>
				<link>http://kucharka.zarovi.cz<xsl:value-of select="$BASE" />/recept/<xsl:value-of select="@id" /></link>
				<guid>http://kucharka.zarovi.cz<xsl:value-of select="$BASE" />/recept/<xsl:value-of select="@id" /></guid>
			</item>
			</xsl:for-each>
		</channel>
	</rss>

	</xsl:template>
</xsl:stylesheet>
