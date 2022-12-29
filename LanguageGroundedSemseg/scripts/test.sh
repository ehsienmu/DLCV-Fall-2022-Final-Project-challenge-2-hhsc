#!/bin/bash

export PYTHONUNBUFFERED="True"

export DATASET=Scannet200Voxelization2cmDataset

export MODEL=$1  #Res16UNet34C, Res16UNet34D
export BATCH_SIZE=$2
# export WEIGHTS_SUFFIX=$3
export SUFFIX=$3
export ARGS=$4

# export WEIGHTS_SUFFIX=$5

export DATA_ROOT="/home/twsbvze943/chiawen/dataset"
export PRETRAINED_WEIGHTS="/home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2/checkpoint-val_miou=38.34-step=32860.ckpt"
export OUTPUT_DIR_ROOT="/home/twsbvze943/chiawen"

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export LOG_DIR=$OUTPUT_DIR_ROOT/$DATASET/$MODEL-$SUFFIX

# Save the experiment detail and dir to the common log file
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"

export CUDA_VISIBLE_DEVICES=2,3
python -m main \
    --log_dir $LOG_DIR \
    --dataset $DATASET \
    --model $MODEL \
    --batch_size $BATCH_SIZE \
    --val_batch_size $BATCH_SIZE \
    --scannet_path $DATA_ROOT \
    --stat_freq 100 \
    --visualize True \
    --visualize_path  $LOG_DIR/visualize \
    --num_gpu 1 \
    --balanced_category_sampling True \
    --weights $PRETRAINED_WEIGHTS \
    --is_train False \
	--test_original_pointcloud True \
	--save_prediction True \
    --resume $LOG_DIR \
    $ARGS \
    2>&1 | tee -a "$LOG"

#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \