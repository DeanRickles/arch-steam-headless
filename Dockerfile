# Steam Headless (Arch Linux)
# (WIP) An Arch variant of the steam-headless image
# It is curerently my intent to switch to arch as the main 
#   image base once SteamOS 3 is released (pending review)
#
FROM archlinux:latest
# orignal creater.
LABEL maintainer="Josh.5 <jsunnex@gmail.com>"
# current fork mainainer.
LABEL maintainer="Dean <dean@rickles.co.uk>"


# Update package repos
RUN \
    echo "**** Update package manager ****" \
        && sed -i 's/^NoProgressBar/#NoProgressBar/g' /etc/pacman.conf \
        && echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
    && \
    echo

# Update locale
# [02/05/2022] DeanRickles: Changed from US to GB
RUN \
    echo "**** Configure locals ****" \
        && echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen \
        && locale-gen \
    && \
    echo
ENV \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB:en \
    LC_ALL=en_GB.UTF-8

# Re-install certificates 
#[07/05/2022] DeanRickles: This package contains the set of CA certificates chosen by the Mozilla Foundation for use with the Internet PKI.
RUN \
    echo "**** Install certificates ****" \
	    && pacman -Syu --noconfirm --needed \
            ca-certificates \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# Install core packages
# [02/05/2022] DeanRickles: Is python-numpy really needed?
# [07/05/2022] DeanRickles: python is used within some one the bash scriptd.
## breakdown of utility packages. ##
# unsure if needed preappended #?
    #**** Install tools ****
    # bash = The GNU Bourne Again shell.
    # bash-completion = Programmable completion for the bash shell.
    # curl = An URL retrieval utility and library.
    # git  = the fast distributed version control system.
    # less = A terminal based program for viewing text files.
    # man-db = A utility for reading man pages.
    # nano = Pico editor clone with enhancements.
    # net-tools = Configuration tools for Linux networking.
    # pkg-config = Package compiler and linker metadata toolkit?
    # rsync = A fast and versatile file copying tool for remote and local files.
    # screen = Full-screen window manager that multiplexes a physical terminal.
    # sudo = Give certain users the ability to run some commands as root.
    # unzip = For extracting and viewing files in .zip archives.
    # vim = Vi Improved, a highly configurable, improved version of the vi text editor.
    # wget = Network utility to retrieve files from the Web.
    # xz = Library and command line tools for XZ and LZMA compressed files.

    #**** Install python ****
    # python = 	Next generation of the python high-level scripting language
    #?# python-numpy = Scientific tools for Python
    # python-pip = The PyPA recommended tool for installing Python packages
    #?# python-setuptools = Easily download, build, install, upgrade, and uninstall Python packages
RUN \
    echo "**** Install tools ****" \
	    && pacman -Syu --noconfirm --needed \
            bash \
            bash-completion \
            curl \
            git \
            less \
            man-db \
            nano \
            net-tools \
            pkg-config \
            rsync \
            screen \
            sudo \
            unzip \
            vim \
            wget \
            xz \
    && \
    echo "**** Install python ****" \
	    && pacman -Syu --noconfirm --needed \
            python \
            python-numpy \
            python-pip \
            python-setuptools \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# Install supervisor
# [07/05/2022] DeanRickles:
# supervisor = A system for controlling process state under UNIX.
RUN \
    echo "**** Install supervisor ****" \
	    && pacman -Syu --noconfirm --needed \
            supervisor \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# XFS requirements
RUN \
    echo "**** Install XFS requirements ****" \
	    && pacman -Syu --noconfirm --needed \
            xfsdump \
            xfsprogs \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# [07/05/2022] DeanRickles: added amdvlk and vulken-intel to sort out vulken errors.
# Install mesa requirements
RUN \
    echo "**** Install mesa and vulkan requirements ****" \
	    && pacman -Syu --noconfirm --needed \
            glu \
            libva-mesa-driver \
            mesa-utils \
            mesa-vdpau \
            opencl-mesa \
            pciutils \
            vulkan-mesa-layers \
            amdvlk \
            vulkan-intel \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# Install X Server requirements
# TODO: Remove doubles
# TODO: Things that are not required
RUN \
    echo "**** Install X Server requirements ****" \
	    && pacman -Syu --noconfirm --needed \
            avahi \
            dbus \
            lib32-fontconfig \
            ttf-liberation \
            x11vnc \
            xorg \
            xorg-apps \
            xorg-font-util \
            xorg-fonts-misc \
            xorg-fonts-type1 \
            xorg-server \
            xorg-server-xephyr \
            xorg-server-xvfb \
            xorg-xauth \
            xorg-xbacklight \
            xorg-xhost \
            xorg-xinit \
            xorg-xinput \
            xorg-xkill \
            xorg-xprop \
            xorg-xrandr \
            xorg-xsetroot \
            xorg-xwininfo \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# Install audio requirements
RUN \
    echo "**** Install X Server requirements ****" \
	    && pacman -Syu --noconfirm --needed \
            pulseaudio \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# Install openssh server
RUN \
    echo "**** Install openssh server ****" \
	    && pacman -Syu --noconfirm --needed \
            openssh \
        && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# Install noVNC
# [02/05/2022] DeanRickles: any reason we're version controlling NOVNC?
# [02/05/2022] DeanRickles: Assuming there is a credentials file
ARG NOVNC_VERSION=1.2.0
RUN \
    echo "**** Fetch noVNC ****" \
        && cd /tmp \
        && wget -O /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz \
    && \
    echo "**** Extract noVNC ****" \
        && cd /tmp \
        && tar -xvf /tmp/novnc.tar.gz \
    && \
    echo "**** Configure noVNC ****" \
        && cd /tmp/noVNC-${NOVNC_VERSION} \
        && sed -i 's/credentials: { password: password } });/credentials: { password: password },\n                           wsProtocols: ["'"binary"'"] });/g' app/ui.js \
        && mkdir -p /opt \
        && rm -rf /opt/noVNC \
        && cd /opt \
        && mv -f /tmp/noVNC-${NOVNC_VERSION} /opt/noVNC \
        && cd /opt/noVNC \
        && ln -s vnc.html index.html \
        && chmod -R 755 /opt/noVNC \
    && \
    echo "**** Modify noVNC title ****" \
        && sed -i '/    document.title =/c\    document.title = "Steam Headless - noVNC";' \
            /opt/noVNC/app/ui.js \
    && \
    echo "**** Section cleanup ****" \
        && rm -rf \
            /tmp/noVNC* \
            /tmp/novnc.tar.gz


# Install Websockify
# [02/05/2022] DeanRickles: Look into Websockift and how it works.
ARG WEBSOCKETIFY_VERSION=0.10.0
RUN \
    echo "**** Fetch Websockify ****" \
        && cd /tmp \
        && wget -O /tmp/websockify.tar.gz https://github.com/novnc/websockify/archive/v${WEBSOCKETIFY_VERSION}.tar.gz \
    && \
    echo "**** Extract Websockify ****" \
        && cd /tmp \
        && tar -xvf /tmp/websockify.tar.gz \
    && \
    echo "**** Install Websockify to main ****" \
        && cd /tmp/websockify-${WEBSOCKETIFY_VERSION} \
        && python3 ./setup.py install \
    && \
    echo "**** Install Websockify to noVNC path ****" \
        && cd /tmp \
        && mv -v /tmp/websockify-${WEBSOCKETIFY_VERSION} /opt/noVNC/utils/websockify \
    && \
    echo "**** Section cleanup ****" \
        && rm -rf \
            /tmp/websockify-* \
            /tmp/websockify.tar.gz

# Install firefox
# TODO: Move under de
# [02/05/2022] DeanRickles: why does it need firefox?
RUN \
    echo "**** Install firefox ****" \
	    && pacman -Syu --noconfirm --needed \
            firefox \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# [02/05/2022] DeanRickles: Assuming commented out while testing? 
# [04/05/2022] DeanRickles: Enabled Steam install
 # Install Steam
 RUN \
     echo "**** Install steam ****" \
 	    && pacman -Syu --noconfirm --needed \
             lib32-vulkan-icd-loader \
             steam \
             vulkan-icd-loader \
     && \
     echo "**** Section cleanup ****" \
 	    && pacman -Scc --noconfirm \
     && \
     echo


# Install desktop environment
RUN \
    echo "**** Install desktop environment ****" \
	    && pacman -Syu --noconfirm --needed \
            gedit \
            xfce4 \
            xfce4-terminal \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# Add support for flatpaks
RUN \
    echo "**** Install flatpak support ****" \
	    && pacman -Syu --noconfirm --needed \
            flatpak \
            xdg-desktop-portal-gtk \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# TODO Append to tools
RUN \
    echo "**** Install flatpak support ****" \
	    && pacman -Syu --noconfirm --needed \
            patch \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo


# [04/05/2022] DeanRickles: Need the locale text files otherwise text input doesn't work with steam on through onVNC.
# [04/05/2022] DeanRickles: Need to look into how to enable without re-install.
RUN \
    echo "**** including  X11 language packs ****" \
    && sed -i 's/NoExtract  = usr\/share\/locale\/\* usr\/share\/X11\/locale\/\* usr\/share\/i18n\/\*/#NoExtract  = usr\/share\/locale\/\* usr\/share\/X11\/locale\/\* usr\/share\/i18n\/\*/g' /etc/pacman.conf \
    && pacman -Qqn | pacman -S --noconfirm - \
    && \
    echo "**** Section cleanup ****" \
	    && pacman -Scc --noconfirm \
    && \
    echo

# Configure default user and set env
ENV \
    USER="default" \
    USER_PASSWORD="password" \
    USER_HOME="/home/default" \
    TZ="Pacific/Auckland" \
    USER_LOCALES="en_US.UTF-8 UTF-8"
RUN \
    echo "**** Configure default user '${USER}' ****" \
        && mkdir -p \
            ${USER_HOME} \
        && useradd -d ${USER_HOME} -s /bin/bash ${USER} \
        && chown -R ${USER} \
            ${USER_HOME} \
        && echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add FS overlay
COPY overlay /

# Set display environment variables
ENV \
    DISPLAY_CDEPTH="24" \
    DISPLAY_DPI="96" \
    DISPLAY_REFRESH="60" \
    DISPLAY_SIZEH="900" \
    DISPLAY_SIZEW="1600" \
    DISPLAY_VIDEO_PORT="DFP" \
    DISPLAY=":55" \
    NVIDIA_DRIVER_CAPABILITIES="all" \
    NVIDIA_VISIBLE_DEVICES="all"

#[03/05/2022] DeanRickles added NO_AT_BRIDGE=1
# Set container configuration environment variables
ENV \
    MODE="primary" \
    ENABLE_VNC_AUDIO="true" \
    NO_AT_BRIDGE=1


# Configure required ports
ENV \
    PORT_SSH="2222" \
    PORT_VNC="5900" \
    PORT_AUDIO_STREAM="5901" \
    PORT_NOVNC_WEB="8083" \
    PORT_AUDIO_WEBSOCKET="32123"

# Expose the required ports
EXPOSE 2222
EXPOSE 5900
EXPOSE 5901
EXPOSE 8083
EXPOSE 32123

# Set entrypoint
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
