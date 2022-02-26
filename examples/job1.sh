#!/bin/sh
#SBATCH --job-name=slurm_job_test           # Job name
#SBATCH --ntasks=1                          # Run a single task
#SBATCH --time=02:00:00                     # Time limit hrs:min:sec
#SBATCH --output=test_tf_%j.out             # Standard output and error log
#SBATCH --cpus-per-task=10                  # Run a task on 10 cpus
#SBATCH --gres=gpu:1                        # Run a single GPU task 
#SBATCH --mem=32GB                          # Use 32GB of memory.
#SBATCH --partition=q1_day-1G               # Use dgx partition.

pwd; hostname; date |tee result
echo $CUDA_VISIBLE_DEVICES

nvidia-docker run -t ${USER_TTY} --name $SLURM_JOB_ID \
--user $(id -u):$(id -g) \
-v /home/$USER:/home/$USER \
--rm nvcr.io/nvidia/tensorflow:22.02-tf2-py3 python \
-c 'import tensorflow as tf; print(tf.__version__)'

sleep 60