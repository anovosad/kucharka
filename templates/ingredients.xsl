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
					<h1>Suroviny</h1>
				</header>
				
				<ul id="ingredients">
				<xsl:for-each select="category">
					<li>
						<xsl:choose>
							<xsl:when test="//login">
								<xsl:call-template name="move-icon">
									<xsl:with-param name="action" select="concat($BASE, '/kategorie/', @id)" />
									<xsl:with-param name="direction" select="-1" />
								</xsl:call-template>
								<xsl:call-template name="move-icon">
									<xsl:with-param name="action" select="concat($BASE, '/kategorie/', @id)" />
									<xsl:with-param name="direction" select="1" />
								</xsl:call-template>
								<a href="{concat($BASE, '/kategorie/', @id)}"><xsl:value-of select="@name" /></a>
							</xsl:when>
							
							<xsl:otherwise>
								<span><xsl:value-of select="@name" /></span>
								<ul>
									<xsl:for-each select="ingredient">
										<li>
											<a href="{concat($BASE, '/surovina/', @id)}">
												<xsl:if test="@image = '1'"><xsl:attribute name="class">image</xsl:attribute></xsl:if>
												<xsl:value-of select="@name" />
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
				</ul>
				<xsl:call-template name="footer" />
			</div>
			
			<script type="text/javascript" src="{concat($BASE, '/js/toggle.js')}"></script>
			<script type="text/javascript">Toggle.init(OZ.$("ingredients"));</script>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
