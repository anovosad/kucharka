<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:param name="BASE" />
	<xsl:param name="DEBUG" />
	<xsl:param name="IMAGE_PATH" />
	
	<xsl:template name="head">
		<xsl:param name="title" select="''" />
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<link rel="stylesheet" href="{concat($BASE, '/css/cookbook.css')}" type="text/css" />
			<title>
				<xsl:if test="$title != ''">
					<xsl:value-of select="$title" />
					<xsl:text> – </xsl:text>
				</xsl:if>
				<xsl:text>Kuchařka</xsl:text>
			</title>
			<script type="text/javascript" src="{concat($BASE, '/js/oz.js')}"></script>
		</head>
	</xsl:template>
		
	<xsl:template name="footer">
		<footer>© jak cyp</footer>
		<xsl:if test="$DEBUG">
			<div id="debug">
				<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
				<xsl:copy-of select="/" />
				<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="recipe-link">
		<a href="{concat($BASE, '/recept/', @id)}">
			<xsl:if test="@image = '1'"><xsl:attribute name="class">image</xsl:attribute></xsl:if>
			<xsl:value-of select="@name" />
		</a>
	</xsl:template>
	
	<xsl:template name="recipe-list">
		<xsl:if test="recipe">
			<ul>
				<xsl:for-each select="recipe">
					<li>
						<xsl:call-template name="recipe-link" />
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template name="menu">
		<nav id="menu">
			<ul>
				<xsl:choose>
					<xsl:when test="login">
						<form action="{concat($BASE, '/logout')}" method="post">
							<input type="submit" value="logout" />
						</form>
					</xsl:when>
					<xsl:otherwise>
						<form action="{concat($BASE, '/login')}" method="get">
							<input type="submit" value="login" />
						</form>
					</xsl:otherwise>
				</xsl:choose> 
			</ul>
		</nav>
	</xsl:template>
	
	<xsl:template name="category-select">
		<xsl:param name="id_category" select="0" />
		<select name="id_category">
			<xsl:for-each select="category">
			<option value="{@id}">
				<xsl:if test="@id = $id_category">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name" />
			</option>
			</xsl:for-each>
		</select>
	</xsl:template>
	
	<xsl:template name="type-select">
		<xsl:param name="id_type" select="0" />
		<select name="id_type">
			<xsl:for-each select="type">
			<option value="{@id}">
				<xsl:if test="@id = $id_type">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name" />
			</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="ingredient-select">
		<xsl:param name="id_ingredient" select="0" />
		<select name="id_ingredient">
			<xsl:for-each select="category">
			<optgroup>
				<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:for-each select="ingredient">
				<option value="{@id}">
					<xsl:if test="@id = $id_ingredient">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@name" />
				</option>
				</xsl:for-each>
			</optgroup>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="image-form">
		<xsl:param name="width" select="0" />
		<xsl:param name="path" select="''" />
		
		<p>Obrázek musí být ve formátu JPG.
		<xsl:if test="$width">Bude zmenšen na šířku <xsl:value-of select="$width" /> pixelů.</xsl:if>
		</p>
		<xsl:call-template name="image">
			<xsl:with-param name="path" select="$path" />
		</xsl:call-template>
		<label>
			<input type="checkbox" name="image-delete" value="1" />
			Odstranit
		</label><br/>
		<input type="file" name="image" />
	</xsl:template>
	
	<xsl:template name="image">
		<xsl:param name="path" select="''" />
		<xsl:if test="@image = 1">
			<img src="{concat($IMAGE_PATH, '/', $path, '/', @id, '.jpg')}" alt="{@name}" />
			<br/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
