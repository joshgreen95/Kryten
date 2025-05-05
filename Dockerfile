FROM kalilinux/kali-rolling

# Install tools
RUN apt update && apt -y install \
    kali-linux-large \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Share host zsh config if exists
VOLUME ["/root/.zshrc"]

WORKDIR /root
CMD ["zsh"]