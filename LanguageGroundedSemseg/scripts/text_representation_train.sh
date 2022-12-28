#!/bin/bash

# Exit script when a command returns nonzero state
export PYTHONUNBUFFERED="True"

export BATCH_SIZE=$1
export MODEL=Res16UNet34D
export DATASET=Scannet200Textual2cmDataset

export POSTFIX=$2
export ARGS=$3

export DATA_ROOT="/home/twsbvze943/chiawen/dataset"
export LIMITED_DATA_ROOT="/mnt/Data/ScanNet/limited/"$DATASET_FOLDER
export OUTPUT_DIR_ROOT="/home/twsbvze943/chiawen/output"
export PRETRAINED_WEIGHTS="/home/twsbvze943/chiawen/Res16UNet34D.ckpt"

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")

export LOG_DIR=$OUTPUT_DIR_ROOT/$DATASET/$MODEL-$POSTFIX

# Save the experiment detail and dir to the common log file
# print("LOG_DIR",LOG_DIR)
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"

export CUDA_VISIBLE_DEVICES=2,3
python -m main \
    --log_dir $LOG_DIR \
    --dataset $DATASET \
    --model $MODEL \
    --batch_size $BATCH_SIZE \
    --val_batch_size $BATCH_SIZE \
    --train_limit_numpoints 1400000 \
    --scannet_path $DATA_ROOT \
    --stat_freq 100 \
    --num_gpu 2 \
    --balanced_category_sampling False \
    --use_embedding_loss True \
    --resume /home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2/checkpoint-val_miou=38.34-step=32860.ckpt \
    --loss_type cross_entropy\
    $ARGS \
    2>&1 | tee -a "$LOG"

#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \