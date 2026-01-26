Exploratory Data Analysis (EDA) Toolbox

CONTENTS
Version 2.0, December 2010
Contributed files may contain copyrights of their own.

This toolbox is meant to accompany the book: Exploratory Data Analysis
with MATLAB, W. Martinez, A. Martinez, & J. Solka, CRC Press, 2010.

INSTALLATION 
Copy the toolbox folder into a directory of your choice. 
Start Matlab and select 'Set path...' from the File menu. 
Click the 'Add with subfolders...' button,  and 
select the folder for the EDA Toolbox in the file dialog, and press Open. 
Subsequently, press the Save button in order to save your changes to the 
Matlab search path. The toolbox is now installed. 


OTHER TOOLBOXES
Dimensionality Reduction Toolbox
EDA GUI Toolbox
Fast ICA Toolbox
GTM Toolbox
SOM Toolbox

LICENSE:
The EDA Toolbox comes with ABSOLUTELY NO WARRANTY; for details
see license.txt. This is free software and is provided under the GNU license.
You are welcome to redistribute it under certain conditions;
see License.txt and http://www.gnu.org/copyleft/gpl.html

DISCLAIMER:
This software and documentation are distributed in the hope that they will be useful, 
but they are distributed without any warranty and without even the implied warranty of 
correctness or fitness for a particular purpose. 

The federal government, in particular the Department of the Navy and the Department of Defense, 
disclaims all responsibility for this software and any outcome from its use. In addition, 
this software and documentation does not reflect the views of and is not endorsed by the federal 
government nor the Department of the Navy.

The code has been tested with care, but is not guaranteed to be free of defects and is not guaranteed 
for any particular purpose. Bug reports and suggestions for improvements are always welcome at
martinezw@verizon.net.


CLUSTERING
adjrand             Adjusted Rand index to compare groupings.
agmclust            Model-based agglomerative clustering.
genmix              GUI to generate random variables from finite mixture.
mbcfinmix           Model-based finite mixture estimation - EM.
mbclust             Model-based clustering.
mixclass            Classification using mixture model.
mojenaplot          'Mojena Rule' plot for estimating the number of clsuters
plotbic             Plot the BIC values from model-based clustering.
randind             Rand index to compare groupings.
reclus              ReClus plot to visualize cluster output.
rectplot            Rectangle plot to visualize hierarchical clustering.
treemap             Treemap display for hierarchical clustering.

DATA TOURS
csppstrtrem         Remove structure in PPEDA.
Fast ICA Toolbox    The Fast ICA Toolbox is included.
intour              Interpolation tour of the data.
kdimtour	        k-dimensional grand tour.
permtourandrews     Permutation tour using Andrews’ curves.
permtourparallel    Permutation tour using parallel coordinate plots.
ppeda	            Projection pursuit EDA.
pseudotour          Pseudo grand tour.
torustour	        Asimov grand tour

DIMENSIONALITY REDUCTION
DR Toolbox          The Dimensionality Reduction Toolbox is included.
gtm_pmd             Calculates posterior mode projection (GTM Toolbox).
gtm_pmn             Calculates posterior mean projection (GTM Toolbox).
gtm_stp2	        Generates components of a GTM (GTM Toolbox).
gtm_trn             Train the GTM using EM (GTM Toolbox).
GTM Toolbox         The entire GTM Toolbox is included.
hlle	            Hessian eigenmaps.
idpettis	        Intrinsic dimensionality estimate.
isomap              ISOMAP nonlinear dimensionality reduction.
lle                 Locally linear embedding.
nmmds	            Nonmetric multidimensional scaling.
som_autolabel	    Automatic labeling (SOM Toolbox).
som_data_struct     Create a data structure (SOM Toolbox).
som_make	        Create, initialize and train SOM (SOM Toolbox).
som_normalize	    Normalize data (SOM Toolbox).
som_set             Set up SOM structures (SOM Toolbox).
som_show	        Basic SOM visualization (SOM Toolbox).
som_show_add	    Shows hits, labels and trajectories (SOM Toolbox).
SOM Toolbox         The entire SOM Toolbox is included.


DISTRIBUTION SHAPES
bagmat.exe          Executable file to get arrays needed for bagplot.
bagplot             M-file to construct actual bagplot.
boxp	            Boxplot - regular.
boxprct             Box-percentile plot.
polarloess          Bivariate smoothing using loess.
quantileseda	    Sample quantiles.
quartiles	        Sample quartiles using Tukey’s fourths.

