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

		<body id="recipe">
			<div id="wrap">
				<xsl:for-each select="recipe">

				<header>
					<xsl:call-template name="menu" /> 
					<h1><xsl:value-of select="@name" /></h1>
				</header>
				
				<p>
					Druh: <a href="{concat($BASE, '/druh/', @id_type)}"><xsl:value-of select="@name_type" /></a>,
					Autor: <a href="{concat($BASE, '/autor/', @id_user)}"><xsl:value-of select="@name_user" /></a>
				</p>
				
				<p>Čas na přípravu: <xsl:value-of select="@time" /> minut</p>
				
				<xsl:if test="@image = 1">
					<p>
					<xsl:call-template name="image">
						<xsl:with-param name="path" select="'recipes'" />
					</xsl:call-template>
					</p>
				</xsl:if>
				
				<div id="ingredients">
					<h2>Ingredience</h2>
					<p>(<xsl:value-of select="@amount" />)</p>
					<table>
						<tbody>
						<xsl:for-each select="ingredient">
							<tr>
								<td><xsl:value-of select="@amount" /></td>
								<td><a href="{concat($BASE, '/surovina/', @id_ingredient)}"><xsl:value-of select="@name" /></a></td>
							</tr>
						</xsl:for-each>
						</tbody>
					</table>
				</div>
				
				<div id="text">
					<h2>
						<span id="print">
							<img src="{concat($IMAGE_PATH, '/icons/printer.png')}" alt="tisk" title="Tisk" />
						</span>
						Postup
					</h2>
					<p><xsl:call-template name="rich-text"><xsl:with-param name="text" select="text" /></xsl:call-template></p>
					
					<xsl:if test="remark">
						<h2>Poznámka</h2>
						<p><xsl:call-template name="rich-text"><xsl:with-param name="text" select="remark" /></xsl:call-template></p>
					</xsl:if>
				</div>


				</xsl:for-each>
				<xsl:call-template name="footer" />
			</div>
			
			<script type="text/javascript">
				OZ.$("text").style.marginLeft = OZ.$("ingredients").offsetWidth + "px";
				OZ.Event.add(OZ.$("print"), "click", function(e) { window.print(); });
			</script>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
