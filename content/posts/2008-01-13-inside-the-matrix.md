+++
template = "post.html"
title = "Inside the Matrix"
date = 2008-01-13
description = "A little article on the math behind transformations in euclidean space, using vectors, homogeneous coordinates, and matrices."

[taxonomies]
categories = [ "Math" ]
tags = [ "Computer Graphics", "Linear Algebra" ]

[extra]
author = "Enno Cramer"
+++
## Vectors

A vector is simply a tuple of numbers, either written in a row as

    v = (v1, v2, ..., vn),

or in a column as

        /  v1 \
        |  v2 |
    v = | ... |.
        \  vn /

For brevity, I'll mostly stick to the row format in this text, but
they are absolutely equivalent.

In computer graphics, we can use vectors to hold directions and
distances in euclidean space.  A vector then contains one number for
each dimension of space, representing the distance along a single
axis.  Thus `v = (x, y, z)` is only a short form of writing `v = x*a_x
+ y*a_y + z*a_z`, where `a_x`, `a_y`, and `a_z` are the three axes of
space.

We can also use vectors to represent positions in space, by using a
reference point `O` and storing the distance between a point and the
reference point.  However, distances and points now look the same,
which is a Bad Thing, because they aren't.  This is where homogeneous
coordinates come into play.  We can solve this ambiguity by adding
another element, the homogenous coordinate, to the vector.  For
distances, this coordinate is 0, for points it is 1. (Actually, for
points it must only be non-0, but I won't go into all the details of
homogeneous coordinates.  Suffice to say that a vector `v = (x, y, z,
w)` with `w != 0` represents the same point as `v' = (x/w, y/w, z/w,
1)`.)

With this addition, the vector `v = (x, y, z, w)` is a short form of
writing `v = x*a_x + y*a_y + z*a_z + w*O`.  Vectors are always
relative to a /coordinate system/, defined by the three axes `a_x`,
`a_y`, and `a_z`, and the reference point `O`, also called the
/origin/.

## Transformations

Affine transformations, such as scaling, rotation, translation,
shearings, and any combination thereof, can be expressed by defining a
new coordinate system.  Scalings are simply changes to the length of
the axes, rotations change the orientation of the axes, translations
move the reference point, and shearing change the angles between the
axes.

For example, an object in a coordinate system whose axes all have a
length of two units, is twice as big as the same object in a
coordinate system whose axes all have a length of one unit.

Now, if we express the axes and origin of the transformed coordinate
system in terms of the original coordinate system, we can apply the
transformation to any vector (point or distance) by simply evaluating
the equation given above.

We'll call the transformed coordinate system `T`, with axes `T_x`,
`T_y`, and `T_z`, and origin `T_O`, and the original coordinate system
`O`, with axes `O_x`, `O_y`, and `O_z`, and origin `O_O`.  The
transformed coordinate system `T` is defined relative to the original
coordinate system `O`:

    T_x = (T_xx, T_xy, T_xz, 0)
    T_y = (T_yx, T_yy, T_yz, 0)
    T_z = (T_zx, T_zy, T_zz, 0)
    T_O = (T_Ox, T_Oy, T_Oz, 1)

(Notice how the axes all have a homogeneous coordinate of 0, as they
are distances, and the origin has a homogeneous coordinate of 1, as it
is a point.)

With these definitions, we get

    v' = (x', y', z', w') = x*T_x + y*T_y + z*T_z + w*T_O

       =   x * (T_xx * O_x + T_xy * O_y + T_xz * O_z + 0 * O_O)
         + y * (T_yx * O_x + T_yy * O_y + T_yz * O_z + 0 * O_O)
         + z * (T_zx * O_x + T_zy * O_y + T_zz * O_z + 0 * O_O)
         + w * (T_Ox * O_x + T_Oy * O_y + T_Oz * O_z + 1 * O_O)

       =   (x*T_xx + y*T_yx + z*T_zx + w*T_Ox) * O_x
         + (x*T_xy + y*T_yy + z*T_zy + w*T_Oy) * O_y
         + (x*T_xz + y*T_yz + z*T_zz + w*T_Oz) * O_z
         + (x*   0 + y*   0 + z*   0 + w*   1) * O_O.

Now, this looks rather complicated at first sight, but if you look
closely, you'll notice a certain pattern.


## Enter the Matrix

People familiar with linear algebra will probably recognize the
pattern.  It look suspiciously like the product of matrizes, and
indeed, it can be written as such.

We have to combine the axes and origin of the transformed coordinate
system into a 4x4 matrix `M`.  This can be done in more than one way,
but I'll stick to the convention used by OpenGL.  The other
possibilities lead to different multiplication orders (remember matrix
multiplication is not commutative) and vector notations.

If we combine the axes and origin such that each vector occupies one
column of the final matrix, and consider the vector as a column matrix
(a matrix with only a single column, much like the column notation of
vectors), the transformation can be expressed as a simple

    v' = M * v

         / T_xx T_yx T_zx T_Ox \   / x \
         | T_xy T_yy T_zy T_Oy |   | y |
       = | T_xz T_yz T_zz T_Oz | * | z |.
         \    0    0    0    1 /   \ w /


## Working with Transformations

Now, that we have shown how affine transformations can be expressed as
matrix multiplications, it is trivial to show how to combine
transformations.

Suppose we want to move and scale an object.  We have the scaling
transformation stored in the matrix `S`, and the translation in the
matrix `T`.

    v' = T * (S * v)
       = (T * S) * v
       = TS * v

Thus, we can combine both transformations into a single matrix, simply
by multiplying the two transformation matrizes.  Note, however, that
the order is important.  `T * S` moves the scaled object, whereas `S *
T` scales the already moved object, /thus amplifying the movement/.

When using OpenGL, transformations are accumulated from left to right.
Thus, to produce the transform `T * S`, one has to call the
gl-functions in the order

    glTranslate(...);
    glScale(...);

Or, put another way, the first transformation affecting an object, is
the transformation last executed.

