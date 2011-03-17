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
			<xsl:for-each select="ingredient">

			<header>
				<xsl:call-template name="menu" /> 
				<h1><xsl:value-of select="@name" /></h1>
			</header>
			
			
			<xsl:if test="//login">
				<a href="{concat($BASE, '/surovina/', @id, '?edit=1')}">upravit</a>
				<form method="post" action="{concat($BASE, '/surovina/', @id)}">
					<input type="hidden" name="http-method" value="delete" />
					<input type="submit" value="smazat" />
				</form>
			</xsl:if>
			
			<p><xsl:value-of select="@description" /></p>
			
			<xsl:call-template name="image">
				<xsl:with-param name="path" select="'ingredients'" />
			</xsl:call-template>
			
			</xsl:for-each>
			
			<xsl:call-template name="recipe-list" />

			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
