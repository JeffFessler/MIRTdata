This is a copy of some of the data from
https://web.eecs.umich.edu/~fessler/irt/reproduce/19/lin-19-edp/data

This directory contains the data (in Matlab .mat files)
needed for reproducing the results in the paper

Efficient Dynamic Parallel MRI Reconstruction for the Low-Rank Plus Sparse Model
IEEE Trans. on Computational Imaging, 5(1):17-26, 2019,
by Claire Lin and Jeffrey A. Fessler, EECS Department, University of Michigan
See [http://doi.org/10.1109/TCI.2018.2882089]

The Matlab code for these results is in:
https://github.com/JeffFessler/reproduce-l-s-dynamic-mri


There are k-space data files here:
 abdomen_dce_ga.mat
 aperiodic_pincat.mat
 cardiac_cine_R6.mat
 cardiac_perf_R8.mat
 cardiac_perf_full_single (full k-space data for perfusion example)

And one output images file "Xinf.mat"
that contains the converged results (X_∞) for the 4 cases:
   perf: [128x128x40 single]
   cine: [256x256x24 single]
 pincat: [128x128x50 single]
    abd: [384x384x28 double]

Caution: the forward model used in Otazo's L+S code uses an "ifft"
in the forward direction and an "fft" in the adjoint, so you may
need to adjust your system model accordingly.  See 
https://juliaimagerecon.github.io/Examples/generated/mri/5-l-plus-s/

File "Xinf_cine.mat" has an updated version of X_∞ for the cine case.
It might contain the X_∞ that was used for the results in the paper.
(todo: verify)

We gratefully acknowledge the following data sources.
The cardiac data and abdominal data came from Ricardo Otazo:
http://www.cai2r.net/research/ls-reconstruction
The pincat data came from Mathews Jacob:
https://research.engineering.uiowa.edu/cbig/content/matlab-codes-k-t-slr


The abdomen_dce_ga.mat file has these variables in it:

 b1         384x384x12            28311552  double    complex   
 k          384x600                3686400  double    complex   
 kdata      384x600x12            44236800  double    complex   
 w          384x600                1843200  double             

real(k) and imag(k) are the kx and ky k-space sampling coordinates
kx = 384*real(k) is 384 x 600 (real), which is 600 spokes with 384 samples each
ky = 384*imag(k)
plot(kx, ky, '.')
w is density compensation factors (DCF)
b1 is the sensitivity maps for the 12 coils
kdata is the noisy GA k-space data for 12 coils

The 2015 paper by Otazo et al. (doi 10.1002/mrm.25240) used 8 spokes
per frame so 600/8 = 75 frames

To apply density-compensated gridding of this data, do this in Matlab:

load abdomen_dce_ga.mat
N = 384
% kx = N*real(k);
% ky = N*imag(k);
kx = N*imag(k);
ky = -N*real(k); % fix orientation
plot(kx, ky, '.'), axis square
dx = 1/N
om = 2*pi*dx*[kx(:) ky(:)]; % omega for nufft code (-pi to pi)
minmax(om) % only goes to pi/2 so something might be awry here?
plot(om(:,1), om(:,2), '.'), axis_pipi
A = Gnufft(true(N,N), {om, [N N], [6 6], 2*[N N], [N N]/2, 'table', 2^10, 'minmax:kb'})
% DCF gridding recon of 1st coil using *all* data (ignoring time):
x1 = reshape(A' * col(w .* kdata(:,:,1)), N, N);
im(x1)


2019-10-26 email from Li Feng says that the sampling should be -0.5 to 0.5
rather than from -0.25 to 0.25 as seen in the original MCNUFFT.m code that
went with the Otazo et. al L+S paper.

2019-10-29 email from Ricardo Otazo has this updated file
abdomen_dce_ga_v2.mat with these variables in it:

b1: [384x384x12 double]
kdata: [768x600x12 double]
k: [768x600 double]
w: [768x600 double]

The b1 maps in the two files are the same if you normalize the new one
b1 = b1 / max(abs(b1(:)))
The "k" data ranges from -0.499 to 0.499 in this new file.

This new data file was not used in our 2019 L+S paper, but can be useful
for other experiments going forward.

To apply density-compensated gridding of this data, do this in Matlab:

load abdomen_dce_ga_v2.mat
N = 384
kx = N*imag(k);
ky = -N*real(k); % fix orientation
plot(kx, ky, '.'), axis square
dx = 1/N
om = 2*pi*dx*[kx(:) ky(:)]; % omega for nufft code (-pi to pi)
minmax(om) % -pi to pi, yay!
plot(om(:,1), om(:,2), '.'), axis_pipi
A = Gnufft(true(N,N), {om, [N N], [6 6], 2*[N N], [N N]/2, 'table', 2^10, 'minmax:kb'})
% DCF gridding recon of 1st coil using *all* data (ignoring time):
x1 = reshape(A' * col(w .* kdata(:,:,1)), N, N);
im(x1)


For reproducing the results in the supplement of our paper, use the initial
version of abdomen_dce_ga.mat, but for any future work please use the data in
abdomen_dce_ga_v2.mat
