#!/bin/bash --login

echo "Running inference script"

INP_IMG_DIR=/data/test_data
OUT_IMG_DIR=/data/submission_output

echo "INP_IMG_DIR=$INP_IMG_DIR"
echo "OUT_IMG_DIR=$OUT_IMG_DIR"

# Inference using maskrcnn of mmocr

echo "Activate mmocr environment..."
eval "$(conda shell.bash hook)"
conda activate mmocr

echo "Running maskrcnn..."
ls $INP_IMG_DIR | head -n 5 > img_list.txt  # debug 5 images
python mmocr_infer.py \
    $INP_IMG_DIR img_list.txt \
    weights/maskrcnn_trainval.py \
    weights/best_hmean-iou_hmean_epoch_87.pth \
    --out-dir $OUT_IMG_DIR \
    --score-thr 0.3

