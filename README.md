Image Compression using SVD, DWT, and DCT

This repository contains the code and documentation for various image compression techniques, focusing on Singular Value Decomposition (SVD), Discrete Wavelet Transform (DWT), and Discrete Cosine Transform (DCT). The project was developed by Matthew Futch and Soham Purushan.

Overview

Image compression is the process of reducing the amount of data required to represent an image. This project explores different methods for compressing images while maintaining visual quality. The main techniques implemented are:

Singular Value Decomposition (SVD)
Randomized Singular Value Decomposition (RSVD)
Discrete Wavelet Transform (DWT)
Discrete Cosine Transform (DCT)
Methods

Singular Value Decomposition (SVD)
SVD is a factorization method that decomposes a matrix into three other matrices: U, Σ, and Vt. For image compression:

Memory Reduction: Compresses an m x n image into matrices of size m x k, k x k, and k x n.
Optimization: An algorithm is developed to find the optimal number of singular values (k) that balance image quality and compression ratio.
Batch Processing: Handles large datasets efficiently by processing multiple images simultaneously.
Randomized Singular Value Decomposition (RSVD)
RSVD leverages the Johnson-Lindenstrauss Lemma to project high-dimensional data into a lower dimension while preserving the distances between data points. This allows for efficient and accurate SVD computations on large datasets.

Discrete Wavelet Transform (DWT)
DWT decomposes an image into wavelet coefficients at different scales and orientations. The process involves:

Thresholding: Small coefficients are set to zero to reduce data.
Optimization: Quantizes DWT coefficients at different decomposition levels to find the optimal compression level while maintaining image quality.
Discrete Cosine Transform (DCT)
DCT converts spatial image data into frequency coefficients:

Block Processing: The image is divided into blocks (e.g., 8x8 pixels), and each block is processed independently.
Adaptive Quantization: Quantization thresholds are adjusted based on local image characteristics, optimizing the balance between compression rate and image quality.
Performance Metrics

Peak Signal-to-Noise Ratio (PSNR)
PSNR is used to measure the quality of the reconstructed image after compression. A higher PSNR value indicates better image quality.

Optimization Process
An iterative process is used to find the smallest number of singular values or wavelet coefficients that retain image quality above a predefined threshold.

Results

The repository includes examples of compressed images using various techniques, along with the corresponding PSNR values to demonstrate the trade-offs between compression ratio and image quality.

Dependencies

Python 3.x
NumPy
SciPy
PyWavelets (for DWT)
Matplotlib (for visualization)
