# docker-tor-static-armel
Builds a tor static binary for ARM (armel)

This was painful to set up, you will find a lot of broken instructions, stackoverflows and forum posts from years back with questions and no solutions.

This is self-contained (in a container), so to build the binary simply run;


```
# get the source
git clone https://github.com/hook-s3c/docker-tor-static-armel

# build the image
docker build --tag tor-static:armel .

# copy the binary out of the image 
docker run --rm --entrypoint "/bin/bash" -v $(pwd)/output:/output tor-static:armel -c "cp /tor-0.3.3.10/install/bin/tor /output/tor"

```

- The binary should appear in the output folder.
- The only dependency is having Docker installed on your system.
- If you have multiple cores, try `docker build --cpuset-cpus=0,1,2 --tag tor-static:armel .` instead.

You're welcome.

Shout out to the original author who did a half-assed job and never published or tested the source to their Docker Hub container, you made my evening hell.


## Resources


prebuilt static binaries already out there, some with sources (YMMV / use at your own risk);
- Mips binaries; https://github.com/darkerego/mips-binaries
- Armel binaries; https://github.com/therealsaumil/static-arm-bins
- https://github.com/andrew-d/static-binaries/tree/master/binaries/linux/arm
- https://github.com/ernw/static-toolbox/releases

- http://jensd.be/800/linux/cross-compiling-for-arm-with-ubuntu-16-04-lts

A couple of awesome tutorials for the uninitiated (like me);
- https://medium.com/@jhuang1012bn/static-library-and-shared-library-de6def6b1d3b
- https://medium.com/@jhuang1012bn/static-libraries-in-c-4c9efcd6e168 

- https://insinuator.net/2018/02/creating-static-binaries-for-nmap-socat-and-other-tools/
- https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/
