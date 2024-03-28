# DLCV Final Project ( 3D ScanNet200 long-tail segmentation )
This project is primarily forked from [RozDavid](https://github.com/RozDavid)/[LanguageGroundedSemseg](https://github.com/RozDavid/LanguageGroundedSemseg)
## Poster

![DLCV_final_hhsc_poster](https://github.com/ehsienmu/DLCV-Fall-2022-Final-Project-challenge-2-hhsc/assets/43429849/906dca68-4e8c-4a9b-be0c-d5e9b88fd5b4)

## Installation
The codebase was developed and tested on Ubuntu 20.04, with various GPU versions *[RTX_2080, RTX_3060, RXT_3090, RXT_A6000]* and NVCC 11.x

We used an Anaconda environment with the dependencies, to install run 

```sh
conda env create -f ./LanguageGroundedSemseg/config/lg_semseg.yml
conda activate lg_semseg
pip install -r requirements.txt
```

Additionally, [MinkowskiEngine](https://github.com/NVIDIA/MinkowskiEngine) has to be installed manually with a specified CUDA version. 
E.g. for CUDA 11.1 run 

```sh
export CUDA_HOME=/usr/local/cuda-11.1
pip install -U git+https://github.com/NVIDIA/MinkowskiEngine -v --no-deps --install-option="--blas=openblas"

pip install pytorch-lightning==1.6.5
pip install open3d==0.15.2
```

## How to run our code?

We expect the dataset directory structure be like:
```bash=
dataset
├── test
│   ├── scene0500_00.ply
│   ├── scene0500_01.ply
│   ...
├── test.txt
├── train
│   ├── scene0000_00.ply
│   ├── scene0000_01.ply
│   ...
├── train.txt
```

Please follow the instructions to run our code.
```bash=
# Train
bash train.sh <Path to train_data folder> <Path to train.txt file> 

# Inference
bash inference.sh <Path to test_data folder> <Path to test.txt file> <Path to output .txt file>

# For example, if dataset is in /home/
# Run `bash train.sh /home/dataset /home/dataset/train.txt`
# Run `bash infernce.sh /home/dataset /home/dataset/test.txt ./output`

```



