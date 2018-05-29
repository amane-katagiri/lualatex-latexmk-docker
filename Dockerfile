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
    && curl -Ss https://okoneya.jp/font/GenEiKoburiMin-2.2a.zip > /tmp/genmin.zip \
    && curl -Ss https://okoneya.jp/font/GenEiGothicN-1.1.zip > /tmp/gengot.zip \
    && unzip -d /tmp/sans /tmp/sans.zip \
    && unzip -d /tmp/serif /tmp/serif.zip \
    && unzip -d /tmp/genmin /tmp/genmin.zip \
    && unzip -d /tmp/gengot /tmp/gengot.zip \
    && mkdir -p /usr/share/texmf/fonts/opentype/source-han-sans \
    && mkdir -p /usr/share/texmf/fonts/opentype/source-han-serif \
    && mkdir -p /usr/share/texmf/fonts/opentype/gen-ei-koburi-min \
    && mkdir -p /usr/share/texmf/fonts/opentype/gen-ei-gothic-n \
    && find /tmp/sans -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/source-han-sans/ \
    && find /tmp/serif -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/source-han-serif/ \
    && find /tmp/genmin -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/gen-ei-koburi-min/ \
    && find /tmp/gengot -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX /usr/share/texmf/fonts/opentype/gen-ei-gothic-n/ \
    && mktexlsr \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/sans* /tmp/serif* /tmp/genmin* /tmp/gengot* /var/lib/apt/lists/* \
    && mkdir /data

WORKDIR /data
CMD ["/bin/bash"]
