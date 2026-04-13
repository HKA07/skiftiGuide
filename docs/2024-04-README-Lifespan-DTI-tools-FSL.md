# A BRIEF INTRODUCTION TO LIFESPAN DTI TOOLS

## FSL pipeline, VERSION 3; 04 / 2024

## Single shell DTI fit and ANTs TBSS postprocessing, converting the skeletonized data into tabular format (.skifti) 

## Jetro J. Tuulari & Harri Merisaari & Aaron Barron

### contact: jjtuul@utu.fi

# General notes

* We have included an example data set that contains data from here; <https://openneuro.org/datasets/ds004097/versions/1.1.0>.
* We use data from 1 participant, using 1 session, as an example data set. 

# Depencies / needed software

* FSL version > 6.0.7; <https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation>
* Docker installation; <https://docs.docker.com/get-docker/>
* These instructions have been written using UNIX style directory structures, and are easily adapted to Linux and MAC OS computers
* The tools should work with Windows OS if the depencies are taken into account and the scripts modified (we have not tested this)

# Preparations for the model data (already done)

* Run QSIprep (preprocess the data; no need to run but interest users can try setting up this step as well. 
* You may have already run preprocessing and QC on your data set, in this case you can skip this step and move on
* Note that we used the 'latest' version of the docker here, naturally one would replace the final command with the version you would like to use for the whole study
* QSIprep produces nice output for QC, after reviewing that we are good to go for later steps
* We have already run this step for introducing a model data set we have carried out a version of preprocessed data using qsiprep

## example command

```
docker run -ti --rm -v /Users/jetrojtuulari/Downloads/ds004097-download:/data:ro -v /Users/jetrojtuulari/Downloads/derivatives:/out -v /Users/jetrojtuulari/Downloads/work:/work -v /Users/jetrojtuulari/Downloads/license.txt:/opt/freesurfer/license.txt pennbbl/qsiprep:latest /data /out participant -w /work --participant_label sub-NDARDD890AYU --separate-all-dwis --anatomical-template MNI152NLin2009cAsym --output-resolution 1.7 --write-graph --skip_bids_validation --n-cpus 6 --mem-mb 24000

```

# Step 1. Perform DTI fit (yield derived brain metrics)

* we use FSL's FDT tools to do the DTI tensor fitting
* the data sets are only allowed to include b values \< 1500 so that ordinary least squares fit is quaranteed to work
* open the script and find locations tagged with "# USER ...", modification mainly pertain to defining directories and filenaming 

## Step1 example command that processes 1 participant

```
sh script_fsl_dtifit_single_shell_ols.sh sub-NDARDD890AYU

```

## Step 1 example command that processes several participants

### Note: you will need to edit script 'script_prep_ants_tbss_ols.sh' the sections that need modfications are tagged with " # USER ... "

* Take special care to change the name of the input files based on your own subject naming system. Where the script says sub\*, change to a pattern matching your own ID codes.  


```
In this example the "$/dwi_directory" should contain directories that carry the subject ID's. For example in a BIDS formatted directory structure


ls $/dwi_directory

   |-sub-NDARDD890AYU
	   |---anat
	   |---figures
	   |---ses-01
	   |-----anat
	   |-----dwi # directory containing the input data
   |-sub-NDARDD110011
	   |---anat
	   |---figures
	   |---ses-01
	   |-----anat
	   |-----dwi # directory containing the input data

.... etc. 

```

```
# for loop example

for file in $(ls ./dwi_directory)

do

sh script_fsl_dtifit_single_shell_ols.sh $file

done

```

# Step 2. Prepare the input files for the ANTs TBSS command

* this step prepares files that are needed as inputs for step 3
* this is done by listing the files from the standard output 

## 



## example command that creates the input files for the ANTs TBSS docker

```
sh script_prep_ants_tbss_ols.sh

```

# Step 3. ANTs TBSS, spatial normalisation and extract tabular data

* This docker container packages these tools; <https://github.com/pnlbwh/TBSS>
* The pipeline should be usable via apptainer in HPC environments; <https://apptainer.org/> or Singularity; <https://docs.sylabs.io/guides/3.5/user-guide/index.html> 



### Notes: 

* ### The ANTs TBSS docker will give an error if the output folder exists, remove / rename if necessary
* ### We use 3 CPU's for this command, --ncpu 3, please adapt according to your resources and sample size, using more CPU's will greatly speed up the processing.
* ### For those new to docker, make sure you allow appropriate resources to Docker on your host machine: Preferences --> resources



```
docker run -it -v $(pwd):/root/data -v $(pwd)/out_ants_tbss_enigma_ss:/root/data/out_enigma haanme/ants_tbss:0.4.2 -i /root/data/IMAGELIST_ss_docker.csv -c /root/data/CASELIST.txt --modality FA,MD --enigma --ncpu 3 -o /root/data/out_enigma

```

### Quality control instructions

* view .html report in: $/out_ants_tbss_enigma_ss/FA/slicesdir
* view .html report in: $/out_ants_tbss_enigma_ss/MD/slicesdir
* view coregistrtation accuracy in: $/out_ants_tbss_enigma_ss/log/similarity.csv

# Step 4. Skiftify - extract tabular & voxelwise data

* the output additionally includes voxelwise data from the TBSS skeleton as a row vector for each participant, and the subject ID in the first column. This is extracted using the docker container below.
* how to use this data in downstream analyses will be decided separately by the consortium members, potential use:
  		_ regression models across voxels and voxelwise meta analyses
  		_ multivariate statistics / machine learning applications

## example command

```
docker run -v $(pwd):/data -it haanme/lifespan_postprocess:0.2.3 --name my_site_ename --path /data --outputpath /data/out_ants_tbss_postprocess_output --TBSSsubfolder out_ants_tbss_enigma_ss

```

* the script will create a new folder called 'out_ants_tbss_postprocess_output'
* this folder contains a .zip file, when you unzip it, you will find the key output files

  ```
  	* FA_combined_roi.csv > copy from $/out_ants_tbss_enigma_ss/stats, including the JHU labelled ROI data

  	* FA_combined_roi_avg.csv > copy from $/out_ants_tbss_enigma_ss/stats, including the JHU labelled ROI data where left and right side have been averaged

  	* MD_combined_roi.csv > copy from $/out_ants_tbss_enigma_ss/stats, including the JHU labelled ROI data

  	* MD_combined_roi_avg.csv > copy from $/out_ants_tbss_enigma_ss/stats, including the JHU labelled ROI data where left and right side have been averaged

  	* log.txt > log file of the docker container

  	* my_site_ename_FA_Skiftidata.txt > ASCII file containing the subject ID + scalar values from all voxels in the white matter skeleton as a row vector ~ 1 x 192k

  	* my_site_ename_MD_Skiftidata.txt > ASCII file containing the subject ID + scalar values from all voxels in the white matter skeleton as a row vector ~ 1 x 192k

  ```

# STEP 5. Moving on to statistics

* use the files in $/out_ants_tbss_enigma_ss/stats directory for statistics

  ```
  	* FA_combined_roi.csv / MD_combined_roi.csv > the JHU labelled ROI data 

  	* FA_combined_roi_avg.csv / FA_combined_roi_avg.csv > the JHU labelled ROI data where left and right side have been averaged

  	* the files for voxelwise analyses; https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TBSS/UserGuide

  		* all_MD_skeletonized.nii.gz
  		* all_FA_skeletonized.nii.gz
  		* ENIGMA_DTI_FA_skeleton_mask.nii.gz
  		* visualisation: mean_FA.nii.gz

  ```

### Note: there will be separate instructions / protocols for statistical models using these output files.

# END


