+++
title = "Aquapark"
description = "Aquapark is a kind of 3D demo application, based on Lescegra."

[extra]
repository = "https://memfrob.de/hg/aquapark"
+++
Aquapark is a kind of 3D demo application, based on Lescegra. It was
initially developed as the final assignement for the 2003 computer
graphics course at the
[University of Applied Science Wedel](http://www.fh-wedel.de/), and
has subsequently been transformed into a virtual reality application
for the university's
[CAVE](http://vrlab.fh-wedel.de/ausstattung/display.html) immersive
display system.

## Features

- Continuous-Level-Of-Detail terrain
- Single-Pass multitexturing
- Animated light textures
- Particle systems

## Building

1. Extract the sources

        tar -xzf aquapark-VERSION.tar.gz
        cd aquapark-VERSION

2. Link lescegra into the source directory (not necessary for the aquapark-full package)

        ln -s ../lescegra-VERSION lescegra

3. Build aquapark (this will also build lescegra if necessary)

        ./configure && make

4. Run aquapark

        ./aquapark [-f]

## Controls

| Key   | Action                          |
| :---: | ------------------------------- |
| mouse | drag left button to look around |
| w     | toggle wireframe display        |
| s     | toggle smooth/flat shading      |
| c     | toggle backface culling         |
| q     | quit                            |

## Download

* Release 20050218 (stable)

  Source Tarball: [aquapark-20050218.tar.gz](/files/aquapark-20050218.tar.gz)

  Full Source Tarball: [aquapark-full-20050218.tar.gz](/files/aquapark-full-20050218.tar.gz)

## Changelog

### Release 20050218

Modifications to compile with lescegra-20050218.

### Release 20050208

Almost complete rewrite for the CAVE of our Virtual Reality lab. At
that time, the CAVE was still driven by an SGI Onyx2 with two 350MHz
processors.

### Release 20030728

Initial release as presented as the final work in the computer
graphics course at FH Wedel.

