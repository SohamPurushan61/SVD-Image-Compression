import numpy as np
import pywt
import matplotlib.pyplot as plt
from PIL import Image

def compress_image(image, level):
    # Perform wavelet transform
    coeffs = pywt.wavedec2(image, 'db4', level=level)
    
    # Set coefficients below a certain threshold to zero
    threshold = 0.1 * max([np.max(np.abs(c)) if isinstance(c, np.ndarray) else np.max(np.abs(c[0])) for c in coeffs])
    coeffs[0] = (np.abs(coeffs[0]) > threshold) * coeffs[0]
    for i in range(1, len(coeffs)):
        coeffs[i] = tuple((np.abs(c) > threshold) * c for c in coeffs[i])
    
    # Reconstruct compressed image
    compressed_image = pywt.waverec2(coeffs, 'db4')
    
    return compressed_image, coeffs

def decompress_image(coeffs):
    # Perform inverse wavelet transform
    original_image = pywt.waverec2(coeffs, 'db4')
    
    return original_image

# Load the image
image_path = "C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg"  # Replace with your image path
image = Image.open(image_path).convert('L')  # Convert the image to grayscale
image = np.array(image, dtype=np.float64)

# Set the desired compression level
level = 3

# Compress the image
compressed_image, coeffs = compress_image(image, level)

# Decompress the image
reconstructed_image = decompress_image(coeffs)

# Display the original, compressed, and reconstructed images
plt.figure(figsize=(15, 5))
plt.subplot(131)
plt.imshow(image, cmap='gray')
plt.title('Original Image')
plt.subplot(132)
plt.imshow(compressed_image, cmap='gray')
plt.title('Compressed Image')
plt.subplot(133)
plt.imshow(reconstructed_image, cmap='gray')
plt.title('Reconstructed Image')
plt.show()