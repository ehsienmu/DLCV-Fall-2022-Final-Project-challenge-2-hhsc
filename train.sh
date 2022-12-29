#!/bin/bash
set -e
export PYTHONUNBUFFERED="True"

export SUFFIX=ckpt-10-focal-2

export TA_DATA_PATH=`realpath $1`
export TA_TXT_PATH=`realpath $2`   # expext txt file
export OUR_DATA_PATH=`realpath ./our_dataset`
mkdir -p $OUR_DATA_PATH
python3 split.py --train_file $TA_TXT_PATH --split_train $OUR_DATA_PATH/train.txt --split_val $OUR_DATA_PATH/val.txt
cp $OUR_DATA_PATH/val.txt $OUR_DATA_PATH/test.txt

export OUTPUT_DIR_ROOT="./train_output"

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export LOG_DIR=$OUTPUT_DIR_ROOT/$DATASET/$MODEL-$SUFFIX

mkdir -p $LOG_DIR
LOG="$LOG_DIR/$TIME.txt"

CKPT="./LanguageGroundedSemseg/ckpt/checkpoint-val_miou=10.38-step=127897.ckpt"
if test -f "$CKPT"; then
    echo "Check point exists."
else
    echo "Download checkpoint"
    wget https://www.dropbox.com/s/1vm7rldsuyr5giu/checkpoint-val_miou%3D38.34-step%3D32860.ckpt?dl=1 -O "$CKPT"
fi



pushd .
cd LanguageGroundedSemseg

python3 -m main \
    --log_dir $LOG_DIR \
    --model Res16UNet34D \
    --batch_size 1 \
    --val_batch_size 1 \
    --scannet_path $TA_DATA_PATH \
    --our_data_path $OUR_DATA_PATH \
    --stat_freq 100 \
    --visualize False \
    --num_gpu 1 \
    --weights ./ckpt/checkpoint-val_miou=10.38-step=127897.ckpt
    --train_phase train \
    --val_phase train 
    # --balanced_category_sampling True \
    # --resume /home/twsbvze943/chiawen/output/Scannet200Voxelization2cmDataset/Res16UNet34D-ckpt-10-focal-2 \
    # $ARGS \
    # 2>&1 | tee -a "$LOG"

popd
#    --resume $LOG_DIR \
#    --weights $PRETRAINED_WEIGHTS \


