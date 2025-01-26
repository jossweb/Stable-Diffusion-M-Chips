# Stable Diffusion M Chips

A macOS application for generating images using the Stable Diffusion 2-1 model, optimized for Apple M chips. This application leverages the Apple repository for model resources.

## Introduction

This application uses the Stable Diffusion 2-1 model to generate images based on textual prompts. The user interface allows you to enter a prompt and choose from several predefined image sizes.

## Prerequisites

- macOS with an Apple M chip
- Xcode installed
- The following CoreML model files from the Apple repository:
  - `TextEncoder.mlmodelc`
  - `unet.mlmodelc`
  - `VAEDecoder.mlmodelc`

  And special_tokens_map.json, tokenizer_config.json, vocab.json and merges.txt. You can collect them at huggingface.co

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
#Or convert the model on your computer (use : https://github.com/apple/ml-stable-diffusion)

to finish place the 3 models in a Resources group at the root of the project
---

## Additional Resources

- [Hugging Face Documentation](https://huggingface.co/docs)
- [Core ML Tools Documentation](https://coremltools.readme.io/)
---

You’re all set! For further assistance, feel free to open an issue or contact me.
