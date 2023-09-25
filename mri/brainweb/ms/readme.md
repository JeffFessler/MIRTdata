brainweb phantom data,
downloaded sometime before 2012 from

http://mouldy.bic.mni.mcgill.ca/cgi/brainweb2?alias=phantom_1.0mm_msles2_crisp&download=1

If you use this data,
please cite the 1998 IEEE T-MI paper by Collins et al. from
[https://doi.org/10.1109/42.712135](https://doi.org/10.1109/42.712135)

One can load the `.fld` file in Julia using
```julia
using FileIO
data = load("phantom_1.0mm_msles2_crisp.fld")
```

Notes from the BrainWeb site.

In addition to the fuzzy tissue membership volumes,
a discrete anatomical model is provided which consists of a class label
(integer) at each voxel,
representing the tissue which contributes the most to that voxel

- 0 = Background
- 1 = CSF
- 2 = Grey Matter
- 3 = White Matter
- 4 = Fat
- 5 = Muscle/Skin
- 6 = Skin
- 7 = Skull
- 8 = Glial Matter
- 9 = Connective
- 10 = MS Lesion
