# A tool for managing inconsistencies in engineering processes

Our prototype tool aims to enhance engineering processes by managing potential inconsistencies emering in collaborative modeling settings. The tool is built on top of the Eclipse platform and is available as a set of Eclipse plugins. (See the installation guide.)

The features of the framework include:
 -  A visual process modeler based on the extended FTG+PM formalism that enables modeling languages and system properties in conjuction with processes.
 -  A process optimization module, that augments the process with the appropriate inconsistency management techniques.
 -  The catalogue of inconsistency patterns and the catalogue of management patterns is fully extensible.


### Architecture
-sirius, viatra, graph queries, mts, etc
### Versioning and roadmap
The initial relase with version number ```0.1.0``` is planned for 18th of April 2016.

### Installation guide
1. Download the latest [Eclipse Modeling](http://www.eclipse.org/downloads/packages/eclipse-modeling-tools/lunar) package.
2. Install [Sirius](https://eclipse.org/sirius/download.html).
3. Install [VIATRA](https://eclipse.org/viatra/downloads.php).
4. Install the  [inconsistency management tool](https://github.com/david-istvan/icm/raw/master/releng/be.uantwerpen.msdl.icm.processmodeler.update/site.xml).