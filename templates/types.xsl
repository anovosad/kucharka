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
					<h1>Druhy jídel</h1>
				</header>
				
				<ul id="types">
				<xsl:for-each select="type">
					<li>
						<xsl:choose>
							<xsl:when test="//login">
								<xsl:call-template name="move-icon">
									<xsl:with-param name="action" select="concat($BASE, '/druh/', @id)" />
									<xsl:with-param name="direction" select="-1" />
								</xsl:call-template>
								<xsl:call-template name="move-icon">
									<xsl:with-param name="action" select="concat($BASE, '/druh/', @id)" />
									<xsl:with-param name="direction" select="1" />
								</xsl:call-template>
								<a href="{concat($BASE, '/druh/', @id)}"><xsl:value-of select="@name" /></a>
							</xsl:when>
							
							<xsl:otherwise>
								<span><xsl:value-of select="@name" /> (<xsl:value-of select="@count" />)</span>
								<xsl:if test="recipe"><xsl:call-template name="recipe-list" /></xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
				</ul>
				
				<xsl:call-template name="footer" />
			</div>
			
			<script type="text/javascript" src="{concat($BASE, '/js/toggle.js')}"></script>
			<script type="text/javascript">Toggle.init(OZ.$("types"));</script>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
