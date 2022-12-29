#!/bin/bash

set -e

##### Download checkpoint ######
CKPT="./LanguageGroundedSemseg/ckpt/checkpoint-val_miou=38.34-step=32860.ckpt"
mkdir -p "./LanguageGroundedSemseg/ckpt"
if test -f "$CKPT"; then
    echo "Check point exists."
else
    echo "Download checkpoint"
    wget https://www.dropbox.com/s/1vm7rldsuyr5giu/checkpoint-val_miou%3D38.34-step%3D32860.ckpt?dl=1 -O "$CKPT"
fi
export PYTHONUNBUFFERED="True"


##### Prepare datasets ######
export TA_DATA_PATH=`realpath $1`
export OUR_DATA_PATH=`realpath ./our_dataset`
mkdir -p $OUR_DATA_PATH
cp $TA_DATA_PATH/*.txt $OUR_DATA_PATH
if test -f "$CKPT"; then
    cp $OUR_DATA_PATH/test.txt $OUR_DATA_PATH/train.txt
    cp $OUR_DATA_PATH/test.txt $OUR_DATA_PATH/val.txt
else
    echo "File test.txt not found"
fi


# export PRETRAINED_WEIGHTS="/home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2/checkpoint-val_miou=38.34-step=32860.ckpt"
export OUTPUT_DIR_ROOT="./temp_output"
mkdir -p $OUTPUT_DIR_ROOT


export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export LOG_DIR="./log"
export OUT_DIR=`realpath $3`
mkdir -p $OUT_DIR
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
    --scannet_path $TA_DATA_PATH \
    --out_data_path $OUR_DATA_PATH \
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

cp $LOG_DIR/visualize/fulleval/*.txt $OUT_DIR
    # 2>&1 | tee -a "$LOG"

#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \
echo "SUCCCESS"
