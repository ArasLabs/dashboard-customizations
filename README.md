# Custom Dashboard Charts

This project demonstrates how to futher customize dashboard charts in addition to adding custom font css to the chart labels.
To add custom font css to a chart please follow the Change Font of Dashboard document in the docucments folder. 

## Project Details

See [TESTSTATUS file](./TESTSTATUS.md) for latest testing information.

#### Built Using:
Aras 11.0 SP7

#### Versions Tested:
Aras 11.0 SP7

#### Browsers Tested:
Internet Explorer 11, Firefox 38 ESR, Chrome

> Though built and tested using Aras 11.0 SP7, this project should function in older releases of Aras 11.0.

## How It Works

This project contains two parts - an import package and a code tree overlay. 

The import package does the following updates:
	1. Adds the new pattern property the Metric item 
	2. Adds the pattern field to the Metric form
	3. Updates the Build Dashboard method to query the pattern property from Metric items
	4. Adds the new list item labs_ChartFillPattern used as the data source for the newly added Metric pattern property

The code tree overlay modifies the ../Client/styles/svg_charts.xsl and ../Server/styles/aml2chart.xsl files in order to support the new pattern property added to the Metric item. 
A new striped pattern has been created in the defs section of the xsl file as an example (reference Fill Pattern Snippet.png in the Screenshots folder). 
Once the package has been installed successfully the option for both stacked bar and bar charts to have a striped pattern will be available using the pattern menu(reference Pattern Property Selection.png in the Screenshots folder).

Additional pattern options can be created in the defs section of the svg_charts.xsl file. 
If more options are created the xsl choose statement should be modified for both the stacked bar and bar chart types (reference Select Pattern Snippet.png in the Screenshots folder). 
Lastly, the new pattern type should be added to the labs_ChartFillPattern list item so that the option appears in the pattern menu.

In addition to customizing the appearance of bar charts, the css of a chart can also be further customized.
In this particular example, the css has been enhanced to change both the appearance of the bars and makers in line charts when the elements are moused over (reference Hover CSS Snippet.png in the Screenshots folder). 

## Installation

#### Important!
**Always back up your code tree and database before applying an import package or code tree patch!**

### Pre-requisites

1. Aras Innovator installed (version 11.0 SPx preferred)
2. Aras Package Import tool
3. CustomFormCSS import package
4. CustomFormCSS code tree overlay

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
8. Enter the path to your local `..\CustomFormCSS\Import\imports.mf` file in the Manifest File field.
9. Select **CustomFormCSS** in the Available for Import field.
10. Select Type = **Merge** and Mode = **Thorough Mode**.
11. Click **Import** in the top left corner.
12. Close the Aras Package Import tool.

You are now ready to login to Aras and check out how to customize the dashboard charts.

## Usage

1. Log in to Aras as admin.
2. Click **Design > Parts** in the table of contents (TOC).
3. Open an existing Part, or create a new Part to view the customized Part form design. It should look something like this:

![Customized Part Form](./Screenshots/custom_part_form.PNG)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

For more information on contributing to this project, another Aras Labs project, or any Aras Community project, shoot us an email at araslabs@aras.com.

## Credits

Created by Jillian Jakubowicz for Aras Labs. @JillJakubowicz

## License

Aras Labs projects are published to Github under the MIT license. See the [LICENSE file](./LICENSE.md) for license rights and limitations.
