# A tool for managing inconsistencies in engineering processes

<!---
Our prototype tool aims to enhance engineering processes by managing potential inconsistencies emering in collaborative modeling settings. The tool is built on top of the Eclipse platform and is available as a set of Eclipse plugins. (See the installation guide.)

The features of the framework include:
 -  A visual process modeler based on the extended FTG+PM formalism that enables modeling languages and system properties in conjuction with processes.
 -  A process optimization module, that augments the process with the appropriate inconsistency management techniques.
 -  The catalogue of inconsistency patterns and the catalogue of management patterns is fully extensible.


### Architecture
![alt text](https://dl.dropboxusercontent.com/u/44011277/icm/architecture.png "Architectural overview")

### Versioning and roadmap
The first public release is planned for Summer of 2016.
-->

### Installation guide
1. Download the [Eclipse Neon 4.3 Modeling](http://www.eclipse.org/downloads/packages/eclipse-modeling-tools/neon3) package.
2. Install [Sirius 4.1.1](http://download.eclipse.org/sirius/updates/releases/4.1.1/neon).
3. Install [VIATRA 1.5.0](http://download.eclipse.org/viatra/updates/release).

### External dependencies
1. Install [Python3](https://www.python.org/download/releases/3.0/) and [SymPy](http://www.sympy.org) for  for symbolic inconsistency checking.

2. Install Matlab/Simulink (2016b preferred) and set up your environment for the Java API as described [here](https://nl.mathworks.com/help/matlab/matlab_external/setup-environment.html). (Typically, you'll only have to add ```matlabroot/bin/<arch>``` to your system environment variable, where ```<arch>``` is your computer architecture. For example, win64 for 64–bit Windows machines, maci64 on Macintosh, or glnxa64 on Linux.)

### Setting up the environment
1. Import the plugins from this repository's ```plugins``` and ```external``` folders.
2. Generate domain model code from the ```processmodel.genmodel``` and ```enactment.genmodel``` generator models in the  ```be.uantwerpen.msdl.metamodels``` plugin.