EDA GUI Toolbox
edagui              Entry point (optional) for the EDA GUI Toolbox
loadgui             Loads up data, variable names, and more
gedagui             Graphical EDA - scatterplots, parallelt coorda, etc.
univgui             Explores univariate distributions
bivgui              Explores bivariate distributions
tourgui             Options for data tours
ppedagui            Performs projection pursuit EDA
mdsgui              Multidimensional scaling
dimredgui           Dimension reduction - linear and nonlinear
kmeansgui           K-means clustering
agcgui              Agglomerative clustering
mbcgui              Model-based clustering 

GUIs
brushscatter        Scatterplot brushing and linking.
genmix              Executable file to get arrays needed for bagplot.
isomapeda           Explore results of ISOMAP.
scattergui          Scatterplot with interactive labeling.

SMOOTHING
loess	            1-D loess scatterplot smoothing.
loess2              2-D loess smoothing from Data Visualization Toolbox.
loessenv            Loess upper and lower envelopes.
loessr              Robust loess scatterplot smoothing.
polarloess          Bivariate smoothing using loess.

VISUALIZATION
brushscatter	    Scatterplot brushing and linking.
coplot              Coplot from Data Visualization Toolbox.
csandrews	        Andrews' curves plot.
csparallel          Parallel coordinates plot.
dotchart	        Dot chart plot.
hexplot             Hexagonal binning for scatterplot.
mojenaplot          'Mojena Rule' plot for estimating the number of clsuters
multiwayplot	    Multiway dot charts.
plotbic             Plot the BIC values from model-based clustering.
plotmatrixandr      Plot matrix of Andrews' curves.
plotmatrixpara      Plot matrix of parallel coordinates.
reclus              ReClus plot to visualize cluster output.
rectplot	        Rectangle plot to visualize hierarchical clustering.
scattergui          Scatterplot with interactive labeling.
treemap             Treemap display for hierarchical clustering.

DATA SETS
abrasion            Rubber experiments
animal              Brain weights and body weights of animals
bank                Genuine and forged money
calibrat            Radioactivity counts to hormone level
cereal              Assessment of eight brands of cereal
environmental       Environmental variables: ozone, solar radiation, temperature, wind speed
ethanol             Compression ratio, equivalence ratio, NO_x for a single-cylinder engine
forearm             Length in inches of the forearm of adult males
example*            Various data sets for the example in the boook
galaxy              Velocities of the spiral galaxy
geyser              Waiting times in minutes between eruptions of the Old Faithful geyser
hamster             Organ weights for hamsters with congenital heart failure
iradbpm             Interpoint distance matrix (IRad) for the BPM data set
iris                Fisher's iris data. Species are in different arrays.
L1bpm               Interpoint distance matrix (L1) for the BPM data set
leukemia            Gene expression level of patients with leukemia
livestock           Livestock counts from a 1987 census of farm animals
lsiex               Term-document matrix used in Example 2.3, illustrating LSI
lungA               Gene expression data for lung cancer
lungB               Gene expression data for lung cancer    
matchbpm            Interpoint distance matrix (match coefficient) for the BPM data set
nmfclustex          Data for nonnegative matrix factorization clustering
ochiaibpm           Interpoint distance matrix (Ochiai similarity measure) for the BPM data set
oronsay             Particle size measurements for sand
ozone               Daily maximum ozone concentrations at ground level on 132 days in 1974
playfair            Populations of 22 cities and diameters used for display by William Playfair
pollen              Artificial data set created for 1986 Joint Statistical Meetings
posse               Data sets from Christian Posse, used for projection pursuit EDA
salmon              Size of spawning stock of salmon along the Skeena River
scurve              Data from an S-curve manifold
singer              Height in inches of singers
skulls              Measurements of 40 skulls. 18 are female and 22 are male
software            Data on software inspections
spam                Attributes of email, some of which are spam
sparrow             Measurements on sparrows. The first 21 survived, and the rest died.
swissroll           Data from the Swiss roll manifold
vineyard            Total number of lugs per row
votfraud            Democratic and Republican pluralities of voting machines and absentee votes
yeast               Gene expression data for yeast cells - two cell cycles and five phases

