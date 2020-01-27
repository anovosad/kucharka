<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:g="http://base.google.com/cns/1.0">
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
			<div id="wrap" itemscope="itemscope" itemtype="https://schema.org/Recipe">
				<xsl:for-each select="recipe">

				<header>
					<xsl:call-template name="menu" /> 
					<h1 itemprop="name"><xsl:value-of select="@name" /></h1>
					<span class="noprint">
						<g:plusone size="medium"></g:plusone>
						<fb:like action="recommend" />
					</span>
				</header>
				
				<p class="noprint">
					Druh: <a href="{concat($BASE, '/druh/', @id_type)}"><span itemprop="recipeCategory"><xsl:value-of select="@name_type" /></span></a>,
					autor: <a itemprop="author" href="{concat($BASE, '/autor/', @id_user)}"><xsl:value-of select="@name_user" /></a>,
					přidáno <time itemprop="datePublished" datetime="{concat(@year, '-', format-number(@month, '00'), '-', @day)}">
						<xsl:value-of select="concat(@day, '. ', @month, '. ', @year)" />
					</time>
				</p>
				
				<p>Čas na přípravu: 
					<time itemprop="totalTime" datetime="{concat('PT', @time, 'M')}">
						<xsl:value-of select="@time" /> 
						minut
					</time>
					
				</p>
				
				<xsl:for-each select="//similar">
					<div class="noprint" id="similar">
						<h2>Podobné recepty</h2>
						<xsl:call-template name="recipe-list" />
					</div>
				</xsl:for-each>
				
				<xsl:if test="@image = 1">
					<p>
					<xsl:call-template name="image">
						<xsl:with-param name="path" select="'recipes'" />
					</xsl:call-template>
					</p>
				</xsl:if>
				
				<div id="ingredients">
					<h2>Ingredience</h2>
					<xsl:if test="@amount != ''">
						<p class="noprint">(<span itemprop="yield"><xsl:value-of select="@amount" /></span>)</p>
					</xsl:if>
					<table>
						<tbody>
						<xsl:for-each select="ingredient">
							<tr itemprop="recipeIngredient">
								<td><xsl:value-of select="@amount" /></td>
								<td><a href="{concat($BASE, '/surovina/', @id_ingredient)}">
									<span><xsl:value-of select="@name" /></span>
								</a></td>
							</tr>
						</xsl:for-each>
						</tbody>
					</table>
				</div>
				
				<div id="text">
					<h2>Postup</h2>
					<p itemprop="recipeInstructions"><xsl:call-template name="rich-text"><xsl:with-param name="text" select="text" /></xsl:call-template></p>
					
					<xsl:if test="remark != ''">
						<h2>Poznámka</h2>
						<p><xsl:call-template name="rich-text"><xsl:with-param name="text" select="remark" /></xsl:call-template></p>
					</xsl:if>
					
					<div id="print" title="Tisk"></div>
				</div>


				</xsl:for-each>
				<xsl:call-template name="footer" />
			</div>
			
			<script type="text/javascript">
				OZ.$("text").style.marginLeft = OZ.$("ingredients").offsetWidth + "px";
				OZ.Event.add(OZ.$("print"), "click", function(e) { window.print(); });
			</script>
			<script type="text/javascript" src="http://connect.facebook.net/cs_CZ/all.js#xfbml=1"></script>
			<script type="text/javascript" src="http://apis.google.com/js/plusone.js"></script>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
