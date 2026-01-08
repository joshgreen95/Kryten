FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV VENV_PATH=/opt/venv
ENV PATH=$VENV_PATH/bin:$PATH
ENV NPM_CONFIG_UNSAFE_PERM=true

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
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
    && apt-get --fix-broken -y install \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv $VENV_PATH && \
    $VENV_PATH/bin/python -m pip install --upgrade pip 

ENV CGO_ENABLED=1
RUN CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    CGO_ENABLED=1 go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Install Python packages into the virtualenv (no system-wide flags)
RUN $VENV_PATH/bin/pip install --no-cache-dir jwt aardwolf websockets wappalyzer bloodyAD aioquic netifaces metafinder setuptools wheel && \
    $VENV_PATH/bin/pip install --no-cache-dir git+https://github.com/Tib3rius/AutoRecon.git

# run nuclei template update (nuclei installed via go)
RUN /root/go/bin/nuclei -ut || true

# Configure npm then install retire-site-scanner
RUN npm config set progress false && \
    npm config set audit false && \
    npm config set fund false && \
    npm install -g --no-audit --no-fund --unsafe-perm retire-site-scanner

RUN updatedb

WORKDIR /root
CMD ["zsh"]
