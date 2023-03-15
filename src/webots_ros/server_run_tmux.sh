#!/bin/bash
rviz="false"
webots_ros_home="$HOME/server_ws/src/webots_ros"
webots_home="~/webots"
map_path="$webots_ros_home/config/map/3.yaml"
env_name="robotmani"
scene_name="easy_3_3.wbt"
conda_path="~/anaconda3/etc/profile.d/conda.sh"
inst="'Go to the Parlor, pick the Mug and place in Bedroom'"

tmux new-session -d -s "webots_ros"
tmux send-keys -t "webots_ros" "source ~/server_ws/devel/setup.bash; 
export ROS_MASTER_URI=http://127.0.0.1:10241;
roscore -p 10241;
exit;
exec bash" C-m
sleep 5

tmux split-window -h -t "webots_ros"
tmux send-keys -t "webots_ros" "cd ~/server_ws/ ;
export WEBOTS_HOME=$webots_home;
source devel/setup.bash;
source $conda_path;
conda activate $env_name;
cd src/webots_ros/scripts;
export ROS_MASTER_URI=http://127.0.0.1:10241;
python task_server_easy.py $inst;
killall -e python roslaunch construct_semma roscore;
rm -rf $webots_ros_home/scripts/*.png;
exit;
exec bash" C-m
sleep 5

tmux select-pane -L -t "webots_ros"
tmux split-window -v -t "webots_ros"
tmux send-keys -t "webots_ros" "cd ~/server_ws/ ;
export WEBOTS_HOME=$webots_home;
source devel/setup.bash;
source $conda_path;
conda activate $env_name;
export ROS_MASTER_URI=http://127.0.0.1:10241;
roslaunch webots_ros random_scene.launch mobile_base:=Moma true_false:=true scene_name:=$scene_name no_gui:=true; rviz:=$rviz;
exit;
exec bash" C-m
sleep 30

tmux select-pane -R -t "webots_ros"
tmux split-window -v -t "webots_ros"
tmux send-keys -t "webots_ros" "cd ~/server_ws/;
export WEBOTS_HOME=$webots_home;
source devel/setup.bash;
source $conda_path;
conda activate $env_name;
export ROS_MASTER_URI=http://127.0.0.1:10241;
roslaunch webots_ros demo_socket.launch rviz:=$rviz true_false:=true map_path:=$map_path --wait;
exit;
exec bash" C-m
sleep 10


