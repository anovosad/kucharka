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
	
</xsl:stylesheet>
