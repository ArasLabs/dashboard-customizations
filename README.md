# Custom Dashboard Charts

This project demonstrates how to further customize dashboard charts in addition to adding custom font CSS to the chart labels.
To add custom font CSS to a chart please follow the Change Font of Dashboard document in the documents folder.

## History

Release | Notes
--------|--------
[v1.0.1](https://github.com/ArasLabs/dashboard-customizations/releases/tag/v1.0.1) | Tested 11.0 SP12, SP15. Package works in IE, Edge. [Has axis error in Firefox (Issue).](https://github.com/ArasLabs/dashboard-customizations/issues/1) Chrome not supported at this time.
[v1.0.0](https://github.com/ArasLabs/dashboard-customizations/releases/tag/v1.0.0) | First release. Tested on Internet Explorer 11, Firefox 38 ESR, Chrome. 


#### Supported Aras Versions

Project | Aras
--------|------
[v1.0.1](https://github.com/ArasLabs/dashboard-customizations/releases/tag/v1.0.1) | 10.0 SPx, 11.0 SP9+, 11.0 SP12+, 11.0 SP15
[v1.0.0](https://github.com/ArasLabs/dashboard-customizations/releases/tag/v1.0.0) | 10.0 SPx, 11.0 SP9; Old Community Board Migration

> Though built and tested using Aras 11.0 SP9, this project should function in older releases of Aras 11.0.

## How It Works

This project contains two parts - an import package and a code tree overlay.

The import package does the following updates:

1. Adds the new pattern property the Metric item
2. Adds the pattern field to the Metric form
3. Updates the Build Dashboard method to query the pattern property from Metric items
4. Adds the new list item `labs_ChartFillPattern` used as the data source for the newly added Metric pattern property

The code tree overlay modifies the `../Client/styles/svg_charts.xsl` and `../Server/styles/aml2chart.xsl` files in order to support the new pattern property added to the Metric item.
A new striped pattern has been created in the `<defs>` section of the XSL file as an example (see [./Screenshots/Fill Pattern Snippet.PNG](./Screenshots/Fill%20Pattern%20Snippet.PNG)).

Once the package has been installed successfully the option for both stacked bar and bar charts to have a striped pattern will be available using the pattern menu (see [./Screenshots/Pattern Property Selection.PNG](./Screenshots/Pattern%20Property%20Selection.PNG)).

Additional pattern options can be created in the `<defs>` section of the `svg_charts.xsl` file.
If more options are created the XSL choose statement should be modified for both the stacked bar and bar chart types (see [./Screenshots/Select Pattern Snippet.PNG](./Screenshots/Select%20Pattern%20Snippet.PNG)).
Lastly, the new pattern type should be added to the `labs_ChartFillPattern` list item so that the option appears in the pattern menu.

In addition to customizing the appearance of bar charts, the CSS of a chart can also be further customized.
In this particular example, the CSS has been enhanced to change both the appearance of the bars and makers in line charts when the elements are moused over (see [./Screenshots/Hover CSS Snippet.PNG](./Screenshots/Hover%20CSS%20Snippet.PNG)).

## Installation

#### Important!
**Always back up your code tree and database before applying an import package or code tree patch!**

### Pre-requisites

1. Aras Innovator installed (version 11.0 SPx preferred)
2. Aras Package Import tool
3. dashboardCustomizations import package
4. dashboardCustomizations code tree overlay

### Install Steps

1. Backup your code tree and store the backup in a safe place.
2. Copy the Innovator folder from the project's CodeTree subdirectory.
3. Paste the Innovator folder into the root directory of your Aras installation.
  * Tip: This is the same directory that contains the InnovatorServerConfig.xml file.
4. Backup your database and store the BAK file in a safe place.
5. Open up the Aras Package Import tool.
6. Enter your login credentials and click **Login**
  * _Note: You must login as root for the package import to succeed!_
7. Enter the package name in the TargetRelease field.
  * Optional: Enter a description in the Description field.
8. Enter the path to your local `..\dashboardCustomizations\Import\imports.mf` file in the Manifest File field.
9. Select **dashboardCustomizations** in the Available for Import field.
10. Select Type = **Merge** and Mode = **Thorough Mode**.
11. Click **Import** in the top left corner.
12. Close the Aras Package Import tool.

You are now ready to login to Aras and check out how to customize the dashboard charts.

## Usage

1. Log in to Aras as admin.
2. Navigate to **Administration > Configuration > Dashboards** in the Table of Contents (TOC).
3. Search for the Dashboard that contains the chart you'd like to modify and open the item for editing. (locked)
4. In the Dashboard Chart tab, right click the chart you want to modify and select **View Chart**.
5. Lock the Chart item when the form/tab appears.
6. In the Chart Series tab, select the metric you want to modify and click the lock icon in the relationship grid toolbar to edit the settings directly from the Chart Series grid.
7. Set any properties you want to update, like Color or Pattern.
8. Once you've updated the Chart Series properties you can save, unlock, and close the Chart item.
9. Save, unlock and close the Dashboard item.
10. Navigate to **Dashboards** in the TOC and click the modified Dashboard to see the updated display.

![Customized Dashboard](./Screenshots/Dashboard%20Charts.PNG)
*The standard Engineering Efficiency dashboard, after being customized - including custom colors, fonts, and fill patterns.*

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

For more information on contributing to this project, another Aras Labs project, or any Aras Community project, shoot us an email at araslabs@aras.com.

## Credits

Project updated and expanded by Jillian Jakubowicz for Aras Labs. @JillJakubowicz

Original Aras Community Project by Aras Corporation Support: **Instructions to Change Font of a Dashboard**

## License

Aras Labs projects are published to Github under the MIT license. See the [LICENSE file](./LICENSE.md) for license rights and limitations.
