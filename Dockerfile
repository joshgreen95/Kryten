FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive
ENV VENV_PATH=/opt/venv
ENV GOBIN=/usr/local/bin
ENV PATH=$VENV_PATH/bin:$GOBIN:$PATH
ENV NPM_CONFIG_UNSAFE_PERM=true
ENV CGO_ENABLED=1
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80retries && \
    apt-get update && \
    apt-get -y install --no-install-recommends --fix-missing \
      openssl \
      libssl-dev \
      kali-linux-headless \
      zsh \
      zsh-syntax-highlighting \
      zsh-autosuggestions \
      eyewitness \
      wget \
      unzip \
      ssh-audit \
      chromium \
      golang \
      smtp-user-enum \
      coercer \
      pciutils \
      sipcalc \
      iputils-ping \
      feroxbuster \
      oscanner \
      redis-tools \
      jq \
      sipvicious \
      krb5-user \
      freerdp3-x11 \
      python3 \
      python3-full \
      python3-venv \
      python3-pip \
      build-essential \
      ca-certificates \
      tnscmd10g \
      testssl.sh \
      nodejs \
      npm \
      parallel \
      xclip \
      man-db \
      locate \
      less \
      wireshark \
      tigervnc-viewer \
      apktool \
      apksigner \
      sharpshooter \
      ntpsec-ntpdate \
      bloodhound-ce-python \
      mono-devel \
      ripgrep \
    && apt-get --fix-broken -y install \
    && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv --without-pip $VENV_PATH && \
    wget -qO- https://bootstrap.pypa.io/get-pip.py | $VENV_PATH/bin/python && \
    $VENV_PATH/bin/pip install --upgrade pip
RUN CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    CGO_ENABLED=1 go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    CGO_ENABLED=1 go install github.com/google/osv-scanner/v2/cmd/osv-scanner@latest
RUN $VENV_PATH/bin/pip install --no-cache-dir \
      jwt aardwolf websockets wappalyzer jsbeautifier bloodyAD rich aioquic netifaces metafinder setuptools wheel playwright uploadserver setuptools==66.1.1 && \
    $VENV_PATH/bin/pip install --no-cache-dir \
      git+https://github.com/Tib3rius/AutoRecon.git
RUN nuclei -ut || true
RUN npm config set progress false && \
    npm config set audit false && \
    npm config set fund false && \
    npm install -g --no-audit --no-fund --unsafe-perm retire-site-scanner \
    npm install -g --no-audit --no-fund --unsafe-perm retire \
RUN sed -i 's/^config_diagnostics = 1/config_diagnostics = 0/' /etc/ssl/openssl.cnf
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa
RUN updatedb
RUN playwright install

# AdaptixC2 Installation
RUN mkdir -p /root/.Adaptix && \
    git clone https://github.com/Adaptix-Framework/AdaptixC2 /root/.Adaptix/AdaptixC2 && \
    git clone https://github.com/Adaptix-Framework/Extension-Kit /root/.Adaptix/AdaptixC2/Extension-Kit && \
    cd /root/.Adaptix/AdaptixC2 && \
    chmod +x pre_install_linux_all.sh && \
    ./pre_install_linux_all.sh all && \
    make all && \
    cd Extension-Kit && \
    make && \
    cd /root/.Adaptix/AdaptixC2/dist && \
    chmod +x ssl_gen.sh && \
    printf '\n\n\n\n\n\n\n' | ./ssl_gen.sh && \
    ln -sf /root/.Adaptix/AdaptixC2/dist/adaptixserver /usr/local/bin/adaptixserver && \
    ln -sf /root/.Adaptix/AdaptixC2/dist/AdaptixClient /usr/local/bin/AdaptixClient
    
WORKDIR /root
CMD ["zsh"]
