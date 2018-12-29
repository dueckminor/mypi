FROM @OWNER@/@CPU@-openjre

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.14

ENV TOMCAT_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN                                                                            \
    set -e;                                                                    \
    wget -O apache-tomcat.tar.gz $TOMCAT_URL;                                  \
    tar -xvf apache-tomcat.tar.gz --strip-components=1;                        \
    rm bin/*.bat;                                                              \
    rm apache-tomcat.tar.gz*;                                                  \
    nativeBuildDir="$(mktemp -d)"; \
	tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	apk add --no-cache --virtual .native-build-deps                            \
		apr-dev coreutils dpkg-dev dpkg gcc libc-dev make openjdk8 openssl-dev;\
	( \
		export CATALINA_HOME="$PWD"; \
		cd "$nativeBuildDir/native"; \
		gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
		./configure \
			--build="$gnuArch" \
			--libdir="/usr/lib" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$(which apr-1-config)" \
            --with-java-home=/usr/lib/jvm/java-1.8-openjdk \
			--with-ssl=yes; \
		make -j "$(nproc)"; \
		make install; \
	); \
	rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \

EXPOSE 8080
CMD ["catalina.sh", "run"]
