#!/bin/bash

set -e
CKPT="./LanguageGroundedSemseg/ckpt/checkpoint-val_miou=38.34-step=32860.ckpt"
mkdir -p "./LanguageGroundedSemseg/ckpt"
if test -f "$CKPT"; then
    echo "$CKPT exists."
else
    echo "Download checkpoint"
    wget https://www.dropbox.com/s/1vm7rldsuyr5giu/checkpoint-val_miou%3D38.34-step%3D32860.ckpt?dl=1 -O "$CKPT"
fi
export PYTHONUNBUFFERED="True"
# export WEIGHTS_SUFFIX=$3
# export SUFFIX=$3

# export WEIGHTS_SUFFIX=$5

# export DATA_ROOT="/home/twsbvze943/chiawen/dataset"
export DATA_ROOT=`realpath $1`
# export PRETRAINED_WEIGHTS="/home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2/checkpoint-val_miou=38.34-step=32860.ckpt"
export OUTPUT_DIR_ROOT="./temp_output"
mkdir -p $OUTPUT_DIR_ROOT

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export LOG_DIR=$3

# Save the experiment detail and dir to the common log file
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"

# export CUDA_VISIBLE_DEVICES=0,1,2,3
pushd .
cd LanguageGroundedSemseg
python3 -m main \
    --log_dir $LOG_DIR \
    --dataset Scannet200Voxelization2cmDataset \
    --model Res16UNet34D \
    --batch_size 1 \
    --val_batch_size 1 \
    --scannet_path $DATA_ROOT \
    --stat_freq 100 \
    --visualize True \
    --visualize_path  $LOG_DIR/visualize \
    --num_gpu 1 \
    --balanced_category_sampling True \
    --weights ./ckpt/checkpoint-val_miou=38.34-step=32860.ckpt \
    --is_train False \
	--test_original_pointcloud True \
	--save_prediction True \
    --resume $LOG_DIR \

mv /home/twsbvze943/chiawen/Scannet200Voxelization2cmDataset/Res16UNet34D-/visualize/fulleval/*.txt $3
    # 2>&1 | tee -a "$LOG"

#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \
