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
			<h1>Druhy jídel</h1>
			
			<ul>
			<xsl:for-each select="type">
				<li>
					<xsl:value-of select="@name" />
					<xsl:call-template name="recipe-list" />
				</li>
			</xsl:for-each>
			</ul>
			
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
