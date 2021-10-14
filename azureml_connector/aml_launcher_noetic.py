import os

from azureml.core import (
    Environment, Experiment, ScriptRunConfig, Workspace, Datastore, Dataset
)

from azureml.data import OutputFileDatasetConfig

import compute_manager

ws = Workspace.from_config()
root_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir)

env = None
with open("ros_noetic.Dockerfile", "r") as f:
    dockerfile=f.read()

env = Environment(name='ros-noetic-env')
env.docker.base_image = None
env.docker.base_dockerfile = dockerfile
env.docker.enabled = True
env.python.user_managed_dependencies = True
env.python.interpreter_path = "xvfb-run -s '-screen 0 640x480x16 -ac +extension GLX +render' python"
env.register(ws)

installation_cmds = ("mkdir -p catkin_ws/src && " +                    
                     "mv mushr/* catkin_ws/src/ && cd catkin_ws/src/ && "
                     "vcs import < repos.yaml && " +
                     "git clone https://github.com/ros/robot_state_publisher.git && " +
                     "wget https://github.com/wjwwood/serial-release/archive/release/melodic/serial/1.2.1.tar.gz && tar -xvf *.gz && rm *.gz && " +
                     "mv mushr/mushr_hardware/realsense/realsense2_description mushr/mushr_hardware/realsense2_description && " +
                     "rm -rf mushr/mushr_hardware/realsense && " +
                     "cd ./range_libc/pywrapper && " +
                     "python setup.py install && " +
                     "cd ../../ && " +
                     "rm -rf range_libc && " +
                     "cd .. && " +
                     "/bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make' && " +
                     "/bin/bash -c '. ./devel/setup.bash' && ")  

datastore = ws.get_default_datastore()
output = OutputFileDatasetConfig(destination=(datastore, 'hackathon_data'))

script_run_config = ScriptRunConfig(
    source_directory=os.path.join(root_dir), 
    command=[installation_cmds + "python ./src/main.py", "--data_path", output.as_mount()],
    compute_target=compute_manager.create_compute_target(ws, 'd12v2'),
    environment=env)

exp = Experiment(workspace=ws, name='mushr-datacollection')
exp.submit(config=script_run_config, tags={'ros': 'noetic'})
