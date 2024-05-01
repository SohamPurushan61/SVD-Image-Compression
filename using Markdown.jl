using Markdown, InteractiveUtils, Pkg, ImageQualityIndexes, Plots, Images, FileIO, PlutoUI, LinearAlgebra, ImageCore, Statistics

Pkg.add(["Images", "FileIO", "PlutoUI", "LinearAlgebra", "Plots", "ImageCore", "Statistics", "ImageQualityIndexes"])

gr()

# Your custom grayscale conversion function
function custom_rgb2gray(image::Array{<:ColorTypes.RGB,2})
    # Apply the luminosity method
    return 0.299 .* red.(image) .+ 0.587 .* green.(image) .+ 0.114 .* blue.(image)
end

# Function to reconstruct the image using SVD components
function reconstruct_image(U, S, Vt, k)
    if k > min(size(U, 2), size(Vt, 1))
        error("k is too large for the dimensions of U and Vt.")
    end
    return U[:, 1:k] * Diagonal(S[1:k]) * Vt[1:k, :]
end

function optimize_k(original_image_matrix, max_k_reduction_steps, acceptable_psnr_value)
    U, S, Vt = svd(original_image_matrix)
    max_pixel_value = maximum(original_image_matrix)
    best_k = length(S)
    current_k = best_k
    step_size = max(1, best_k ÷ max_k_reduction_steps)

    original_image_matrix_normalized = original_image_matrix ./ max_pixel_value

    for i in 1:max_k_reduction_steps
        reconstructed_image = reconstruct_image(U, S, Vt, current_k)
        reconstructed_image_normalized = reconstructed_image ./ max_pixel_value

        # Calculate PSNR using the ImageQualityIndexes.jl package
        psnr_result = assess(PSNR(), original_image_matrix_normalized, reconstructed_image_normalized)
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
    best_reconstructed_image_normalized = best_reconstructed_image ./ max_pixel_value
    return best_k, best_reconstructed_image_normalized
end

# Load the image once
image_path = "C:/Users/soham/Pictures/Math 590 Project/joshua-j-cotten-8kXdIXob78U-unsplash.jpg"  # Replace with your image path
original_image = load(image_path)

# Convert the image to grayscale
original_image_gray = custom_rgb2gray(original_image)

# Convert the grayscale image to a Float64 matrix for processing
original_image_matrix = convert(Array{Float64}, original_image_gray)

# Define the maximum number of steps you want to reduce 'k' by
max_k_reduction_steps = 10

# Define the quality threshold
acceptable_psnr_value = 1

# Call the optimize_k function to find the best 'k'
best_k, best_reconstructed_image_normalized = optimize_k(original_image_matrix, max_k_reduction_steps, acceptable_psnr_value)

# Display the results
println("The best k value found is: $best_k")

# Assess PSNR using the normalized images
psnr_result = assess(PSNR(), original_image_matrix ./ maximum(original_image_matrix), best_reconstructed_image_normalized)
println("PSNR calculated by ImageQualityIndexes.jl: ", psnr_result)