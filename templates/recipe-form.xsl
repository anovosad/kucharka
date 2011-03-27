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
				<xsl:for-each select="recipe">

				<header>
					<xsl:call-template name="menu" /> 
					<h1>
						<xsl:value-of select="@name" />
						<xsl:if test="not(@name)">Nový recept</xsl:if>
					</h1>
				</header>

				<xsl:variable name="id_type" select="@id_type" />
				
				
				<form method="post" action="{concat($BASE, '/recept/', @id)}" enctype="multipart/form-data">
				<fieldset>
					<legend>Obecné</legend>
					<table>
						<tbody>
							<tr>
								<td>Název</td>
								<td><input type="text" name="name" value="{@name}" /></td>
							</tr>
							<tr>
								<td>Druh</td>
								<td>
									<xsl:for-each select="//types">
										<xsl:call-template name="type-select">
											<xsl:with-param name="id_type" select="$id_type" />
										</xsl:call-template>
									</xsl:for-each>
								</td>
							</tr>
							<tr>
								<td>Čas přípravy</td>
								<td><input type="text" name="time" value="{@time}" size="3" /> minut</td>
							</tr>
							<tr>
								<td>Množství</td>
								<td><input type="text" name="amount" value="{@amount}" /></td>
							</tr>
							<tr>
								<td>Hot Tip?</td>
								<td>
									<input type="checkbox">
										<xsl:if test="@hot_tip = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
									</input>
								</td>
							</tr>
							<tr>
								<td>Obrázek</td>
								<td>
									<xsl:call-template name="image-form">
										<xsl:with-param name="path" select="'recipes'" />
										<xsl:with-param name="width" select="300" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><input type="submit" value="Uložit" /></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<fieldset>
					<legend>Suroviny</legend>
					<table>
						<tbody id="ingredients">
							<xsl:for-each select="ingredient">
								<xsl:call-template name="ingredient-row">
									<xsl:with-param name="amount" select="@amount" />
									<xsl:with-param name="id_ingredient" select="@id_ingredient" />
								</xsl:call-template>
							</xsl:for-each>
							<xsl:call-template name="ingredient-row" />
							<tr>
								<td colspan="3">V tomto poli je možné suroviny vyhledávat pomocí vepsání jejich názvu.</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td><input type="submit" value="Uložit" /></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<fieldset>
					<legend>Příprava</legend>
					<table>
						<tbody>
							<tr>
								<td>Postup</td>
								<td><textarea rows="10" cols="70" name="text"><xsl:value-of select="text" /></textarea></td>
							</tr>
							<tr>
								<td>Poznámka</td>
								<td><textarea rows="5" cols="70" name="remark"><xsl:value-of select="remark" /></textarea></td>
							</tr>
							<tr>
								<td></td>
								<td><input type="submit" value="Uložit" /></td>
							</tr>
						</tbody>
					</table>
				</fieldset>

				</form>
				
				</xsl:for-each>
				
				<xsl:call-template name="footer" />

			</div>

			<script type="text/javascript" src="{concat($BASE, '/js/oz.js')}"></script>
			<script type="text/javascript" src="{concat($BASE, '/js/recipe.js')}"></script>
			<script type="text/javascript">Recipe.init(OZ.$("ingredients"));</script>
		</body>
	</html>

	</xsl:template>
	
	<xsl:template name="ingredient-row">
		<xsl:param name="amount" select="''" />
		<xsl:param name="id_ingredient" select="0" />
		<tr>
			<td>
				<xsl:for-each select="//categories">
				<xsl:call-template name="ingredient-select">
					<xsl:with-param name="id_ingredient" select="$id_ingredient" />
				</xsl:call-template>
				</xsl:for-each>
			</td>
			<td><input type="text" name="ingredient_amount[]" value="{$amount}" /></td>
			<td>
				<input type="button">
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="$id_ingredient = 0">Přidat</xsl:when>
							<xsl:otherwise>Odebrat</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
			</td>
		</tr>
	</xsl:template>
	
	
</xsl:stylesheet>
