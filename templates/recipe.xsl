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
		<xsl:call-template name="head">
			<xsl:with-param name="title" select="recipe/@name" />
		</xsl:call-template>

		<body>
			<div id="wrap">
				<xsl:for-each select="recipe">

				<header>
					<xsl:call-template name="menu" /> 
					<h1><xsl:value-of select="@name" /></h1>
				</header>
				
				<xsl:if test="@canEdit = 1">
					<a href="{concat($BASE, '/recept/', @id, '?edit=1')}">upravit</a>
					<form method="post" action="{concat($BASE, '/recept/', @id)}">
						<input type="hidden" name="http-method" value="delete" />
						<input type="submit" value="smazat" />
					</form>
				</xsl:if>

				<p><xsl:call-template name="rich-text"><xsl:with-param name="text" select="text" /></xsl:call-template></p>
				<p><xsl:call-template name="rich-text"><xsl:with-param name="text" select="remark" /></xsl:call-template></p>

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
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
