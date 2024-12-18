# Stable Diffusion M Chips

A macOS application for generating images using the Stable Diffusion 2-1 model, optimized for Apple M chips. This application leverages the Apple repository for model resources.

## Introduction

This application uses the Stable Diffusion 2-1 model to generate images based on textual prompts. The user interface allows you to enter a prompt and choose from several predefined image sizes.

## Prerequisites

- macOS with an Apple M1 or M2 chip
- Xcode installed
- The following CoreML model files from the Apple repository:
  - `TextEncoder.mlmodelc`
  - `unet.mlmodelc`
  - `VAEDecoder.mlmodelc`

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/The-Real-Dr-Joss/Stable-Diffusion-M-Chips.git
   ```

## Using Stable Diffusion 2.1 with Core ML

### Download CoreML files from Google Drive :
  ```google drive link
    https://drive.google.com/drive/folders/1nNytUky09hoWIzvtj-xIE40UlsMyzMF9?usp=sharing
  ```
###Or convert the model on your computer

Follow these steps to convert the model to Core ML format if you haven’t already:

### Prerequisites

1. **Homebrew** - Install Homebrew if it is not already installed:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Git LFS** - Install Git Large File Storage:
   ```bash
   brew install git-lfs
   ```

3. **Python** - Ensure Python 3.10+ is installed:
   ```bash
   python3 --version
   ```
   If not, install it using Homebrew:
   ```bash
   brew install python@3.10
   ```

4. **Required Python Libraries** - Install the following libraries:
   - `torch`
   - `torchvision`
   - `diffusers`
   - `coremltools`

### Steps to Convert the Model

1. Download Stable Diffusion 2.1 from Hugging Face:
   - Visit [Stable Diffusion 2.1 on Hugging Face](https://huggingface.co/stabilityai/stable-diffusion-2-1).
   - Create an account and accept the model license agreement.
   - Clone the repository using `git-lfs`:
     ```bash
     git lfs install
     git clone https://huggingface.co/stabilityai/stable-diffusion-2-1
     ```

2. Set up the Python environment:
   - Create a virtual environment and activate it:
     ```bash
     python3 -m venv sd-env
     source sd-env/bin/activate
     ```
   - Install the required libraries:
     ```bash
     pip install torch torchvision diffusers coremltools
     ```

3. Convert the model to Core ML:
   - Open a Python script or the Python shell:
     ```bash
     python3
     ```
   - Run the following code:
     ```python
     from diffusers import StableDiffusionPipeline
     import coremltools as ct

     # Load the Stable Diffusion model
     pipeline = StableDiffusionPipeline.from_pretrained("stabilityai/stable-diffusion-2-1")

     # Convert the model to Core ML
     coreml_model = ct.convert(
         pipeline.unet, 
         inputs=[ct.TensorType(shape=(1, 4, 64, 64))],
     )

     # Save the model
     coreml_model.save("StableDiffusion2_1.mlmodel")
     ```

4. Verify the Conversion:
   - Check that the `StableDiffusion2_1.mlmodel` file was created in your working directory.
   - Use Xcode or Core ML tools to test the model.

---

## Troubleshooting

- **Error: Missing Dependencies**
  Ensure all required libraries are installed by running:
  ```bash
  pip install torch torchvision diffusers coremltools
  ```

- **Error: Incompatible Python Version**
  Check your Python version and ensure it is 3.10 or newer.

---

## Additional Resources

- [Hugging Face Documentation](https://huggingface.co/docs)
- [Core ML Tools Documentation](https://coremltools.readme.io/)

---

You’re all set! For further assistance, feel free to open an issue or contact me.
