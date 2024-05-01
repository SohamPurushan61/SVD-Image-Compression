import numpy as np
import pywt
from skimage.metrics import peak_signal_noise_ratio as compare_psnr
from PIL import Image

def select_and_quantize_coeffs(coeffs, thresholds):
    approx_coeffs = coeffs[0]
    detail_coeffs = coeffs[1:]
    
    quantized_coeffs = []
    for c, thresh in zip(detail_coeffs, thresholds):
        quantized_c = tuple(np.where(np.abs(arr) > thresh, np.sign(arr) * (np.abs(arr) - thresh), 0) for arr in c)
        quantized_coeffs.append(quantized_c)
    
    return [approx_coeffs] + quantized_coeffs

def dynamic_threshold(coeffs):
    thresholds = [np.std(c)*0.5 for c in coeffs[1:]]
    return thresholds

def automatic_level_determination(image, wavelet='db4', max_levels=5, quality_threshold=20):
    original_image = np.array(image, dtype=np.float32)
    best_level = 0
    best_quality = 0

    for level in range(1, max_levels + 1):
        padded_image = np.pad(original_image, [(0, -original_image.shape[0] % (2**level)), (0, -original_image.shape[1] % (2**level))], mode='constant')

        coeffs = pywt.wavedec2(padded_image, wavelet, level=level)
        thresholds = dynamic_threshold(coeffs)
        quantized_coeffs = select_and_quantize_coeffs(coeffs, thresholds)
        reconstructed_image = pywt.waverec2(quantized_coeffs, wavelet)

        reconstructed_image = reconstructed_image[:original_image.shape[0], :original_image.shape[1]]

        quality = compare_psnr(original_image, reconstructed_image, data_range=original_image.max() - original_image.min())
        
        print(f"Level {level}, PSNR: {quality}, Thresholds: {thresholds}")
        
        if quality > best_quality and quality > quality_threshold:
            best_quality = quality
            best_level = level

        if quality < quality_threshold:
            break

    return best_level, best_quality

image_path = 'C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg'
image = Image.open(image_path).convert('L')
image_np = np.array(image)

best_level, best_psnr = automatic_level_determination(image_np, wavelet='db4')
print(f"Best level: {best_level} with PSNR: {best_psnr}")