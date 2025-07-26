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
    pciutils \
    sipcalc \
    iputils-ping \
    feroxbuster \
    oscanner \
    redis-tools \
    sipvicious \
    tnscmd10g \
    && CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest \
    && apt clean \
    && pipx install kerbrute \
    && pip3 install droopescan --break-system-packages \
    && pip3 install git+https://github.com/Tib3rius/AutoRecon.git --break-system-packages --ignore-installed \
    && rm -rf /var/lib/apt/lists/*

#krb5-user jank
RUN echo "krb5-config krb5-config/default_realm string LOCAL" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user

VOLUME ["/root/.zshrc"]


WORKDIR /root
CMD ["zsh"]
