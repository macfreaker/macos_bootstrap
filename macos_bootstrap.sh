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
cat << EOF > install_cask_apps.yml
---
- name: Install Homebrew Cask Apps
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
EOF

# Install community.general collection
ansible-galaxy collection install community.general

# Run Ansible playbook
ansible-playbook install_cask_apps.yml

echo "Setup complete!"
