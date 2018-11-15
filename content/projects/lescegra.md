+++
template = "project.html"
title = "Lescegra"
description = "Lescegra is an OpenGL 3D engine and game framework, written in strict ANSI C."

[extra]
repository = "https://memfrob.de/hg/lescegra"
+++
Lescegra is an [OpenGL](http://www.opengl.org/) 3D engine and game
framework, written in strict ANSI C. It has a very clean, object
oriented design, and is easily extensible.

## Progress

| Section                      | Progress                                                            |
|:-----------------------------|:--------------------------------------------------------------------|
| Multipass Rendering          | 70% (interface basics, stencil shadow render manager)               |
| Rigid Body Physics           | 80% (using ODE)                                                     |
| Collision Detection          | 80% (using ODE)                                                     |
| Audio                        | 0% (probably using OpenAL)                                          |
| Embedded Scripting Language  | 40% (SWIG interface file generator, simple (non-oo) guile bindings) |

## Mission Statement

1. **Simplicity** -- The interface and the rendering/animation process should be easy to understand and mostly self explaining even for novices.
2. **Flexibility** -- It should be easy to integrate lescegra into existing projects, whatever toolkit, operating system or architecture is used.
3. **Extensibility** -- It should be easy to extend lescegra with custom functionality.
4. **Lightweight** -- Keep the dependencies to a minimum without reimplementing too much functionality.

## Features

- Object oriented design
  - Object system with single inheritance and virtual method dispatch
  - Runtime type information
  - Runtime checked casts
- Support classes
  - Matrix and vector function
  - Collision tests for planes, triangles, boxes
  - Random number generator, interpolation, lists
  - Endianess handling
- Scene graph
  - Rendering, animation and collision detection
  - Flexible bounding volume interface
  - Particle systems
  - Multitexturing
- Geometry
  - Continuous-Level-Of-Detail terrain
  - Quake II models
- Bitmap Loader
  - PNG
  - PCX
  - TGA

## Portability

Lescegra is known to compile on the following platforms:

| Architecture | Operating System       | Compiler                 |
|:-------------|:-----------------------|:-------------------------|
| PC x86       | GNU/Linux (Debian 3.1) | gcc 3.3, tcc 0.9.22      |
| PC x86       | Windows XP             | MS Visual Studio Express |
| PC amd64     | GNU/Linux (Debian 3.1) | gcc 4.0                  |
| SGI Mips     | Irix 6.5               | gcc, native cc           |

## Download

- Pre-release 20050218 (unstable)

  Source Tarball: [lescegra-20050218.tar.gz](/files/lescegra-20050218.tar.gz)

## Changelog

### Pre-release 20050218

- redesigned particle system
- fix build system for in-tree builds

### Pre-release 20050208

- real class system
- single inheritance with polymorphism
- runtime checked casts
- runtime type information
- portability improvements
- use autoconf
- GNU/Linux (gcc)
- Irix (gcc and cc)
- Windows (MinGW)
- continuous-level-of-detail terrain
- interpolation routines
- transparent single- and multipass multitexturing
- simplified state handling (lights, fog, material, textures)
- reference counting

### Pre-release 20031204

- geometries
- generic mesh class
- reworked md2 loader
- textures
- png bitmap loader
- material and texture classes
- improved error reporting
- improved build system
- terrain and octree fixes

### Pre-release 20030728

- completely new collision detection interface
- abstract bounding volume interface
- collisions with vertex, ray and sphere
- visibility determination
- improved terrain collision code
- generic octree implementation
- generic list and iterator interface
- array based list implementation
- documentation updates

### Pre-release 20030713

- lots of documentation updates
- endianess conversion routines
- error reporting facility
- TGA bitmap loader
- Pre-release 20030709
- first public pre-release
