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
			
			<h1>Výsledky vyhledávání</h1>
			
			<xsl:if test="not(recipe)">
				Nebyl nalezen žádný recept.
			</xsl:if>
			<xsl:call-template name="recipe-list" />

			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
