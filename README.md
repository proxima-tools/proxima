<img src="https://github.com/david-istvan/icm/blob/master/branding/logo.png" width="160">

# *PRO*cess engineering with *I*nconsistency *MA*nagement

PROxIMA is a process modeling and simulation framework. It enables the optimization of the modeled processes for multi-paradigm semantic inconsistencies.

The features of the framework include:
 -  A visual process modeler based on the FTG+PM formalism that enables the modeling processes along with a formalism transformation graph as its strong type system.
 -  A fully modeled process enactment module.
 -  A process simulation and optimization module, with the ability to rewrite the process.
 -  The catalogue of inconsistency patterns and the catalogue of management patterns is fully extensible.


# :warning: WE ARE GRADUALLY MIGRATING PROxIMA. :warning:
We are doing this by gradually releasing the ravamped modules one-by-one.

## PROxIMA 0.2 status
 - [x] Core (metamodels and commons)
 - [x] Modeling
 - [ ] Enactment
 - [ ] Design-space exploration and simulation

We are currently stabilizing the Modeling module before proceeding with the migration of the rest of the modules.

## Update site (for users)
!TODO

## Installation guide (for developers)
1. Download the [Eclipse 2020-9 R Modeling](https://www.eclipse.org/downloads/packages/release/2020-09/r/eclipse-modeling-tools) package.
~~2. Install [Sirius 5.0.1](http://download.eclipse.org/sirius/updates/releases/5.0.1/oxygen).~~
~~3. Install [VIATRA 1.6.0](http://download.eclipse.org/viatra/updates/release).~~

### External dependencies
~~1. Install [Python3](https://www.python.org/download/releases/3.0/) and [SymPy](http://www.sympy.org) for  for symbolic inconsistency checking.~~

~~2. Install Matlab/Simulink (last tested version: 2016b) and set up your environment for the Java API as described [here](https://nl.mathworks.com/help/matlab/matlab_external/setup-environment.html). (Typically, you'll only have to add ```matlabroot/bin/<arch>``` to your system environment variable, where ```<arch>``` is your computer architecture. For example, win64 for 64–bit Windows machines, maci64 on Macintosh, or glnxa64 on Linux.)~~

### Setting up the environment
1. Import the plugins from this repository's ```plugins``` and ```external``` folders.
2. Generate domain model code.

   Automated way: run the ```GenerateMetamodels.mwe2``` generator file in the ```models``` folder of the ```be.uantwerpen.msdl.metamodels``` plugin.

   Manual way: use the ```processmodel.genmodel``` and ```enactment.genmodel``` generator models.
   
## Pointers for using the tool
 - [Sharing MATLAB sessions](https://nl.mathworks.com/help/matlab/ref/matlab.engine.shareengine.html)
