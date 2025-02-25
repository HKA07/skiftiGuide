######
Usage
######


To run SkiftiTools you must have Nifti image format or tab separated ASCII format data.



Examples
--------

1. Using together with ants TBSS toolbox:
   
1.1 Align data to ENIGMA [1] template using ants TBSS package [2]:

| 1.1.1 Place FA scalar maps into output folder (after this assuming that the FA maps are with .nii.gz suffix in subfolder called 'output')
|
| 1.1.2 Create list of subject names to run e g::

   $ for f $(ls output); do echo $($f | awk -F'. '{print $1}'); done > caselist.txt
|
| 1.1.3 Run ants TBSS with docker to create TBSS results to subfolder 'out'::

   $ docker run -it --rm haanme/ants_tbss:0.4.2 -i $(pwd)/tractoinferno_FA -c caselist.txt --modality FA --enigma -o $(pwd)/out

[1] https://enigma.ini.usc.edu/protocols/dti-protocols/
[2] https://github.com/trislett/ants_tbss