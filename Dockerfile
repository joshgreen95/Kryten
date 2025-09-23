FROM kalilinux/kali-rolling

# keep layers small and deterministic
ENV DEBIAN_FRONTEND=noninteractive
ENV VENV_PATH=/opt/venv
ENV PATH=$VENV_PATH/bin:$PATH

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      kali-linux-headless \
      zsh \
      zsh-syntax-highlighting \
      zsh-autosuggestions \
      bloodyad \
      eyewitness \
      wget \
      unzip \
      chromium \
      golang \
      smtp-user-enum \
      pciutils \
      sipcalc \
      iputils-ping \
      feroxbuster \
      oscanner \
      redis-tools \
      jq \
      sipvicious \
      krb5-user \
      python3 \
      python3-venv \
      python3-pip \
      build-essential \
      ca-certificates \
      tnscmd10g \
    && apt-get --fix-broken -y install \
    && rm -rf /var/lib/apt/lists/*

# Create a dedicated venv and ensure pip points into it
RUN python3 -m venv $VENV_PATH && \
    $VENV_PATH/bin/python -m pip install --upgrade pip setuptools wheel

# Install Go tools (will be in GOPATH/bin or $GOBIN; keep as you had)
ENV CGO_ENABLED=1
RUN CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest \
 && CGO_ENABLED=1 go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Install Python packages into the virtualenv (no system-wide flags)
# Use the venv pip directly to avoid modifying system packages
RUN $VENV_PATH/bin/pip install --no-cache-dir jwt aardwolf websockets \
 && $VENV_PATH/bin/pip install --no-cache-dir git+https://github.com/Tib3rius/AutoRecon.git

# run nuclei template update (nuclei installed via go)
RUN /root/go/bin/nuclei -ut || true

WORKDIR /root

# default shell — zsh is installed system-wide, venv is in PATH so python/pip use venv
CMD ["zsh"]