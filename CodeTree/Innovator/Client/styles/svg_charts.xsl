<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" >
	<!-- svg_charts.xls -->
	<!-- Transforms xml input to an SVG Chart -->
	<!-- (c) Copyright by Aras Corporation, 2004-2008. -->
	<xsl:output method="xml" encoding="utf-8"/>
	<xsl:strip-space elements="path"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="palette">
		<svg x="0" y="0" width="100%" height="100%">
			<xsl:attribute name="viewBox"><xsl:value-of select="concat('0 0 ',@width,' ',@height)"/></xsl:attribute>
			<!-- Set up filtering effects (should be pulled out into separate file) -->
			<defs>									
				<filter id="svgf">					
					<feGaussianBlur in="SourceAlpha" stdDeviation="1.5" result="blur"/>
					<feOffset in="blur" dx="1" dy="1" result="offsetBlur"/>
					<feSpecularLighting in="blur" surfaceScale="5" specularConstant="1" specularExponent="10" lighting-color="white" result="specOut">
						<fePointLight x="-5000" y="-10000" z="20000"/>
					</feSpecularLighting>
					<feComposite in="specOut" in2="SourceAlpha" operator="in" result="specOut"/>
					<feComposite in="SourceGraphic" in2="specOut" operator="arithmetic" k1="0" k2="1" k3="1" k4="0" result="litPaint"/>
					<feMerge>
						<feMergeNode in="offsetBlur"/>
						<feMergeNode in="litPaint"/>
					</feMerge>
				</filter>
				
				<!-- Start Custom Fill Patterns -->
				<pattern id="pattern-stripe" width="4" height="4" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
				  <rect width="2" height="4" transform="translate(0,0)" fill="white"/>
				</pattern>
				<mask id="mask-stripe">
				  <rect x="0" y="0" width="100%" height="100%" fill="url(#pattern-stripe)"/>
				</mask>
				
				<pattern id="pattern-dots" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
				  <circle cx="1" cy="1" r="1" fill="white"/>
				</pattern>
				<mask id="mask-dots">
				  <rect x="0" y="0" width="100%" height="100%" fill="url(#pattern-dots)"/>
				</mask>
				<!-- End Custom Fill Patterns -->
				
				
				<style type="text/css"><![CDATA[
      rect.background {fill: #FFFFFF;}
	  
      rect.bar {stroke-width: .2; stroke: white; opacity: .7;}
	  rect.bar:hover {stroke-width: .2; stroke: white; opacity: .9;}
	  
      rect.legend {stroke-width: 2; stroke: #222222; opacity: .5; fill: #DDDDDD;}
	  
      rect.marker {opacity: .5;}
	  rect.marker:hover {opacity: .8;}
	  
      line.xAxis {stroke-width: .5; stroke: #AAAAAA;}
      line.yAxis {stroke-width: .5; stroke: #AAAAAA;}
      line.grid{stroke-width: .1; stroke: #DDDDDD;}
      line.line{opacity: .5;}
      text.title{font-size: 22; fill: #555555; text-anchor: middle; baseline-shift: -35%;}
      text.xAxisLabel{font-size: 16; fill: #555555; text-anchor: middle; baseline-shift: -35%;}
      text.yAxisLabel{font-size: 16; fill: #555555; text-anchor: middle; baseline-shift: -35%;}
      text.xValueLabel{font-size: 13; fill: #555555; text-anchor: start; writing-mode: tb;}
      text.yValueLabel{font-size: 12; fill: #555555; text-anchor: end; baseline-shift: -35%;}
      text.pieValueLabel{font-size: 13; fill: #555555; text-anchor: start;}
      text.legend{font-size: 16; fill: #555555; text-anchor: start; baseline-shift: -35%;}

     ]]></style>
			</defs>
			<!-- Window background -->
			<rect class="background">
				<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="@background-style"/></xsl:attribute>
			</rect>
			<xsl:apply-templates/>
		</svg>
	</xsl:template>
	<xsl:template match="chart">
		<xsl:variable name="borderLeft">
			<xsl:choose>
				<xsl:when test="@border-left != ''">
					<xsl:value-of select="@border-left"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@width * .1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="borderRight">
			<xsl:choose>
				<xsl:when test="@border-right != ''">
					<xsl:value-of select="@border-right"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@width * .1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="borderTop">
			<xsl:choose>
				<xsl:when test="@border-top != ''">
					<xsl:value-of select="@border-top"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@height * .15"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="borderBottom">
			<xsl:choose>
				<xsl:when test="@border-bottom != ''">
					<xsl:value-of select="@border-bottom"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@height * .2"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="minYValue">
			<xsl:choose>
				<xsl:when test="@type='stacked-bar'">
					<xsl:call-template name="getStackedMin">
						<xsl:with-param name="nodes" select="./series"/>
						<xsl:with-param name="currentPosition">1</xsl:with-param>
						<xsl:with-param name="currentMin">999999</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="math.min">
						<xsl:with-param name="nodes" select="./series/datum/@y-value"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="maxYValue">
			<xsl:choose>
				<xsl:when test="@type='stacked-bar'">
					<xsl:call-template name="getStackedMax">
						<xsl:with-param name="nodes" select="./series"/>
						<xsl:with-param name="currentPosition">1</xsl:with-param>
						<xsl:with-param name="currentMax">0</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="math.max">
						<xsl:with-param name="nodes" select="./series/datum/@y-value"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="yMultiplier">
			<xsl:choose>
				<xsl:when test="($maxYValue &gt; ($minYValue * -1)) and ($maxYValue &gt; 0)">
					<xsl:call-template name="getMultiplier">
						<xsl:with-param name="currentValue">
							<xsl:value-of select="$maxYValue"/>
						</xsl:with-param>
						<xsl:with-param name="multiplier">
							<xsl:value-of select="1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getMultiplier">
						<xsl:with-param name="originalValue">
							<xsl:value-of select="$minYValue"/>
						</xsl:with-param>
						<xsl:with-param name="multiplier">
							<xsl:value-of select="1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="yMin">
			<xsl:choose>
				<xsl:when test="@y-min != ''">
					<xsl:value-of select="@y-min"/>
				</xsl:when>
				<xsl:when test="$yMultiplier &lt; 0">
					<xsl:value-of select="ceiling($minYValue * $yMultiplier div 10) div $yMultiplier * 10"/>
				</xsl:when>
				<xsl:when test="$minYValue &gt;= 0">0</xsl:when>
				<xsl:when test="($yMultiplier * $minYValue) &gt; -10">
					<xsl:value-of select="-10 div $yMultiplier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor($minYValue * $yMultiplier div 10) div $yMultiplier * 10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="yMax">
			<xsl:choose>
				<xsl:when test="@y-max != ''">
					<xsl:value-of select="@y-max"/>
				</xsl:when>
				<xsl:when test="$yMultiplier &gt; 0">
					<xsl:value-of select="ceiling($maxYValue * $yMultiplier div 10) div $yMultiplier * 10"/>
				</xsl:when>
				<xsl:when test="$maxYValue &lt;= 0">0</xsl:when>
				<xsl:when test="($yMultiplier * $maxYValue) &gt; -10">
					<xsl:value-of select="-10 div $yMultiplier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="ceiling($maxYValue * $yMultiplier div -10) div $yMultiplier * -10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="yScaleFactor">
			<xsl:value-of select="(@height - $borderTop - $borderBottom) div ($yMax - $yMin)"/>
		</xsl:variable>
		<xsl:variable name="yInterval">
			<xsl:choose>
				<xsl:when test="@y-grid-interval != ''">
					<xsl:value-of select="@y-grid-interval"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="10 div $yMultiplier"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="xAxisPosition">
			<xsl:value-of select="@height - $borderBottom - $yMin * $yScaleFactor * -1"/>
		</xsl:variable>
		<xsl:variable name="markerSize">
			<xsl:choose>
				<xsl:when test="@marker-size != ''">
					<xsl:value-of select="@marker-size"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@height * .03"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<svg>
			<xsl:attribute name="x"><xsl:value-of select="@x"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="@y"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
			<!-- Chart background -->
			<rect x="0" y="0" class="background">
				<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="@background-style"/></xsl:attribute>
			</rect>
			<!-- Chart title -->
			<text class="title">
				<xsl:attribute name="x"><xsl:value-of select="(@width - $borderLeft - $borderRight) div 2 + $borderLeft"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$borderTop div 2"/></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="@title-style"/></xsl:attribute>
				<xsl:value-of select="@title"/>
			</text>
			<!-- Draw x axis -->
			<xsl:if test="not(@x-axis='0' or translate(@x-axis,'FALSE','false')='false' or @type='pie' or @type='radar')">
				<line class="xAxis">
					<xsl:attribute name="x1"><xsl:value-of select="$borderLeft"/></xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="$xAxisPosition"/></xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="@width - $borderRight"/></xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="$xAxisPosition"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="@x-axis-style"/></xsl:attribute>
				</line>
			</xsl:if>
			<!-- X axis label -->
			<text class="xAxisLabel">
				<xsl:attribute name="x"><xsl:value-of select="(@width - $borderLeft - $borderRight) div 2 + $borderLeft"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="@height - $borderBottom * .2"/></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="@x-axis-label-style"/></xsl:attribute>
				<xsl:value-of select="@x-axis-label"/>
			</text>
			<!-- Draw y axis -->
			<xsl:if test="not(@y-axis='0' or translate(@y-axis,'FALSE','false')='false' or @type='pie' or @type='radar')">
				<line class="yAxis">
					<xsl:attribute name="x1"><xsl:value-of select="$borderLeft"/></xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="$borderTop - 1"/></xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="$borderLeft"/></xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="@height - $borderBottom"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="@y-axis-style"/></xsl:attribute>
				</line>
			</xsl:if>
			<!-- Y axis label -->
			<text class="yAxisLabel">
				<xsl:attribute name="transform">translate(<xsl:value-of select="$borderLeft * .2"/>,<xsl:value-of select="(@height - $borderBottom - $borderTop) div 2 + $borderTop"/>) rotate(270)</xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="@y-axis-label-style"/></xsl:attribute>
				<xsl:value-of select="@y-axis-label"/>
			</text>
			<!-- Draw y grid -->
			<xsl:if test="not(@y-grid='0' or translate(@y-grid,'FALSE','false')='false' or @type='pie' or @type='radar')">
				<xsl:call-template name="drawYGrid">
					<xsl:with-param name="currentValue">
						<xsl:value-of select="$yMin"/>
					</xsl:with-param>
					<xsl:with-param name="yInterval">
						<xsl:value-of select="$yInterval"/>
					</xsl:with-param>
					<xsl:with-param name="yMax">
						<xsl:value-of select="$yMax"/>
					</xsl:with-param>
					<xsl:with-param name="yMultiplier">
						<xsl:value-of select="$yMultiplier"/>
					</xsl:with-param>
					<xsl:with-param name="borderLeft">
						<xsl:value-of select="$borderLeft"/>
					</xsl:with-param>
					<xsl:with-param name="borderRight">
						<xsl:value-of select="$borderRight"/>
					</xsl:with-param>
					<xsl:with-param name="chartWidth">
						<xsl:value-of select="@width"/>
					</xsl:with-param>
					<xsl:with-param name="xAxisPosition">
						<xsl:value-of select="$xAxisPosition"/>
					</xsl:with-param>
					<xsl:with-param name="yScaleFactor">
						<xsl:value-of select="$yScaleFactor"/>
					</xsl:with-param>
					<xsl:with-param name="yAxisValueLabels">
						<xsl:value-of select="@y-axis-value-labels"/>
					</xsl:with-param>
					<xsl:with-param name="yAxisValueLabelStyle">
						<xsl:value-of select="@y-axis-value-label-style"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<!-- Draw legend box -->
			<xsl:if test="@legend='1' or translate(@legend,'TRUE','true')='true'">
				<rect class="legend">
					<xsl:attribute name="x"><xsl:value-of select="@legend-x"/></xsl:attribute>
					<xsl:attribute name="y"><xsl:value-of select="@legend-y"/></xsl:attribute>
					<xsl:attribute name="width"><xsl:value-of select="@legend-width"/></xsl:attribute>
					<xsl:attribute name="height"><xsl:value-of select="@legend-height"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="@legend-box-style"/></xsl:attribute>
				</rect>
			</xsl:if>
			<!-- Display Series -->
			<xsl:apply-templates select="series">
				<xsl:with-param name="borderTop">
					<xsl:value-of select="$borderTop"/>
				</xsl:with-param>
				<xsl:with-param name="borderBottom">
					<xsl:value-of select="$borderBottom"/>
				</xsl:with-param>
				<xsl:with-param name="borderLeft">
					<xsl:value-of select="$borderLeft"/>
				</xsl:with-param>
				<xsl:with-param name="borderRight">
					<xsl:value-of select="$borderRight"/>
				</xsl:with-param>
				<xsl:with-param name="xAxisPosition">
					<xsl:value-of select="$xAxisPosition"/>
				</xsl:with-param>
				<xsl:with-param name="yScaleFactor">
					<xsl:value-of select="$yScaleFactor"/>
				</xsl:with-param>
				<xsl:with-param name="markerSize">
					<xsl:value-of select="$markerSize"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</svg>
	</xsl:template>
	<xsl:template match="chart/series">
		<xsl:param name="borderTop"/>
		<xsl:param name="borderBottom"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:param name="xAxisPosition"/>
		<xsl:param name="yScaleFactor"/>
		<xsl:param name="markerSize"/>
		<xsl:variable name="seriesColor">
			<xsl:value-of select="@color"/>
		</xsl:variable>
		<xsl:variable name="seriesPattern">
			<xsl:value-of select="@pattern"/>
		</xsl:variable>
		<xsl:apply-templates select="./datum">
			<xsl:with-param name="borderTop">
				<xsl:value-of select="$borderTop"/>
			</xsl:with-param>
			<xsl:with-param name="borderBottom">
				<xsl:value-of select="$borderBottom"/>
			</xsl:with-param>
			<xsl:with-param name="borderLeft">
				<xsl:value-of select="$borderLeft"/>
			</xsl:with-param>
			<xsl:with-param name="borderRight">
				<xsl:value-of select="$borderRight"/>
			</xsl:with-param>
			<xsl:with-param name="xAxisPosition">
				<xsl:value-of select="$xAxisPosition"/>
			</xsl:with-param>
			<xsl:with-param name="yScaleFactor">
				<xsl:value-of select="$yScaleFactor"/>
			</xsl:with-param>
			<xsl:with-param name="seriesColor">
				<xsl:value-of select="$seriesColor"/>
			</xsl:with-param>
			<xsl:with-param name="seriesPattern">
				<xsl:value-of select="$seriesPattern"/>
			</xsl:with-param>
			<xsl:with-param name="seriesIndex">
				<xsl:value-of select="position()"/>
			</xsl:with-param>
			<xsl:with-param name="markerSize">
				<xsl:value-of select="$markerSize"/>
			</xsl:with-param>
			<xsl:sort select="@x-value" data-type="number"/>
		</xsl:apply-templates>
		<!-- Legend -->
		<xsl:if test="../@legend='1' or translate(../@legend,'TRUE','true')='true'">
			<xsl:variable name="lineHeight">
				<xsl:value-of select="(../@legend-height * .9 div count(../series))"/>
			</xsl:variable>
			<g filter="url(#svgf)">
				<rect>
					<xsl:attribute name="x"><xsl:value-of select="../@legend-x + ../@legend-width div 20"/></xsl:attribute>
					<xsl:attribute name="y"><xsl:value-of select="../@legend-y + ../@legend-height div 20 + $lineHeight * (position() -1) + $lineHeight div 2 - $markerSize div 2"/></xsl:attribute>
					<xsl:attribute name="width"><xsl:value-of select="$markerSize"/></xsl:attribute>
					<xsl:attribute name="height"><xsl:value-of select="$markerSize"/></xsl:attribute>
					<xsl:attribute name="fill"><xsl:value-of select="$seriesColor"/></xsl:attribute>
				</rect>
			</g>
			<text class="legend">
				<xsl:attribute name="x"><xsl:value-of select="../@legend-x + ../@legend-width div 10 + $markerSize"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="../@legend-y + ../@legend-height div 20 + $lineHeight * (position() -1) + $lineHeight div 2"/></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="../@legend-text-style"/></xsl:attribute>
				<xsl:value-of select="@label"/>
			</text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="chart[@type='bar']/series/datum">
		<xsl:param name="borderTop"/>
		<xsl:param name="borderBottom"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:param name="xAxisPosition"/>
		<xsl:param name="yScaleFactor"/>
		<xsl:param name="seriesPattern"/>
		<xsl:param name="seriesIndex"/>
		<xsl:variable name="barSpacing">
			<xsl:choose>
				<xsl:when test="../../@bar-spacing = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../../@bar-spacing"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="barWidth">
			<xsl:value-of select="(../../@width - $borderLeft - $borderRight) div count(../datum) div count(../../series) - ($barSpacing div 2)"/>
		</xsl:variable>
		<g filter="url(#svgf)">
			<a>
				<xsl:attribute name="xlink:href"><xsl:value-of select="@link"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$seriesPattern = 'Dotted'">
						<rect class="bar" mask= "url(#mask-dots)">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div count(../datum)) * (position() - 1) + ($seriesIndex -1) * $barWidth + $barSpacing div 2 + $borderLeft"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="$xAxisPosition - @y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="$xAxisPosition"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="$barWidth"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="@y-value * $yScaleFactor * -1"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="fill"><xsl:choose><xsl:when test="count(../../series) &gt; 1"><xsl:value-of select="../@color"/></xsl:when><xsl:otherwise><xsl:value-of select="@color"/></xsl:otherwise></xsl:choose></xsl:attribute>					
						</rect>
					</xsl:when>
					<xsl:when test="$seriesPattern = 'Stripe'">
						<rect class="bar" mask= "url(#mask-stripe)">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div count(../datum)) * (position() - 1) + ($seriesIndex -1) * $barWidth + $barSpacing div 2 + $borderLeft"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="$xAxisPosition - @y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="$xAxisPosition"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="$barWidth"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="@y-value * $yScaleFactor * -1"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="fill"><xsl:choose><xsl:when test="count(../../series) &gt; 1"><xsl:value-of select="../@color"/></xsl:when><xsl:otherwise><xsl:value-of select="@color"/></xsl:otherwise></xsl:choose></xsl:attribute>					
						</rect>
					</xsl:when>
					<xsl:otherwise>
						<rect class="bar">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div count(../datum)) * (position() - 1) + ($seriesIndex -1) * $barWidth + $barSpacing div 2 + $borderLeft"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="$xAxisPosition - @y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="$xAxisPosition"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="$barWidth"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:choose><xsl:when test="@y-value &gt; 0"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:when><xsl:otherwise><xsl:value-of select="@y-value * $yScaleFactor * -1"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="fill"><xsl:choose><xsl:when test="count(../../series) &gt; 1"><xsl:value-of select="../@color"/></xsl:when><xsl:otherwise><xsl:value-of select="@color"/></xsl:otherwise></xsl:choose></xsl:attribute>					
						</rect>
					</xsl:otherwise>
			    </xsl:choose>
				
			</a>
		</g>
		<!-- X axis value labels -->
		<xsl:if test="not(../../@x-axis-value-labels='0' or translate(../../@x-axis-value-labels,'FALSE','false')='false')">
			<text class="xValueLabel">
				<xsl:attribute name="transform">translate(<xsl:value-of select="(../../@width - $borderLeft - $borderRight) div count(../datum) * (position() - .5) + $borderLeft"/>,<xsl:value-of select="../../@height - $borderBottom * .9"/>)</xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="../../@x-axis-value-label-style"/></xsl:attribute>
				<xsl:value-of select="@label"/>
			</text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="chart[@type='stacked-bar']/series/datum">
		<xsl:param name="borderTop"/>
		<xsl:param name="borderBottom"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:param name="xAxisPosition"/>
		<xsl:param name="yScaleFactor"/>
		<xsl:param name="seriesColor"/>
		<xsl:param name="seriesPattern"/>
		<xsl:param name="seriesIndex"/>
		<xsl:variable name="datumPos">
			<xsl:value-of select="position()"/>
		</xsl:variable>
		<xsl:variable name="bottomValue">
			<xsl:value-of select="sum(../../series[position() &lt; $seriesIndex]/datum[(position()-1) mod count(../datum) = $datumPos - 1]/@y-value)"/>
		</xsl:variable>
		<xsl:variable name="datumCount">
			<xsl:value-of select="count(../../series[1]/datum)"/>
		</xsl:variable>
		<xsl:variable name="barSpacing">
			<xsl:choose>
				<xsl:when test="../../@bar-spacing = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../../@bar-spacing"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<g filter="url(#svgf)">
			<a>
				<xsl:attribute name="xlink:href"><xsl:value-of select="@link"/></xsl:attribute>					
				<xsl:choose>
					<xsl:when test="$seriesPattern = 'Dotted'">
						<rect class="bar" mask= "url(#mask-dots)">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div $datumCount) * (position() - 1) + $borderLeft + $barSpacing div 2"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:value-of select="$xAxisPosition - (@y-value + $bottomValue) * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="(../../@width - $borderLeft - $borderRight) div $datumCount - $barSpacing"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="fill"><xsl:value-of select="$seriesColor"/></xsl:attribute>					
						</rect>
					</xsl:when>
					<xsl:when test="$seriesPattern = 'Stripe'">
						<rect class="bar" mask= "url(#mask-stripe)">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div $datumCount) * (position() - 1) + $borderLeft + $barSpacing div 2"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:value-of select="$xAxisPosition - (@y-value + $bottomValue) * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="(../../@width - $borderLeft - $borderRight) div $datumCount - $barSpacing"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="fill"><xsl:value-of select="$seriesColor"/></xsl:attribute>					
						</rect>
					</xsl:when>
					<xsl:otherwise>
						<rect class="bar">
							<xsl:attribute name="x"><xsl:value-of select="((../../@width - $borderLeft - $borderRight) div $datumCount) * (position() - 1) + $borderLeft + $barSpacing div 2"/></xsl:attribute>
							<xsl:attribute name="y"><xsl:value-of select="$xAxisPosition - (@y-value + $bottomValue) * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="width"><xsl:value-of select="(../../@width - $borderLeft - $borderRight) div $datumCount - $barSpacing"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:value-of select="@y-value * $yScaleFactor"/></xsl:attribute>
							<xsl:attribute name="fill"><xsl:value-of select="$seriesColor"/></xsl:attribute>					
						</rect>
					</xsl:otherwise>
			    </xsl:choose>				
			</a>
		</g>
		<!-- X axis value labels -->
		<xsl:if test="$seriesIndex = 1">
			<xsl:if test="not(../../@x-axis-value-labels='0' or translate(../../@x-axis-value-labels,'FALSE','false')='false')">
				<text class="xValueLabel">
					<xsl:attribute name="transform">translate(<xsl:value-of select="(../../@width - $borderLeft - $borderRight) div count(../datum) * (position() - .5) + $borderLeft"/>,<xsl:value-of select="../../@height - $borderBottom * .9"/>)</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="../../@x-axis-value-label-style"/></xsl:attribute>
					<xsl:value-of select="@label"/>
				</text>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="chart[@type='line']/series/datum">
		<xsl:param name="borderTop"/>
		<xsl:param name="borderBottom"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:param name="xAxisPosition"/>
		<xsl:param name="yScaleFactor"/>
		<xsl:param name="seriesColor"/>
		<xsl:param name="markerSize"/>
		<xsl:variable name="unitWidth">
			<xsl:value-of select="(../../@width - $borderLeft - $borderRight) div (count(../../series[1]/datum) -1)"/>
		</xsl:variable>
		<a>
			<xsl:attribute name="xlink:href"><xsl:value-of select="../@link"/></xsl:attribute>
			<xsl:if test="position() != 1">
				<line class="line">
					<xsl:attribute name="x1"><xsl:value-of select="$unitWidth * (position() - 1) + $borderLeft"/></xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="$xAxisPosition - @y-value * $yScaleFactor"/></xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="$unitWidth * (position() - 2) + $borderLeft"/></xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="$xAxisPosition - preceding-sibling::datum[1]/@y-value * $yScaleFactor"/></xsl:attribute>
					<xsl:attribute name="stroke"><xsl:value-of select="$seriesColor"/></xsl:attribute>
					<xsl:attribute name="stroke-width"><xsl:value-of select="$markerSize div 4"/></xsl:attribute>
				</line>
			</xsl:if>
		</a>
		<xsl:if test="../@markers = '1'">
			<g filter="url(#svgf)">
				<a>
					<xsl:attribute name="xlink:href"><xsl:value-of select="@link"/></xsl:attribute>
					<rect class="marker">
						<xsl:attribute name="x"><xsl:value-of select="$unitWidth * (position() - 1) + $borderLeft - $markerSize div 2"/></xsl:attribute>
						<xsl:attribute name="y"><xsl:value-of select="$xAxisPosition - @y-value * $yScaleFactor - $markerSize div 2"/></xsl:attribute>
						<xsl:attribute name="width"><xsl:value-of select="$markerSize"/></xsl:attribute>
						<xsl:attribute name="height"><xsl:value-of select="$markerSize"/></xsl:attribute>
						<xsl:attribute name="fill"><xsl:value-of select="$seriesColor"/></xsl:attribute>
					</rect>
				</a>
			</g>
		</xsl:if>
		<!-- X axis value labels -->
		<xsl:if test="not(../../@x-axis-value-labels='0' or translate(../../@x-axis-value-labels,'FALSE','false')='false')">
			<text class="xValueLabel">
				<xsl:attribute name="transform">translate(<xsl:value-of select="$unitWidth * (position() - 1) + $borderLeft"/>,<xsl:value-of select="../../@height - $borderBottom * .9"/>)</xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="../../@x-axis-value-label-style"/></xsl:attribute>
				<xsl:value-of select="@label"/>
			</text>
		</xsl:if>
		<!-- X axis tick marks -->
		<line class="grid">
			<xsl:attribute name="x1"><xsl:value-of select="$unitWidth * (position() - 1) + $borderLeft"/></xsl:attribute>
			<xsl:attribute name="y1"><xsl:value-of select="$xAxisPosition - ../../@height div 100"/></xsl:attribute>
			<xsl:attribute name="x2"><xsl:value-of select="$unitWidth * (position() - 1) + $borderLeft"/></xsl:attribute>
			<xsl:attribute name="y2"><xsl:value-of select="$xAxisPosition + ../../@height div 100"/></xsl:attribute>
		</line>
	</xsl:template>
	<xsl:template match="chart[@type='pie']/series/datum">
		<xsl:param name="borderTop"/>
		<xsl:param name="borderBottom"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:variable name="cx">
			<xsl:value-of select="(../../@width - $borderLeft - $borderRight) div 2 + $borderLeft"/>
		</xsl:variable>
		<xsl:variable name="cy">
			<xsl:value-of select="(../../@height - $borderTop - $borderBottom) div 2 + $borderTop"/>
		</xsl:variable>
		<xsl:variable name="r">
			<xsl:choose>
				<xsl:when test="../../@radius != ''">
					<xsl:value-of select="../../@radius"/>
				</xsl:when>
				<xsl:when test="(../../@width - $borderRight - $borderLeft) &lt; (../../@height - $borderTop - $borderBottom)">
					<xsl:value-of select="(../../@width - $borderRight - $borderLeft) * .45"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(../../@height - $borderTop - $borderBottom) * .45"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text-r">
			<xsl:value-of select="$r + 10"/>
		</xsl:variable>
		<xsl:variable name="thisPos">
			<xsl:value-of select="position()"/>
		</xsl:variable>
		<xsl:variable name="startAngle">
			<xsl:value-of select="number(@startAngle)"/>
		</xsl:variable>
		<xsl:variable name="endAngle">
			<xsl:value-of select="number(@endAngle)"/>
		</xsl:variable>
		<xsl:variable name="startSin">
			<xsl:value-of select="number(@startSin)"/>
		</xsl:variable>
		<xsl:variable name="startCos">
			<xsl:value-of select="number(@startCos)"/>
		</xsl:variable>
		<xsl:variable name="endSin">
			<xsl:value-of select="number(@endSin)"/>
		</xsl:variable>
		<xsl:variable name="endCos">
			<xsl:value-of select="number(@endCos)"/>
		</xsl:variable>
		<xsl:variable name="textSin">
			<xsl:value-of select="number(@textSin)"/>
		</xsl:variable>
		<xsl:variable name="textCos">
			<xsl:value-of select="number(@textCos)"/>
		</xsl:variable>
		<g filter="url(#svgf)">
			<a>
				<xsl:attribute name="xlink:href"><xsl:value-of select="@link"/></xsl:attribute>
				<path style="opacity: .5;">
					<xsl:attribute name="fill"><xsl:value-of select="@color"/></xsl:attribute>
					<xsl:attribute name="d"><xsl:text>M </xsl:text><xsl:value-of select="$cx"/>,<xsl:value-of select="$cy"/><xsl:text> L </xsl:text><xsl:value-of select="$cx + $r * $startCos"/>,<xsl:value-of select="$cy - $r * $startSin"/><xsl:text> A </xsl:text><xsl:value-of select="$r"/><xsl:text> </xsl:text><xsl:value-of select="$r"/><xsl:choose><xsl:when test="$endAngle &gt; ($startAngle + 180)"><xsl:text> 1 1 0 </xsl:text></xsl:when><xsl:otherwise><xsl:text> 0 0 0 </xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="$cx + $r * $endCos"/>,<xsl:value-of select="$cy - $r * $endSin"/><xsl:text> L </xsl:text><xsl:value-of select="$cx"/>,<xsl:value-of select="$cy"/><xsl:text> Z</xsl:text></xsl:attribute>
				</path>
			</a>
		</g>
		<text class="pieValueLabel">
			<xsl:attribute name="x"><xsl:value-of select="$cx + $text-r * $textCos"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="$cy - $text-r * $textSin"/></xsl:attribute>
			<xsl:attribute name="style"><xsl:value-of select="../../@x-axis-value-label-style"/><xsl:choose><xsl:when test="$textCos &lt; 0"> text-anchor: end;</xsl:when><xsl:otherwise> text-anchor: start;</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:value-of select="@label"/>
		</text>
	</xsl:template>
	<xsl:template match="svg">
		<xsl:copy>
			<xsl:copy-of select="."/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="drawYGrid">
		<!-- Draw grid lines and labels -->
		<xsl:param name="currentValue"/>
		<xsl:param name="yInterval"/>
		<xsl:param name="yMax"/>
		<xsl:param name="yMultiplier"/>
		<xsl:param name="borderLeft"/>
		<xsl:param name="borderRight"/>
		<xsl:param name="chartWidth"/>
		<xsl:param name="xAxisPosition"/>
		<xsl:param name="yScaleFactor"/>
		<xsl:param name="yAxisValueLabels"/>
		<xsl:param name="yAxisValueLabelStyle"/>
		<xsl:variable name="formatString">
			<xsl:choose>
				<xsl:when test="$yInterval &lt; 1">
					<xsl:text>0.</xsl:text>
					<xsl:value-of select="substring-after(translate($yInterval,'0123456789','#########'),'.')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($yInterval,'0123456789','#########')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="round($currentValue * $yMultiplier) div $yMultiplier &lt;= $yMax">
			<xsl:if test="$currentValue != 0">
				<line class="grid">
					<xsl:attribute name="x1"><xsl:value-of select="$borderLeft - 1"/></xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="$xAxisPosition - $currentValue * $yScaleFactor"/></xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="$chartWidth - $borderRight + 1"/></xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="$xAxisPosition - $currentValue * $yScaleFactor"/></xsl:attribute>
				</line>
				<xsl:if test="not($yAxisValueLabels='0' or translate($yAxisValueLabels,'FALSE','false')='false')">
					<text class="yValueLabel">
						<xsl:attribute name="x"><xsl:value-of select="$borderLeft * .9"/></xsl:attribute>
						<xsl:attribute name="y"><xsl:value-of select="$xAxisPosition - $currentValue * $yScaleFactor"/></xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$yAxisValueLabelStyle"/></xsl:attribute>
						<xsl:value-of select="format-number($currentValue,$formatString)"/>
					</text>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="drawYGrid">
				<xsl:with-param name="currentValue">
					<xsl:value-of select="$currentValue + $yInterval"/>
				</xsl:with-param>
				<xsl:with-param name="yInterval">
					<xsl:value-of select="$yInterval"/>
				</xsl:with-param>
				<xsl:with-param name="yMax">
					<xsl:value-of select="$yMax"/>
				</xsl:with-param>
				<xsl:with-param name="yMultiplier">
					<xsl:value-of select="$yMultiplier"/>
				</xsl:with-param>
				<xsl:with-param name="borderLeft">
					<xsl:value-of select="$borderLeft"/>
				</xsl:with-param>
				<xsl:with-param name="borderRight">
					<xsl:value-of select="$borderRight"/>
				</xsl:with-param>
				<xsl:with-param name="chartWidth">
					<xsl:value-of select="$chartWidth"/>
				</xsl:with-param>
				<xsl:with-param name="xAxisPosition">
					<xsl:value-of select="$xAxisPosition"/>
				</xsl:with-param>
				<xsl:with-param name="yScaleFactor">
					<xsl:value-of select="$yScaleFactor"/>
				</xsl:with-param>
				<xsl:with-param name="yAxisValueLabels">
					<xsl:value-of select="$yAxisValueLabels"/>
				</xsl:with-param>
				<xsl:with-param name="yAxisValueLabelStyle">
					<xsl:value-of select="$yAxisValueLabelStyle	"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getMultiplier">
		<xsl:param name="currentValue"/>
		<xsl:param name="multiplier"/>
		<xsl:variable name="absCurrent">
			<xsl:choose>
				<xsl:when test="$currentValue &lt; 0">
					<xsl:value-of select="$currentValue * -1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$absCurrent &lt;10">
				<xsl:call-template name="getMultiplier">
					<xsl:with-param name="currentValue">
						<xsl:value-of select="$absCurrent * 10"/>
					</xsl:with-param>
					<xsl:with-param name="multiplier">
						<xsl:value-of select="$multiplier * 10"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$absCurrent &gt; 100">
				<xsl:call-template name="getMultiplier">
					<xsl:with-param name="currentValue">
						<xsl:value-of select="$absCurrent div 10"/>
					</xsl:with-param>
					<xsl:with-param name="multiplier">
						<xsl:value-of select="$multiplier div 10"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$multiplier"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getStackedMin">
		<xsl:param name="nodes" select="/.."/>
		<xsl:param name="currentPosition"/>
		<xsl:param name="currentMin"/>
		<xsl:variable name="datumCount">
			<xsl:value-of select="count($nodes/../series[1]/datum)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$currentPosition &gt; $datumCount">
				<xsl:value-of select="$currentMin"/>
			</xsl:when>
			<xsl:when test="sum($nodes/datum[position() mod ($datumCount + 1) = $currentPosition]/@y-value) &lt; $currentMin">
				<xsl:call-template name="getStackedMin">
					<xsl:with-param name="nodes" select="$nodes"/>
					<xsl:with-param name="currentPosition">
						<xsl:value-of select="$currentPosition + 1"/>
					</xsl:with-param>
					<xsl:with-param name="currentMin">
						<xsl:value-of select="sum($nodes/datum[position() mod ($datumCount + 1) = $currentPosition]/@y-value)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getStackedMin">
					<xsl:with-param name="nodes" select="$nodes"/>
					<xsl:with-param name="currentPosition">
						<xsl:value-of select="$currentPosition + 1"/>
					</xsl:with-param>
					<xsl:with-param name="currentMin">
						<xsl:value-of select="$currentMin"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getStackedMax">
		<xsl:param name="nodes" select="/.."/>
		<xsl:param name="currentPosition"/>
		<xsl:param name="currentMax"/>
		<xsl:variable name="datumCount">
			<xsl:value-of select="count($nodes/../series[1]/datum)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$currentPosition &gt; $datumCount">
				<xsl:value-of select="$currentMax"/>
			</xsl:when>
			<xsl:when test="sum($nodes/datum[position() mod ($datumCount + 1) = $currentPosition]/@y-value) &gt; $currentMax">
				<xsl:call-template name="getStackedMax">
					<xsl:with-param name="nodes" select="$nodes"/>
					<xsl:with-param name="currentPosition">
						<xsl:value-of select="$currentPosition + 1"/>
					</xsl:with-param>
					<xsl:with-param name="currentMax">
						<xsl:value-of select="sum($nodes/datum[position() mod ($datumCount + 1) = $currentPosition]/@y-value)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getStackedMax">
					<xsl:with-param name="nodes" select="$nodes"/>
					<xsl:with-param name="currentPosition">
						<xsl:value-of select="$currentPosition + 1"/>
					</xsl:with-param>
					<xsl:with-param name="currentMax">
						<xsl:value-of select="$currentMax"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="math.min">
		<xsl:param name="nodes" select="/.."/>
		<xsl:choose>
			<xsl:when test="not($nodes)">
				<xsl:value-of select="number('NaN')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" order="ascending"/>
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="math.max">
		<xsl:param name="nodes" select="/.."/>
		<xsl:choose>
			<xsl:when test="not($nodes)">
				<xsl:value-of select="number('NaN')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" order="descending"/>
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
