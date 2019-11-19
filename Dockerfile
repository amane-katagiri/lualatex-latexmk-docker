FROM alpine
MAINTAINER Amane Katagiri <amane@ama.ne.jp>

ENV TEXLIVE_TMP /tmp/texlive
ENV TEXLIVE_PROFILE /tmp/texlive/texlive.profile
ENV FONT_DIR /usr/local/texlive/texmf-local/fonts
ENV FONT_TMP /tmp/font
ENV PATH $PATH:/usr/local/texlive/2019/bin/x86_64-linuxmusl/

RUN apk --no-cache add bash findutils perl fontconfig-dev wget curl ca-certificates tar unzip \
    && mkdir -p $TEXLIVE_TMP \
    && echo "selected_scheme scheme-basic" >> $TEXLIVE_PROFILE \
    && echo "option_doc 0" >> $TEXLIVE_PROFILE \
    && echo "option_src 0" >> $TEXLIVE_PROFILE \
    && curl -Ss ftp://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz | tar zx -C $TEXLIVE_TMP --strip-components=1 \
    && echo I | $TEXLIVE_TMP/install-tl --profile=$TEXLIVE_PROFILE \
    && tlmgr install collection-latex collection-luatex luatexbase collection-langjapanese pdfpages \
                     changepage xkeyval etoolbox filehook fontspec ms setspace pdfx xcolor xmpincl latexmk \
    && mkdir -p $FONT_TMP \
    && mkdir -p $FONT_DIR/opentype/gen-ei-koburi-min \
    && mkdir -p $FONT_DIR/opentype/gen-ei-gothic-n \
    && curl -Ss -L https://okoneya.jp/font/GenEiKoburiMin-2.2a.zip > $FONT_TMP/genmin.zip \
    && curl -Ss -L https://okoneya.jp/font/GenEiGothicN-1.1.zip > $FONT_TMP/gengot.zip \
    && unzip $FONT_TMP/genmin.zip -d $FONT_TMP/genmin \
    && unzip $FONT_TMP/gengot.zip -d $FONT_TMP/gengot \
    && find $FONT_TMP/genmin -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX $FONT_DIR/opentype/gen-ei-koburi-min/ \
    && find $FONT_TMP/gengot -type f -name "*.otf" -print0 | xargs -0 -IXXX mv XXX $FONT_DIR/opentype/gen-ei-gothic-n/ \
    && ln -s /usr/local/texlive/texmf-local/fonts/ /usr/share/fonts \
    && luaotfload-tool -u \
    && fc-cache \
    && mktexlsr \
    && apk --no-cache del tar unzip \
    && rm -rf $FONT_TMP $TEXLIVE_TMP \
    && mkdir /data

WORKDIR /data
CMD ["/bin/bash"]
