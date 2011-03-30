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
			<div id="wrap">
				<xsl:for-each select="type">

				<header>
					<xsl:call-template name="menu" /> 
					<h1><xsl:value-of select="@name" /></h1>
				</header>
				
				<p><xsl:value-of select="@description" /></p>
				
				</xsl:for-each>
				
				<xsl:call-template name="recipe-list" />

				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
