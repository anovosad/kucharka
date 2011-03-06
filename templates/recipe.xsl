<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="BASE" />
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
			<h1>salala recept</h1>
			
			<xsl:call-template name="foot" />
		</body>
	</html>
	</xsl:template>
</xsl:stylesheet>
