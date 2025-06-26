wget https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/cuda-repo-rhel9-12-9-local-12.9.1_575.57.08-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel9-12-9-local-12.9.1_575.57.08-1.x86_64.rpm
sudo dnf clean all
sudo dnf -y install cuda-toolkit-12-9
sudo dnf -y module install nvidia-driver:latest-dkms
sudo dnf install cuda-toolkit
sudo dnf install nvidia-gds
$ export PATH=${PATH}:/usr/local/cuda-12.9/bin

dnf install freeglut-devel libX11-devel libXi-devel libXmu-devel make mesa-libGLU-devel freeimage-devel libglfw3-devel