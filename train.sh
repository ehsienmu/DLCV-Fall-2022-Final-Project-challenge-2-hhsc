#!/bin/bash
set -e
export PYTHONUNBUFFERED="True"
# /home/twsbvze943/chiawen/final-project-challenge-2-hhsc/LanguageGroundedSemseg/dataset/val_t.txt
export DATASET=Scannet200Voxelization2cmDataset

export MODEL=Res16UNet34D  #Res16UNet34C, Res16UNet34D
export BATCH_SIZE=1
# export WEIGHTS_SUFFIX=$3
export SUFFIX=ckpt-10-focal-2
# export ARGS=$5

# export WEIGHTS_SUFFIX=$5

export DATA_ROOT=$1
# export PRETRAINED_WEIGHTS="./output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2/"$WEIGHTS_SUFFIX
export OUTPUT_DIR_ROOT="./output"

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export LOG_DIR=$OUTPUT_DIR_ROOT/$DATASET/$MODEL-$SUFFIX

# Save the experiment detail and dir to the common log file
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"
python3 split.py --train_file $2 --split_train $1/train_s.txt --split_val $1/val_s.txt
# export CUDA_VISIBLE_DEVICES=2,3
wget https://www.dropbox.com/s/1g5ad99qe24rej8/checkpoint-val_miou%3D10.38-step%3D127897.ckpt?dl=1 -O ./LanguageGroundedSemseg/ckpt/checkpoint-val_miou=10.38-step=127897.ckpt
pushd .
cd LanguageGroundedSemseg

python3 -m main \
    --log_dir $LOG_DIR \
    --dataset $DATASET \
    --model $MODEL \
    --batch_size $BATCH_SIZE \
    --val_batch_size $BATCH_SIZE \
    --scannet_path $DATA_ROOT \
    --stat_freq 100 \
    --visualize False \
    --visualize_path  $LOG_DIR/visualize \
    --num_gpu 2 \
    --balanced_category_sampling True \
    --weights ./LanguageGroundedSemseg/ckpt/checkpoint-val_miou=10.38-step=127897.ckpt \
    # --train_phase train \
    # --val_phase train \
    popd
    # --resume /home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2 \
    # $ARGS \
    # 2>&1 | tee -a "$LOG"

#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \


