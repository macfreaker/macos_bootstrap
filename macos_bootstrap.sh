#!/bin/bash

# Function to show a simple progress bar
show_progress() {
    local duration=$1
    local steps=$2
    local sleep_time=$(bc <<< "scale=2; $duration / $steps")
    local progress=0
    while [ $progress -le 100 ]; do
        echo -ne "\rProgress: [${progress}%] ["
        for i in $(seq 1 $steps); do
            if [ $i -le $(($progress * $steps / 100)) ]; then
                echo -n "="
            else
                echo -n " "
            fi
        done
        echo -n "]"
        progress=$((progress + 100/$steps))
        sleep $sleep_time
    done
    echo
}

# Function to install Homebrew
install_homebrew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# Function to install Python and Ansible
install_ansible() {
    echo "Installing Python and Ansible..."
    brew install python
    pip3 install ansible
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    install_homebrew
else
    echo "Homebrew is already installed."
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null
then
    install_ansible
else
    echo "Ansible is already installed."
fi

# Create Ansible playbook
cat << EOF > install_homebrew_packages.yml
---
- name: Install Homebrew Cask Apps and Formulae
  hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Install Homebrew Cask Apps, Formulae, React Native, and Expo CLI
      community.general.homebrew_cask:
        name:
          - alfred
          - android-platform-tools
          - android-studio
          - angry-ip-scanner
          - appcleaner
          - apk-icon-editor
          - bitwarden
          - expo-orbit
          - firefox
          - flutter
          - font-meslo-lg-nerd-font
          - imageoptim
          - insomnia
          - iterm2
          - libreoffice
          - pycharm
          - raindropio
          - rectangle
          - stats
          - temurin
          - temurin@8
          - webstorm
          - visual-studio-code
          - zed
          - zulu@17
        state: present
      become: false

    - name: Install Homebrew formulae
      community.general.homebrew:
        name:
          - aom
          - aribb24
          - assimp
          - autoconf
          - automake
          - bat
          - bitwarden-cli
          - boost
          - brotli
          - c-ares
          - ca-certificates
          - cairo
          - certifi
          - cjson
          - cmake
          - cocoapods
          - create-dmg
          - dav1d
          - dbus
          - double-conversion
          - edencommon
          - fb303
          - fbthrift
          - ffmpeg
          - figlet
          - fizz
          - flac
          - fmt
          - folly
          - fontconfig
          - freetype
          - frei0r
          - fribidi
          - fzf
          - gettext
          - gflags
          - giflib
          - git
          - glances
          - glib
          - glog
          - gmp
          - gnutls
          - graphite2
          - harfbuzz
          - highway
          - hunspell
          - icu4c
          - imath
          - jasper
          - jpeg-turbo
          - jpeg-xl
          - jq
          - lame
          - leptonica
          - libarchive
          - libass
          - libb2
          - libbluray
          - libdeflate
          - libevent
          - libgit2
          - libidn2
          - libmicrohttpd
          - libmng
          - libnghttp2
          - libogg
          - libpng
          - librist
          - libsamplerate
          - libsndfile
          - libsodium
          - libsoxr
          - libssh
          - libssh2
          - libtasn1
          - libtiff
          - libtool
          - libunibreak
          - libunistring
          - libusb
          - libuv
          - libvidstab
          - libvmaf
          - libvorbis
          - libvpx
          - libvterm
          - libx11
          - libxau
          - libxcb
          - libxdmcp
          - libxext
          - libxrender
          - libyaml
          - little-cms2
          - llvm@18
          - lpeg
          - luajit
          - luv
          - lz4
          - lzo
          - m4
          - mbedtls
          - md4c
          - mpdecimal
          - mpg123
          - msgpack
          - mvfst
          - ncurses
          - neovim
          - nettle
          - node
          - nyx
          - oniguruma
          - opencore-amr
          - openexr
          - openjpeg
          - openssl@1.1
          - openssl@3
          - opus
          - p11-kit
          - pango
          - pcre
          - pcre2
          - pixman
          - pkg-config
          - pstree
          - pyenv
          - python-packaging
          - python@3.12
          - qt
          - rav1e
          - readline
          - rubberband
          - ruby
          - rust
          - scrcpy
          - sdl2
          - skhd
          - snappy
          - speex
          - sqlite
          - srt
          - svt-av1
          - tesseract
          - theora
          - tree-sitter
          - unbound
          - unibilium
          - wangle
          - watchman
          - webp
          - wget
          - x264
          - x265
          - xorgproto
          - xvid
          - xz
          - yabai
          - yarn
          - yt-dlp
          - zeromq
          - zimg
          - zsh
          - zstd
        state: present
      become: false

    - name: Install React Native CLI
      npm:
        name: react-native-cli
        global: yes
      become: false

    - name: Install Expo CLI
      npm:
        name: expo-cli
        global: yes
      become: false
      
EOF

# Install community.general collection
ansible-galaxy collection install community.general

# Run Ansible playbook
echo "Starting installation of Homebrew packages, React Native, and Expo CLI..."
ansible-playbook install_homebrew_packages.yml &

# Show progress bar while Ansible is running
show_progress 300 50 &

# Wait for Ansible to finish
wait

echo "Setup complete!"

echo "
IMPORTANT: Xcode needs to be installed manually from the App Store.
Please install Xcode, then run 'xcode-select --install' to install command line tools.
After installation, open Xcode to accept the license agreement."
