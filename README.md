# This is a clone of josh5/docker-steam-headless


### Version Notes:
    v1.0.5 - 07/05/2022
    * Added pacman packages vulkan-radeon, lib32-vulkan-radeon and, vulkan-tools.
    v1.0.4 - 07/05/2022
    * Added pacman packages amdvlk and vulken-intel to sort out vulken errors.
    v1.0.3 - 04/05/2022
    * Need the locale text files otherwise text input doesn't work with steam on through onVNC.
    * Enabled Steam install
    v1.0.2 - 03/05/2022
    * Added NO_AT_BRIDGE=1
    1.0.1 - 02/05/2022
    * Changed dockerfile from US to GB location and language.
    * Started adding personal notes to look back at as I inspect the files.
    1.0.0 - 02/05/2022 Cloned josh5/docker-steam-headless
    *  Cloned and started using dockerfile.arch.

---

# Plan
Using the base of this to understand archlinux and deploy steam in docker. Possibly contribute to josh5's version later.

Todo:
* check all files for any improvements.
* docker file inspection.
* Move from xfde to kde for desktop.
* add the following:
    sudo pacman -Sy vulkan-intel
    sudo pacman -R amdvlk

---

# Quick notes:

#### Folder structure
'''
    ./overlay = install files.
    ./image   = Steam icon picture.
    ./devops  = consitancy docker run file. Possibly split docker run section into a docker-compose file.
'''

#### Docker run - Need to validity check.
'''
docker run -d --name='${container_name}' \
    --privileged=true \
    -e PUID='99'  \
    -e PGID='100'  \
    -e UMASK='000'  \
    -e USER_PASSWORD='password' \
    -e USER='default' \
    -e USER_HOME='/home/default' \
    -e TZ='EUROPE/LONDON' \
    -e USER_LOCALES='en_GB.UTF-8 UTF-8' \
    -e DISPLAY_CDEPTH='24' \
    -e DISPLAY_DPI='96' \
    -e DISPLAY_REFRESH='60' \
    -e DISPLAY_SIZEH='720' \
    -e DISPLAY_SIZEW='1280' \
    -e DISPLAY_VIDEO_PORT='DFP' \
    -e DISPLAY=':55' \
    -e NVIDIA_DRIVER_CAPABILITIES='all' \
    -e NVIDIA_VISIBLE_DEVICES='all' \
    -e ENABLE_VNC_AUDIO='false' \
    -v '${project_base_path}/config/home/default-${container_name}':'/home/default':'rw'  \
    -v '/tmp/.X11-unix/':'/tmp/.X11-unix/':'rw'  \
    -v '/dev/input':'/dev/input':'ro' \
    --hostname='${container_name}' \
    --add-host=${container_name}:127.0.0.1 \
    --shm-size=2G \
    ${additional_docker_params} \
    DeanRickles/arch-steam-headless:${tag}"
'''

#### dockerfile.arch:

* what is mesa?
* what version of steamos is released?
* 'pacman -Scc' is used to remove cache as it's not needed and saves space. very clever.

* file structure:
    * lang
    * pacman: ca-certficates
    * pacman: misc tools
    * pacman: python
    * pacman: supervisor
    * pacman: mesa && vulkan
    * pacman: 'x Server'
    * pacman: 'x Server' audio?
    * pacman: openssh server
    * noVNC: download & install
    * Websockify: download & install
    * pacman: firefox
    #* pacman: steam
    * pacman: flatpak support
    * pacman: patch
    #* desktop enviroment
    #* browser streaming
    * ENV user,user_password,user_home, TZ, USER_LOCALES
    * config: user
    * COPY overlay /
    * ENV display settings
    * ports (questionable if port ENV work as not connected to ENV.)
    * run /entrypoint.sh

#### ./overlay/enterypoint.sh

* file structure:
    * check for /version.txt (doesn't exist)
    * run each script in /etc/cont-init.d/
    *

#### ./overlay/etc


#### ./overlay/opt


#### ./overlay/usr

* 

---



# unraid environment variables

'''
to be filled in.

'''

---




# Headless Steam Service

Play your games in the browser with audio. Connect another device and use it with Steam Remote Play. Easily deploy a Steam Docker instance in seconds.

## Features:
- Full video/audio noVNC web access to a Xfce4 Desktop
- NVIDIA GPU support
- Root access
- SSH server for remote terminal access


---
## Notes:

### ADDITIONAL SOFTWARE:
If you wish to install additional applications, you can generate a
script inside the `~/init.d` directory ending with ".sh". This will be executed on the container startup.

### STORAGE PATHS:
Everything that you wish to save in this container should be stored in the home directory or a docker container mount that you have specified. All files that are store outside your home directory are not persistent and will be wiped if there is an update of the container or you change something in the template.

### GAMES LIBRARY:
It is recommended that you mount your games library to `/mnt/games` and configure Steam to add that path.

### AUTO START APPLICATIONS:
In this container, Steam is configured to automatically start. If you wish to add additional services to automatically start, add them under **Applications > Settings > Session and Startup** in the WebUI.

### NETWORK MODE:
If you want to use the container as a Steam Remote Play (previously "In Home Streaming") host device you should create a custom network and assign this container it's own IP, if you don't do this the traffic will be routed through the internet since Steam thinks you are on a different network.

### USING HOST X SERVER:
If your host is already running X, you can just use that. To do this, be sure to configure:
  - DISPLAY=:0    
    **(Variable)** - *Configures the sceen to use the primary display. Set this to whatever your host is using*
  - MODE=secondary    
    **(Variable)** - *Configures the container to not start an X server of its own*
  - HOST_DBUS=true    
    **(Variable)** - *Optional - Configures the container to use the host dbus process*
  - /run/dbus:/run/dbus:ro    
    **(Mount)**  - *Optional - Configures the container to use the host dbus process*


---
## Running:

For a development environment, I have created a script in the devops directory.


---
## TODO:
- Configure xorg.conf with no NVIDIA GPU
- Lock SSH access to user only (remove root access)
- Require user to enter password for sudo
- Document how to run this container
