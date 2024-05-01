import Pkg;

Pkg.add(["Images", "FileIO", "PlutoUI", "LinearAlgebra", "Plots", "ImageCore", "Statistics", "ImageQualityIndexes", "ColorTypes", "ColorVectorSpace"])

using ColorTypes
using ColorVectorSpace
using FileIO
using ImageQualityIndexes
using Images
using LinearAlgebra
using Statistics

# Function to normalize an image matrix to the range [0, 1]
function normalize_image_matrix(image_matrix)
    return (image_matrix .- minimum(image_matrix)) ./ (maximum(image_matrix) - minimum(image_matrix))
end

# Function to reconstruct the image using SVD components
function reconstruct_image(U, S, Vt, k)
    if k > min(size(U, 2), size(Vt, 1))
        error("k is too large for the dimensions of U and Vt.")
    end
    return clamp.(U[:, 1:k] * Diagonal(S[1:k]) * Vt[1:k, :], 0.0, 1.0)
end

function optimize_k(original_image_matrix, max_k_reduction_steps, acceptable_psnr_value)
    U, S, Vt = svd(original_image_matrix)
    best_k = length(S)
    current_k = best_k

    # Change the step size to a smaller value for less severe compression
    step_size = max(1, best_k ÷ (10 * max_k_reduction_steps))

    for i in 1:max_k_reduction_steps
        reconstructed_image = reconstruct_image(U, S, Vt, current_k)

        # Calculate PSNR using the ImageQualityIndexes.jl package
        psnr_result = assess(PSNR(), original_image_matrix, reconstructed_image)
        current_quality = psnr_result

        println("Iteration: $i, current k: $current_k, PSNR: $current_quality")

        if current_quality < acceptable_psnr_value
            println("Quality below threshold at k: $current_k, stopping optimization.")
            break
        else
            best_k = current_k
        end
        current_k -= step_size
    end

    best_reconstructed_image = reconstruct_image(U, S, Vt, best_k)
    return best_k, best_reconstructed_image
end

# Load the image once
image_path = "C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg"  # Replace with your image path
original_image = load(image_path)

# Convert the image to YCbCr
original_image_ycbcr = convert.(YCbCr, original_image)

# Extract the Y channel
original_image_y = map(c -> c.y, original_image_ycbcr)

# Convert the Y channel to a Float64 matrix for processing
original_image_matrix = convert(Array{Float64}, original_image_y)

# Normalize the original image matrix
original_image_matrix = normalize_image_matrix(original_image_matrix)

# Define the maximum number of steps you want to reduce 'k' by
max_k_reduction_steps = 10

# Define the quality threshold
acceptable_psnr_value = 7

# Call the optimize_k function to find the best 'k'
best_k, best_reconstructed_image = optimize_k(original_image_matrix, max_k_reduction_steps, acceptable_psnr_value)

# Display the results
println("The best k value found is: $best_k")

# Check the range of your original and reconstructed image data
println("Original image data range: ", extrema(original_image_matrix))
println("Reconstructed image data range: ", extrema(best_reconstructed_image))

# Recalculate the PSNR with the original images (not rescaled)
psnr_result = assess(PSNR(), original_image_matrix, best_reconstructed_image)
println("PSNR calculated by ImageQualityIndexes.jl: ", psnr_result)