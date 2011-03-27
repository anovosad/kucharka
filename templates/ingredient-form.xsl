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
				<xsl:for-each select="ingredient">
				<xsl:variable name="id_category" select="@id_category" />

				<header>
					<xsl:call-template name="menu" /> 
					<h1>
						<xsl:value-of select="@name" />
						<xsl:if test="not(@name)">Nová surovina</xsl:if>
					</h1>
				</header>
				
				
				<form method="post" action="{concat($BASE, '/surovina/', @id)}" enctype="multipart/form-data">
					<table>
						<tbody>
							<tr>
								<td>Název</td>
								<td><input type="text" name="name" value="{@name}" /></td>
							</tr>
							<tr>
								<td>Kategorie</td>
								<td>
									<xsl:for-each select="//categories">
										<xsl:call-template name="category-select">
											<xsl:with-param name="id_category" select="$id_category" />
										</xsl:call-template>
									</xsl:for-each>
								</td>
							</tr>
							<tr>
								<td>Popis</td>
								<td><textarea name="description"><xsl:value-of select="@description" /></textarea></td>
							</tr>
							<tr>
								<td>Obrázek</td>
								<td>
									<xsl:call-template name="image-form">
										<xsl:with-param name="path" select="'ingredients'" />
										<xsl:with-param name="width" select="0" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><input type="submit" value="Uložit" /></td>
							</tr>
						</tbody>
					</table>
				</form>
				
				</xsl:for-each>
				
				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
