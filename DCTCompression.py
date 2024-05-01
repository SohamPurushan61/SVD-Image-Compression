import numpy as np
import cv2
from scipy.fftpack import dct, idct
import matplotlib.pyplot as plt


# 2D DCT
def dct2(a):
    return dct(dct(a.T, norm='ortho').T, norm='ortho')

# 2D IDCT
def idct2(a):
    return idct(idct(a.T, norm='ortho').T, norm='ortho')

# Load image
image = cv2.imread('C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg', cv2.IMREAD_GRAYSCALE)
image = np.float32(image)  # Convert to float to prevent rounding errors

# Compute 2D DCT
dct_image = dct2(image)

# Set low frequencies to zero for compression
dct_image[50:, 50:] = 0

# Compute 2D IDCT
reconstructed_image = idct2(dct_image)

# Display original and reconstructed images
plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.imshow(image, cmap='gray')
plt.title('Original')
plt.axis('off')

plt.subplot(1, 2, 2)
plt.imshow(reconstructed_image, cmap='gray')
plt.title('Reconstructed')
plt.axis('off')

plt.show()