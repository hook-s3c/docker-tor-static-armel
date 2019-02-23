# docker-tor-static-armel
Builds a tor static binary for ARM (armel)

This was painful to set up, you will find a lot of broken instructions, stackoverflows and forum posts from years back with questions and no solutions.

This is self-contained (in a container), so to build the binary simply run;


```
git clone https://github.com/hook-s3c/docker-tor-static-armel
docker build .
```

- The binary should appear in the output folder.
- The only dependency is having Docker installed on your system.


You're welcome.

Shout out to the original author who did a half-assed job and never published or tested the source to their Docker Hub container, you made my evening hell.
