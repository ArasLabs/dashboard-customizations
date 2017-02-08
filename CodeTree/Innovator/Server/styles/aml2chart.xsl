<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">
	<!-- aml2chart.xls -->
	<!-- Transforms AML input to a charting format  -->
	<!-- (c) Copyright by Aras Corporation, 2004-2008. -->
	<xsl:template match="/">
		<xsl:apply-templates select="/*[local-name()='Envelope']/*[local-name()='Body']/Result/Item"/>
	</xsl:template>
	<xsl:template match="Item[@type='Dashboard']">
		<palette>
			<xsl:attribute name="width"><xsl:value-of select="width"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="height"/></xsl:attribute>
			<xsl:attribute name="background-style"><xsl:value-of select="background_style"/></xsl:attribute>
			<xsl:apply-templates select="Relationships/Item/related_id/Item"/>
		</palette>
	</xsl:template>
	<xsl:template match="Item[@type='Chart']">
		<chart>
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="type"><xsl:value-of select="chart_type"/></xsl:attribute>
			<xsl:attribute name="x"><xsl:value-of select="../../x"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="../../y"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="height"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="width"/></xsl:attribute>
			<xsl:attribute name="border-top"><xsl:value-of select="border_top"/></xsl:attribute>
			<xsl:attribute name="border-bottom"><xsl:value-of select="border_bottom"/></xsl:attribute>
			<xsl:attribute name="border-left"><xsl:value-of select="border_left"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="border_right"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute>
			<xsl:attribute name="title-style"><xsl:value-of select="title_style"/></xsl:attribute>
			<xsl:attribute name="background-style"><xsl:value-of select="background_style"/></xsl:attribute>
			<xsl:attribute name="radius"><xsl:value-of select="radius"/></xsl:attribute>
			<xsl:attribute name="y-min"><xsl:value-of select="y_min"/></xsl:attribute>
			<xsl:attribute name="y-max"><xsl:value-of select="y_max"/></xsl:attribute>
			<xsl:attribute name="y-grid"><xsl:value-of select="y_grid"/></xsl:attribute>
			<xsl:attribute name="y-grid-interval"><xsl:value-of select="y_grid_interval"/></xsl:attribute>
			<xsl:attribute name="y-grid-style"><xsl:value-of select="y_grid_style"/></xsl:attribute>
			<xsl:attribute name="y-axis"><xsl:value-of select="y_axis"/></xsl:attribute>
			<xsl:attribute name="y-axis-style"><xsl:value-of select="y_axis_style"/></xsl:attribute>
			<xsl:attribute name="y-axis-label"><xsl:value-of select="y_axis_label"/></xsl:attribute>
			<xsl:attribute name="y-axis-label-style"><xsl:value-of select="y_axis_label_style"/></xsl:attribute>
			<xsl:attribute name="y-axis-value-labels"><xsl:value-of select="y_axis_value_labels"/></xsl:attribute>
			<xsl:attribute name="y-axis-value-label-style"><xsl:value-of select="y_axis_value_label_style"/></xsl:attribute>
			<xsl:attribute name="x-min"><xsl:value-of select="x_min"/></xsl:attribute>
			<xsl:attribute name="x-max"><xsl:value-of select="x_max"/></xsl:attribute>
			<xsl:attribute name="x-grid"><xsl:value-of select="x_grid"/></xsl:attribute>
			<xsl:attribute name="x-grid-interval"><xsl:value-of select="x_grid_interval"/></xsl:attribute>
			<xsl:attribute name="x-grid-style"><xsl:value-of select="x_grid_style"/></xsl:attribute>
			<xsl:attribute name="x-axis"><xsl:value-of select="x_axis"/></xsl:attribute>
			<xsl:attribute name="x-axis-style"><xsl:value-of select="x_axis_style"/></xsl:attribute>
			<xsl:attribute name="x-axis-label"><xsl:value-of select="x_axis_label"/></xsl:attribute>
			<xsl:attribute name="x-axis-label-style"><xsl:value-of select="x_axis_label_style"/></xsl:attribute>
			<xsl:attribute name="x-axis-value-labels"><xsl:value-of select="x_axis_value_labels"/></xsl:attribute>
			<xsl:attribute name="x-axis-value-label-style"><xsl:value-of select="x_axis_value_label_style"/></xsl:attribute>
			<xsl:attribute name="legend"><xsl:value-of select="legend"/></xsl:attribute>
			<xsl:attribute name="legend-x"><xsl:value-of select="legend_x"/></xsl:attribute>
			<xsl:attribute name="legend-y"><xsl:value-of select="legend_y"/></xsl:attribute>
			<xsl:attribute name="legend-height"><xsl:value-of select="legend_height"/></xsl:attribute>
			<xsl:attribute name="legend-width"><xsl:value-of select="legend_width"/></xsl:attribute>
			<xsl:attribute name="legend-box-style"><xsl:value-of select="legend_box_style"/></xsl:attribute>
			<xsl:attribute name="legend-text-style"><xsl:value-of select="legend_text_style"/></xsl:attribute>
			<xsl:attribute name="marker-size"><xsl:value-of select="marker_size"/></xsl:attribute>
			<xsl:attribute name="marker-style"><xsl:value-of select="marker_style"/></xsl:attribute>
			<xsl:attribute name="bar-spacing"><xsl:value-of select="bar_spacing"/></xsl:attribute>
			<xsl:apply-templates select="Relationships/Item/related_id/Item">
				<xsl:sort select="sort_order" data-type="number"/>
			</xsl:apply-templates>
		</chart>
	</xsl:template>
	<xsl:template match="Item[@type='Metric']">
		<series>
			<xsl:attribute name="label"><xsl:value-of select="label"/></xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="color"/></xsl:attribute>
			<xsl:attribute name="pattern"><xsl:value-of select="pattern"/></xsl:attribute>
			<xsl:attribute name="link"><xsl:value-of select="link"/></xsl:attribute>
			<xsl:attribute name="markers"><xsl:value-of select="../../markers"/></xsl:attribute>
			<xsl:apply-templates select="Relationships/Item">
				<xsl:sort select="sort_order" data-type="number"/>
			</xsl:apply-templates>
		</series>
	</xsl:template>
	<xsl:template match="Item[@type='Metric Value']">
		<datum>
			<xsl:attribute name="label"><xsl:value-of select="label"/></xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="color"/></xsl:attribute>
			<xsl:attribute name="link"><xsl:value-of select="link"/></xsl:attribute>
			<xsl:attribute name="x-value"><xsl:value-of select="sort_order"/></xsl:attribute>
			<xsl:attribute name="y-value"><xsl:value-of select="value"/></xsl:attribute>
		</datum>
	</xsl:template>
</xsl:stylesheet>
