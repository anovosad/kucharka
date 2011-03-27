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
				<header>
					<xsl:call-template name="menu" /> 
					<h1>Autoři receptů</h1>
				</header>
				
				<ul id="users">
					<xsl:for-each select="user">
						<li>
							<a href="{concat($BASE, '/autor/', @id)}">
								<xsl:call-template name="image"><xsl:with-param name="path" select="'users'" /></xsl:call-template>
								<xsl:if test="@image = 0"><img src="{concat($IMAGE_PATH, '/users/0.jpg')}" alt="empty" /></xsl:if>
							</a>
							
							<xsl:value-of select="@name" /> – 
							<a href="{concat($BASE, '/autor/', @id)}">
								<xsl:value-of select="@recipes" /> receptů
							</a>
						</li>
					</xsl:for-each>
				</ul>
				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
