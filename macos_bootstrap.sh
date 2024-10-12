#!/bin/bash

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
    - name: Install Homebrew Cask applications
      community.general.homebrew_cask:
        name:
          - alfred
          - android-platform-tools
          - android-studio
          - expo-orbit
          - flutter
          - font-meslo-lg-nerd-font
          - imageoptim
          - insomnia
          - iterm2
          - raindropio
          - rectangle
          - stats
          - temurin
          - temurin@8
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
EOF

# Install community.general collection
ansible-galaxy collection install community.general

# Run Ansible playbook
ansible-playbook install_homebrew_packages.yml

echo "Setup complete!"
