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
			<xsl:for-each select="user">
				<h1><xsl:value-of select="@name" /></h1>
				
				<xsl:if test="//login">
					<xsl:if test="@canEdit = 1">
						<a href="{concat($BASE, '/autor/', @id, '?edit=1')}">upravit</a>
					</xsl:if>
					<xsl:if test="@canDelete = 1">
						<form method="post" action="{concat($BASE, '/autor/', @id)}">
							<input type="hidden" name="http-method" value="delete" />
							<input type="submit" value="smazat" />
						</form>
					</xsl:if>
				</xsl:if>
			
			</xsl:for-each>
			

			<xsl:call-template name="recipe-list" />
			
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
