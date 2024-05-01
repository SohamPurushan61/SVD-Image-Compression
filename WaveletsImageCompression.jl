using Pkg
Pkg.add(["Wavelets", "Images", "FileIO", "ImageCore", "ColorTypes", "ColorVectorSpace"])
using Wavelets
using Images
using FileIO
using ImageCore
using ColorTypes
using ColorVectorSpace

function compress_image(image::Matrix{T}, level::Int) where T<:Real
    # Perform wavelet transform
    coeffs = wavedec2(image, level, wavelet(WT.db4))
    
    # Set coefficients below a certain threshold to zero
    threshold = 0.1 * maximum(abs.(coeffs))
    coeffs = map(x -> abs(x) > threshold ? x : 0, coeffs)
    
    # Reconstruct compressed image
    compressed_image = waverec2(coeffs, wavelet(WT.db4))
    
    return compressed_image
end

function decompress_image(compressed_image::Matrix{T}, level::Int) where T<:Real
    # Perform inverse wavelet transform
    coeffs = wavedec2(compressed_image, level, wavelet(WT.db4))
    
    # Reconstruct original image
    original_image = waverec2(coeffs, wavelet(WT.db4))
    
    return original_image
end

# Load the image
image_path = "C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg"  # Replace with your image path
color_image = load(image_path)

# Convert the image to grayscale
image = Gray.(color_image)

# Convert the grayscale image to a Float64 matrix for processing
image_matrix = convert(Array{Float64}, image)

# Set the desired compression level
level = 3

# Compress the image
compressed_image = compress_image(image_matrix, level)

# Decompress the image
reconstructed_image = decompress_image(compressed_image, level)

# Display the original, compressed, and reconstructed images
println("Original image:")
display(image)
println("Compressed image:")
display(Gray.(compressed_image))
println("Reconstructed image:")
display(Gray.(reconstructed_image))