#############
Installation
#############

SkiftiTools can be used with ``Docker`` containers. ``Docker`` must be `installed
<https://docs.docker.com/engine/installation/>`_.


Once ``Docker`` has been installed on your computer, you are ready to run. 

********************
How to run the tool
********************

Pull the ``Docker`` image. Example: ::

    pull ashjoll/skiftitools:0.2.0

Run the tool with the required data: ::

    docker run –rm -v /path/to/data:/out/stats ashjoll/skiftitools:0.2.0

Possible issues that might come up when running the ``Docker``: 

.. note::
    the image needs linux/amd64 (you get this as a warning and not an error, so ``Docker`` should still keep running). However, to avoid this issue altogether, MAC users can do this: ::

    docker run --rm --platform linux/amd64 -v /path/to/data:/out/stats ashjoll/skiftitools:0.1.1 
    

**Resource**: `Docker Source Link <https://hub.docker.com/r/ashjoll/skiftitools/tags>`_.
