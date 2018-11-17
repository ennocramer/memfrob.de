+++
template = "post.html"
title = "Compile-Time Unique Keys"
date = 2008-01-13
description = "This articles describes my approach to generating compiler-verfied, unique keys."

[taxonomies]
categories = [ "Programming"]
tags = [ "C", "C++" ]

[extra]
author = "Enno Cramer"
+++
## The Problem

During the development of Lescegra I came across the need to augment, or annotate objects with random user-data. The initial case was that, for performace reasons, the octree code had to associate the lowest containing octree node with each object in the octree. Another use-case was to link geometries with their corresponding physics body (used in the falling_cubes demo).

In both cases, the annotated object was completely oblivious of the additional information. Geometries don't know (and should not) about octrees or physics. This made it unfeasible to simply add additional fields to the geometry structure. Also, these two cases are hardly the only ones that will pop up, so a more generic approach was called for.

The rough approach is, of course, for each annotate-able object to carry around some kind of map, which other parts can use to store arbitrary object. Depending on estimated average number of annotations, different implementations are preferable, but that is not what I want to talk about here. Instead, I want to focus on the keys to this map.

## Requirements

The annotation system has two immediate requirements:

- Extensible

  The overall set of keys is not known. Users of the annotation system must be able to define new annotation keys, without risking collisions with other user they may not know about.

- Safe

  Annotation keys must be verified at compile time. Users of the annotation system must be not be able to accidently use a wrong annotation key due to a typo, or changes in key definition.

### General Interface

```c
void annotate(object_t* object, key_t key, value_t value);
value_t get_annotation(const object_t* object, key_t key);
```

## The Non-Solutions

There are two annotation key types that come to mind immediately, strings and enums. Unfourtunately, both onyl fulfill only one of the two requirements.

### Enums

```c
typedef enum { KEY1, KEY2, ... } key_t;
```

Using an enumeration as the key type allows the compiler to verify that each used key is actually a valid key. It also makes key comparisons very fast. Unfortunately, it means that all keys have to be defined in one place. This makes it impossible to extend the key space without modifying the annotation code itself.

### Strings

```c
typedef const char * key_t;
```

Using strings as annotation keys solves the central definition problem of enums. Anyone who needs to annotate an object can simply pick a key string. Uniqueness can be (more or less) guaranteed by including a namespace pre- or post-fix in the key string.

The descriptive property of key strings is also helpful during debugging.

Strings, however, introduce the problem of typos. The compiler cannot check anymore, that a key, used to store or retrieve an annotation, doesn't contain a typo.

## Addresses As Keys

The important thing to realize is, the problem of allocating unique and compiler-verified objects has already been solved in the C-linker. Whenever the linker combines object files into a binary, it has to allocate a unique address for each object (read: variable). We can piggyback on this process by defining one object per annotation, and using its address as the annotation key.

```c
struct { ... } key_object;
typedef const struct key_object * key_t;
```

We could use an empty struct key_object, but, as a debugging aid, we'll include the name of the annotation key as a constant string. Also, we'll add two macros (DECLARE_KEY and DEFINE_KEY) to make declaration and definition of annotation keys easier.

### Final API

```c
struct { const char * name; } key_object;

typedef const struct key_object * key_t;
typedef void * value_t;

#define DECLARE_KEY(name) \
    extern const key_t name

#define DEFINE_KEY(name) \
    static const struct key_object name ## _obj = { #name }; \
    const key_t name = &name ## _obj

void annotate(object_t* object, key_t key, value_t value);
value_t get_annotation(const object_t* object, key_t key);
```

### Example

*foo.h*

```c
/* may be omitted if the annotation is used solely within a single source file */
DECLARE_KEY(MY_KEY);
```

*foo.c*

```c
DEFINE_KEY(MY_KEY);

void limit_passes(object_t* obj) {
  int * number_of_passes = get_annotation(obj, MY_KEY);

  if (number_of_passes == NULL) {
    number_of_passes = malloc(*number_of_passes);
    *number_of_passes = 0;
    annotate(obj, MY_KEY, number_of_passes);
  }

  *number_of_passes += 1;

  if (*number_of_passes == LIMIT) {
    spank_object(obj);
  }
}
```
