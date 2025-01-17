FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Install SSH and other dependencies
RUN apt-get update && \
    apt-get install -y openssh-server sudo less nano htop ncdu && \
    mkdir /var/run/sshd

# Create a directory for SSH keys
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Update SSH configuration
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Setup dotfiles and ZSH
RUN mkdir dotfiles

# copy repo into container
COPY . /dotfiles

RUN cd dotfiles && \
    ./install.sh --zsh --tmux

RUN cd dotfiles && \
    ./deploy.sh

RUN echo "/usr/bin/zsh" >> /etc/shells

# Setup virtual environment
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN source $HOME/.local/bin/env && \
    uv python install 3.11 && \
    uv venv

RUN source $HOME/.local/bin/env && \
    uv pip install --no-cache-dir ipykernel huggingface_hub
    # simple-gpu-scheduler torch transformers

RUN source $HOME/.local/bin/env && \
    python -m ipykernel install --user --name=venv

EXPOSE 22
EXPOSE 8000

ENTRYPOINT ["/dotfiles/runpod/entrypoint.sh"]
