FROM kalilinux/kali-rolling

RUN apt update && apt -y install \
    kali-linux-large \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    bloodyad \
    wget \
    unzip \
    && apt clean \
    && pipx install kerbrute\
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/root/.zshrc"]

WORKDIR /root
CMD ["zsh"]