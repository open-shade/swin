# SWIN-ROS2 Wrapper

This is a ROS2 wrapper for the (Hierarchical Vision Transformer using Shifted Windows) SWIN Transformer with an image classification head, [SWIN](https://arxiv.org/abs/2103.14030). We utilize `huggingface` and the `transformers` for the [source of the algorithm](https://huggingface.co/microsoft/swin-tiny-patch4-window7-224). The main idea is for this container to act as a standalone interface and node, removing the necessity to integrate separate packages and solve numerous dependency issues. We have built all different versions of the algorithm (i.e. `base-patch16-224`, `large-patch16-224`, etc.) for each ROS2 distribution.

SWIN Transformers builds on top of vision transformers by addressing the differences between NLP and vision, the paper proposes a hierarchical Transformer whose representation is computed with Shifted Windows. The shifted windowing scheme brings greater efficiency by limiting self-attention computation to non-overlapping local windows while also allowing for cross-window connection. This hierarchical architecture has the flexibility to model at various scales and has linear computational complexity with respect to image size.

# Installation Guide

## Using Docker Pull
1. Install [Docker](https://www.docker.com/) and ensure the Docker daemon is running in the background.
2. Run ```docker pull shaderobotics/swin:${ROS2_DISTRO}-${MODEL_VERSION}``` we support all ROS2 distributions along with all model versions found in the model version section below.
3. Follow the run commands in the usage section below

## Build Docker Image Natively
1. Install [Docker](https://www.docker.com/) and ensure the Docker daemon is running in the background.
2. Clone this repo with ```git pull https://github.com/open-shade/swin.git```
3. Enter the repo with ```cd swin```
4. To pick a specific model version, edit the `ALGO_VERSION` constant in `/swin/swin.py`
5. Build the container with ```docker build . -t [name]```. This will take a while. We have also provided associated `cloudbuild.sh` scripts to build on GCP all of the associated versions.
6. Follow the run commands in the usage section below.

# Model Versions

* ```tiny-patch4-window7-224```
* ```base-patch4-window7-224```
* ```large-patch4-window7-224```
* ```small-patch4-window7-224```
* ```base-patch4-window12-384```
* ```large-patch4-window7-224```

More information about these versions can be found in the [paper](https://arxiv.org/abs/2010.11929). `base`, `large`, represent the number of weights stored (i.e. the size of the model). Window is the shifted window size. 384 is the resolution size of the image. 

## Example Docker Command

```bash
docker pull shaderobotics/swin:foxy-base-patch4-window7-224
```

# Usage
## Run the SWIN Node 
Run ```docker run -t [name]```. Your node should be running now. Then, by running ```ros2 topic list,``` you should see all the possible pub and sub routes.

For more details explaining how to run Docker images, visit the official Docker documentation [here](https://docs.docker.com/engine/reference/run/). Also, additional information as to how ROS2 communicates between external environment or multiple docker containers, visit the official ROS2 (foxy) docs [here](https://docs.ros.org/en/foxy/How-To-Guides/Run-2-nodes-in-single-or-separate-docker-containers.html#). 

# Topics

| Name                   | IO  | Type                             | Use                                                               |
|------------------------|-----|----------------------------------|-------------------------------------------------------------------|
| swin/image_raw       | sub | [sensor_msgs.msg.Image](http://docs.ros.org/en/noetic/api/sensor_msgs/html/msg/Image.html)            | Takes the raw camera output to be processed                       |
 | swin/result           | pub | String            | Outputs the classification label from ImageNet 100 Classes as a string |

# Testing / Demo
To test and ensure that this package is properly installed, replace the Dockerfile in the root of this repo with what exists in the demo folder. Installed in the demo image contains a [camera stream emulator](https://github.com/klintan/ros2_video_streamer) by [klintan](https://github.com/klintan) which directly pubs images to the SWIN node and processes it for you to observe the outputs.

To run this, run ```docker build . -t [name]```, then ```docker run -t [name]```. Observing the logs for this will show you what is occuring within the container. If you wish to enter the running container and preform other activities, run ```docker ps```, find the id of the running container, then run ```docker exec -it [containerId] /bin/bash```