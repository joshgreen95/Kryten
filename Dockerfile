FROM kalilinux/kali-rolling

RUN apt update && apt -y install \
    kali-linux-headless \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    bloodyad \
    eyewitness \
    nuclei \
    wget \
    unzip \
    golang \
    smtp-user-enum \
    && CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest \
    && apt clean \
    && pipx install kerbrute \
    && pip3 install droopescan --break-system-packages \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/root/.zshrc"]

WORKDIR /root
CMD ["zsh"]