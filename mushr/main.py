import argparse
import datetime
import os
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--data_path', type=str, help='Path to the training data')
args = parser.parse_args()

output_path = os.path.join(args.data_path, str(datetime.datetime.now().timestamp()))
os.makedirs(output_path, exist_ok=True)
print(output_path)

subprocess.call("/bin/bash -c '. /opt/ros/melodic/setup.bash;. ./devel/setup.bash; roslaunch mushr_sim server_collection.launch record_path:={0}'".format(output_path), shell=True)
