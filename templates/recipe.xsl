<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="common.xsl" />

    <xsl:output 
		method="html"
		omit-xml-declaration="yes" 
		doctype-system="about:legacy-compat"
	/>
		
	<xsl:template match="/*">

	<html>
		<xsl:call-template name="head" />

		<body>
			<xsl:call-template name="menu" /> 
			
			<xsl:for-each select="recipe">
				<h1><xsl:value-of select="@name" /></h1>
			
				<ul>
					<xsl:for-each select="ingredient">
						<li>
							<xsl:value-of select="@name" />
							<xsl:text> </xsl:text>
							<xsl:value-of select="@amount" />
						</li>
					</xsl:for-each>
				</ul>
			
			</xsl:for-each>
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
