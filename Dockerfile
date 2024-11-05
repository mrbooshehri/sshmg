FROM docker.arvancloud.ir/ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-color \
    LC_ALL=C.UTF-8 \
    TZ=Asia/tehran \
    LANG=C.UTF-8

# Update and upgrade
RUN apt-get update && apt-get upgrade -y

# Install build tools and dependencies
RUN apt-get install -y curl wget python3-pip tmux bsdmainutils openssh-client zsh sshpass xsel vim s3cmd telnet inetutils-ping \
    && rm -rf /var/lib/apt/lists/*

# Set as default shell
RUN chsh -s $(which zsh)

# Set fzf version environment 
ENV FZF_VERSION=0.56.0

# Download and install FZF (latest version)
RUN curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz \
    && tar xzf /tmp/fzf.tar.gz -C /usr/local/bin \
    && rm /tmp/fzf.tar.gz

# Download the 'tunnel' script and add it to PATH
RUN curl -Lo /usr/local/bin/tunnel https://raw.githubusercontent.com/mrbooshehri/dot/refs/heads/master/scripts/tunnel \
    && chmod +x /usr/local/bin/tunnel

# Download the 'fuzzy-ssh' script and add it to PATH
RUN curl -Lo /usr/local/bin/fuzzy-ssh https://raw.githubusercontent.com/mrbooshehri/cmd-fuzzy-ssh/refs/heads/master/fuzzy-ssh \
    && chmod +x /usr/local/bin/fuzzy-ssh


# Create a non-root user
ENV USER=mosh
RUN groupadd -g 1001 $USER && useradd -r -g 1001 -G sudo -m -s /bin/zsh -u 1001 $USER

# Switch to non-root user
USER $USER

# Set default shell to Zsh
ENV SHELL=/bin/zsh

# Install Chomaterm
RUN pip install --break-system-packages chromaterm

# Create link of ct command
USER root
RUN ln -sf /home/$USER/.local/bin/ct /usr/local/bin/ct

# Switch to non-root user
USER $USER

WORKDIR /home/$USER

RUN cp /etc/zsh/newuser.zshrc.recommended .zshrc

# Command to run when container starts
CMD ["/bin/zsh"]
