#############
Installation
#############

SkiftiTools can be used with Docker containers. Docker must be `installed
<https://docs.docker.com/engine/installation/>`_.


Once Docker has been installed on your computer, you are ready to run. 

********************
How to run the tool: 
********************

Pull the Docker image Docker pull ashjoll/skiftitools:0.1.1 
Run the tool with the required data docker run –rm -v /path/to/data:/out/stats ashjoll/skiftitools:0.1.1 
Possible issues that might come up when running: 

.. note::
    the image needs linux/amd64 (you get this as a warning and not an error, so Docker should still keep running). However, to avoid this issue altogether, MAC users can do this:

     - docker run --rm --platform linux/amd64 -v /path/to/data:/out/stats ashjoll/skiftitools:0.1.1 
    
The container expects input and output files inside /out/stats/. However, this directory is not automatically created inside the Docker container. Therefore, users must mount an external directory to: ::
    /out/stats/ when running the container: -v /path/to/data:/out/stats

Resource: SkiftiLink: <https://hub.docker.com/r/ashjoll/skiftitools/tags>