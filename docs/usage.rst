######
Usage
######

To run SkiftiTools, you must have Nifti image format or tab-separated ASCII format data. SkiftiTools is most commonly used with diffusion MRI data.

Examples
--------

A. Processing OpenNeuro DTI data using SkiftiTools v0.1.1
-------------------------------------------------------
**STEP 1**

1.1 OpenNeuro Dataset:
Download shell script under 'Download with a shell script' from <https://openneuro.org/datasets/ds003900/versions/1.1.1/download#>

1.2 Extract the download options for 1st three items
cat ds003900-1.1.1.sh | grep fa.nii.gz | head -3 > ds003900-1.1.1_example_for_skiftiTools.sh
Subjects that are downloaded with only their FA nifti images:

.. image:: fig_usage_1.png

**STEP 2**

2.1 Run ANTs TBSS on the data.
For this specific example data, use the script tractinferno_prep_ants_tbss.sh and run it in the directory it is downloaded in *bash tractinferno_prep_ants_tbss.sh*

Then, run the following docker command, but make sure that you are using memory capacity based on the machine it is running on. ANTs registration is very memory-intensive and the *antsRegistrationSyNQuick.sh* process can get force killed. It is safer to use flags with the following parameters, although it might run a little slower because of single-threaded processing:

``--cpus="1"`` 
``--memory="4g"``
``--ncpu 1``

   ::

      docker run -it --cpus="1" --memory="4g" -v $(pwd):/root/data -v $(pwd)/out_ants_tbss_enigma_ss:/root/data/out_enigma haanme/ants_tbss:0.4.2 -i /root/data/IMAGELIST_ss_docker.csv -c /root/data/CASELIST.txt --modality FA --enigma --ncpu 1 -o /root/data/out_enigma


Output in the terminal should look like this:

.. image:: fig_usage_2.png

**STEP 3**

Check output created by the ants_tbss docker. The out_ants_tbss_enigma_ss folder:

.. image:: fig_usage_3.png

The most important folder is **stats**. Open it and make sure that you have the following:
   - FA_combined_roi_avg.csv
   - FA_combined_roi.csv
   - all_FA_skeletonised.nii.gz
   - mean_FA_skeleton_mask.nii.gz

If any of these files are missing, re-run the Docker, or debug to see what went wrong.

**STEP 4**

4.1 You can rename the *out_ants_tbss_enigma_ss* to **tbss** to keep the directory structure clean.

4.2 Then run the following command in the directory above the **tbss** folder: 
   ::
   
      docker run --rm -v $(pwd):/data -it ashjoll/skiftitools:0.1.1 --path /data --outputpath /data/results --TBSSsubfolder tbss --scalar FA --name test

To understand what each flag is doing, you can run: 
   ::
   
      docker run --rm ashjoll/skiftitools:0.1.1 -h

The skifti data file will be in the results folder, named *test_FA_Skiftidata.txt*.

Although this file contains only 3 subjects, it can still be difficult to open in excel/numbers etc due to a lot of data. You can open it in R studio with the following code: 
   ::

      library(data.table)

      skifti <- fread("/path/to/text/file", header = FALSE, skip = 8)

(The first few lines in the text file will have metadata that we don’t need, hence skip = 8).
   ::
      
      colnames(skifti) <- c("SubjectID", paste0("V", 1:(ncol(skifti)-1)))

The tabular data should look like this:

.. image:: fig_usage_4.png

The picture does not display all the columns; there will be many. The V1, V2, V3... are the
mean FA in each white matter ROI for each subject.

**STEP 5**
Perform any kind of complex statistical analysis using this dataset.


References
----------

[1] ENIGMA DTI Protocols: https://enigma.ini.usc.edu/protocols/dti-protocols/  

[2] ANTs TBSS Package: https://github.com/trislett/ants_tbss
