FROM debian:sid
MAINTAINER Amane Katagiri <amane@ama.ne.jp>

RUN sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive \
    texlive-lang-japanese \
    texlive-generic-recommended \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-extra-utils \
    texlive-font-utils \
    texlive-xetex \
    texlive-luatex \
    fonts-lmodern \
    fonts-font-awesome \
    latexmk \
    ca-certificates \
    curl \
    unzip \
    && curl -Ss https://raw.githubusercontent.com/adobe-fonts/source-han-sans/release/OTF/SourceHanSansJ.zip > /tmp/sans.zip \
    && curl -Ss https://raw.githubusercontent.com/adobe-fonts/source-han-serif/release/OTF/SourceHanSerifJ_EL-M.zip > /tmp/serif.zip \
    && unzip -d /tmp/sans /tmp/sans.zip \
    && unzip -d /tmp/serif /tmp/serif.zip \
    && mkdir -p /usr/share/texmf/fonts/opentype/source-han-sans \
    && mkdir -p /usr/share/texmf/fonts/opentype/source-han-serif \
    && find /tmp/sans -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/source-han-sans/ \
    && find /tmp/serif -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/source-han-serif/ \
    && mktexlsr \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/sans* /tmp/serif* /var/lib/apt/lists/* \
    && mkdir /data

WORKDIR /data
CMD ["/bin/bash"]
