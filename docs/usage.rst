######
Usage
######

To run SkiftiTools, you must have Nifti image format or tab-separated ASCII format data.

Examples
--------

1. Using together with ANTs TBSS toolbox:

   1.1 **Align data to ENIGMA [1] template using ANTs TBSS package [2]:**

   - **Step 1:** Place FA scalar maps into the output folder. (Assuming that the FA maps have a `.nii.gz` suffix in a subfolder called `output`.)

   - **Step 2:** Create a list of subject names to run, e.g.:

     ::

        $ for f in $(ls output); do echo $(echo $f | awk -F'.' '{print $1}'); done > caselist.txt

   - **Step 3:** Run ANTs TBSS with Docker to create TBSS results in a subfolder `out`:

     ::

        docker run –rm -v /path/to/data:/out/stats ashjoll/skiftitools:0.1.1 \
         -i $(pwd)/tractoinferno_FA 
         -c caselist.txt 
         --modality FA --enigma 
         -o $(pwd)/out

References
----------

[1] ENIGMA DTI Protocols: https://enigma.ini.usc.edu/protocols/dti-protocols/  

[2] ANTs TBSS Package: https://github.com/trislett/ants_tbss
