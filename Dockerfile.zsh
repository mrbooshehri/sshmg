FROM docker.arvancloud.ir/ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-color \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Tehran \
    LANG=C.UTF-8 \
    FZF_VERSION=0.56.0 \
    USER=mosh

# Update and upgrade
RUN apt-get update && apt-get upgrade -y

# Install build tools and dependencies
RUN apt-get install -y curl wget python3-pip tmux bsdmainutils openssh-client zsh sshpass xsel vim s3cmd telnet inetutils-ping git \
    && rm -rf /var/lib/apt/lists/*

# Download and install FZF (latest version)
RUN curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz \
    && tar xzf /tmp/fzf.tar.gz -C /usr/local/bin \
    && rm /tmp/fzf.tar.gz

# Download the 'tunnel' script and add it to PATH
RUN curl -Lo /usr/local/bin/tunnel https://raw.githubusercontent.com/mrbooshehri/sshmg/refs/heads/master/tunnel \
    && chmod +x /usr/local/bin/tunnel

# Download the 'fuzzy-ssh' script and add it to PATH
RUN curl -Lo /usr/local/bin/fuzzy-ssh https://raw.githubusercontent.com/mrbooshehri/sshmg/refs/heads/master/fuzzy-ssh \
    && chmod +x /usr/local/bin/fuzzy-ssh

# Remove ubuntu user
RUN deluser ubuntu
# Create desire user
RUN groupadd -g 1000 $USER && useradd -r -g 1000 -G sudo -m -s /bin/zsh -u 1000 $USER

# Switch to non-root user
USER $USER

# Install Chomaterm
RUN pip install --break-system-packages chromaterm

USER root
# Create link of ct command
RUN ln -sf /home/$USER/.local/bin/ct /usr/local/bin/ct

# Switch to non-root user
USER $USER

# Set default shell to Zsh
ENV SHELL=/bin/zsh

WORKDIR /home/$USER

# zsh config
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN curl -Lo /home/$USER/.zshrc https://raw.githubusercontent.com/mrbooshehri/sshmg/refs/heads/master/zshrc

# Command to run when container starts
CMD ["/bin/zsh"]
