


#!/bin/sh
# ----------------------------------------------------------------------------
#  Copyright 2001-2006 The Apache Software Foundation.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
#   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
#   reserved.


# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
BASEDIR=`cd "$PRGDIR/.." >/dev/null; pwd`

# Reset the REPO variable. If you need to influence this use the environment setup file.
REPO=


# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
		   if [ -z "$JAVA_HOME" ]; then
		      if [ -x "/usr/libexec/java_home" ]; then
			      JAVA_HOME=`/usr/libexec/java_home`
			  else
			      JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
			  fi
           fi
           ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# If a specific java binary isn't specified search for the standard 'java' binary
if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java`
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." 1>&2
  echo "  We cannot execute $JAVACMD" 1>&2
  exit 1
fi

if [ -z "$REPO" ]
then
  REPO="$BASEDIR"/repo
fi

CLASSPATH="$REPO"/com/uber/uReplicator/uReplicator-Common/2.0.0-SNAPSHOT/uReplicator-Common-2.0.0-SNAPSHOT.jar:"$REPO"/com/uber/uReplicator/uReplicator-Controller/2.0.0-SNAPSHOT/uReplicator-Controller-2.0.0-SNAPSHOT.jar:"$REPO"/com/uber/uReplicator/uReplicator-Worker/2.0.0-SNAPSHOT/uReplicator-Worker-2.0.0-SNAPSHOT.jar:"$REPO"/org/scalatest/scalatest_2.11/2.2.5/scalatest_2.11-2.2.5.jar:"$REPO"/com/uber/uReplicator/uReplicator-Manager/2.0.0-SNAPSHOT/uReplicator-Manager-2.0.0-SNAPSHOT.jar:"$REPO"/org/scala-lang/scala-compiler/2.11.12/scala-compiler-2.11.12.jar:"$REPO"/org/scala-lang/scala-library/2.11.12/scala-library-2.11.12.jar:"$REPO"/org/scala-lang/scala-reflect/2.11.12/scala-reflect-2.11.12.jar:"$REPO"/org/scala-lang/modules/scala-xml_2.11/1.0.5/scala-xml_2.11-1.0.5.jar:"$REPO"/org/scala-lang/modules/scala-parser-combinators_2.11/1.0.4/scala-parser-combinators_2.11-1.0.4.jar:"$REPO"/org/apache/kafka/kafka_2.11/1.1.1/kafka_2.11-1.1.1.jar:"$REPO"/com/typesafe/scala-logging/scala-logging_2.11/3.8.0/scala-logging_2.11-3.8.0.jar:"$REPO"/org/apache/kafka/kafka-clients/1.1.1/kafka-clients-1.1.1.jar:"$REPO"/org/lz4/lz4-java/1.4.1/lz4-java-1.4.1.jar:"$REPO"/org/xerial/snappy/snappy-java/1.1.7.1/snappy-java-1.1.7.1.jar:"$REPO"/org/apache/helix/helix-core/0.6.8/helix-core-0.6.8.jar:"$REPO"/org/codehaus/jackson/jackson-core-asl/1.8.5/jackson-core-asl-1.8.5.jar:"$REPO"/org/codehaus/jackson/jackson-mapper-asl/1.8.5/jackson-mapper-asl-1.8.5.jar:"$REPO"/org/apache/commons/commons-math/2.1/commons-math-2.1.jar:"$REPO"/commons-codec/commons-codec/1.6/commons-codec-1.6.jar:"$REPO"/com/google/guava/guava/15.0/guava-15.0.jar:"$REPO"/org/yaml/snakeyaml/1.12/snakeyaml-1.12.jar:"$REPO"/com/yammer/metrics/metrics-core/2.2.0/metrics-core-2.2.0.jar:"$REPO"/com/101tec/zkclient/0.11/zkclient-0.11.jar:"$REPO"/org/apache/zookeeper/zookeeper/3.4.14/zookeeper-3.4.14.jar:"$REPO"/jline/jline/0.9.94/jline-0.9.94.jar:"$REPO"/org/apache/yetus/audience-annotations/0.5.0/audience-annotations-0.5.0.jar:"$REPO"/io/netty/netty/3.10.6.Final/netty-3.10.6.Final.jar:"$REPO"/net/sf/jopt-simple/jopt-simple/5.0.2/jopt-simple-5.0.2.jar:"$REPO"/junit/junit/4.6/junit-4.6.jar:"$REPO"/com/fasterxml/jackson/core/jackson-databind/2.9.9.2/jackson-databind-2.9.9.2.jar:"$REPO"/com/fasterxml/jackson/core/jackson-annotations/2.9.0/jackson-annotations-2.9.0.jar:"$REPO"/com/fasterxml/jackson/core/jackson-core/2.9.9/jackson-core-2.9.9.jar:"$REPO"/org/restlet/jse/org.restlet/2.2.1/org.restlet-2.2.1.jar:"$REPO"/org/restlet/jee/org.restlet.ext.jackson/2.2.1/org.restlet.ext.jackson-2.2.1.jar:"$REPO"/com/fasterxml/jackson/dataformat/jackson-dataformat-csv/2.2.3/jackson-dataformat-csv-2.2.3.jar:"$REPO"/com/fasterxml/jackson/dataformat/jackson-dataformat-smile/2.2.3/jackson-dataformat-smile-2.2.3.jar:"$REPO"/com/fasterxml/jackson/dataformat/jackson-dataformat-xml/2.2.3/jackson-dataformat-xml-2.2.3.jar:"$REPO"/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.2.3/jackson-dataformat-yaml-2.2.3.jar:"$REPO"/com/fasterxml/jackson/module/jackson-module-jaxb-annotations/2.2.3/jackson-module-jaxb-annotations-2.2.3.jar:"$REPO"/org/codehaus/woodstox/woodstox-core-asl/4.2.0/woodstox-core-asl-4.2.0.jar:"$REPO"/javax/xml/stream/stax-api/1.0-2/stax-api-1.0-2.jar:"$REPO"/org/codehaus/woodstox/stax2-api/3.1.3/stax2-api-3.1.3.jar:"$REPO"/org/restlet/jee/org.restlet/2.2.1/org.restlet-2.2.1.jar:"$REPO"/org/restlet/jee/org.restlet.ext.fileupload/2.2.1/org.restlet.ext.fileupload-2.2.1.jar:"$REPO"/commons-fileupload/commons-fileupload/1.3/commons-fileupload-1.3.jar:"$REPO"/org/restlet/jse/org.restlet.ext.jetty/2.2.1/org.restlet.ext.jetty-2.2.1.jar:"$REPO"/org/eclipse/jetty/jetty-ajp/8.1.14.v20131031/jetty-ajp-8.1.14.v20131031.jar:"$REPO"/org/eclipse/jetty/jetty-io/8.1.14.v20131031/jetty-io-8.1.14.v20131031.jar:"$REPO"/org/eclipse/jetty/jetty-util/8.1.14.v20131031/jetty-util-8.1.14.v20131031.jar:"$REPO"/javax/servlet/javax.servlet-api/3.0.1/javax.servlet-api-3.0.1.jar:"$REPO"/io/dropwizard/metrics/metrics-jmx/4.0.2/metrics-jmx-4.0.2.jar:"$REPO"/io/dropwizard/metrics/metrics-graphite/4.0.2/metrics-graphite-4.0.2.jar:"$REPO"/com/rabbitmq/amqp-client/4.4.1/amqp-client-4.4.1.jar:"$REPO"/io/dropwizard/metrics/metrics-core/4.0.2/metrics-core-4.0.2.jar:"$REPO"/commons-cli/commons-cli/1.3.1/commons-cli-1.3.1.jar:"$REPO"/commons-configuration/commons-configuration/1.6/commons-configuration-1.6.jar:"$REPO"/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar:"$REPO"/commons-lang/commons-lang/2.4/commons-lang-2.4.jar:"$REPO"/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar:"$REPO"/commons-digester/commons-digester/1.8/commons-digester-1.8.jar:"$REPO"/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar:"$REPO"/commons-beanutils/commons-beanutils-core/1.8.0/commons-beanutils-core-1.8.0.jar:"$REPO"/commons-io/commons-io/2.4/commons-io-2.4.jar:"$REPO"/org/eclipse/jetty/jetty-server/9.2.28.v20190418/jetty-server-9.2.28.v20190418.jar:"$REPO"/org/eclipse/jetty/jetty-servlet/9.2.28.v20190418/jetty-servlet-9.2.28.v20190418.jar:"$REPO"/org/eclipse/jetty/jetty-security/9.2.28.v20190418/jetty-security-9.2.28.v20190418.jar:"$REPO"/org/eclipse/jetty/jetty-http/9.2.28.v20190418/jetty-http-9.2.28.v20190418.jar:"$REPO"/org/eclipse/jetty/jetty-continuation/9.2.28.v20190418/jetty-continuation-9.2.28.v20190418.jar:"$REPO"/com/alibaba/fastjson/1.2.31/fastjson-1.2.31.jar:"$REPO"/org/apache/httpcomponents/httpcore/4.4.1/httpcore-4.4.1.jar:"$REPO"/org/apache/httpcomponents/httpclient/4.4.1/httpclient-4.4.1.jar:"$REPO"/org/testng/testng/6.5.1/testng-6.5.1.jar:"$REPO"/org/beanshell/bsh/2.0b4/bsh-2.0b4.jar:"$REPO"/com/beust/jcommander/1.12/jcommander-1.12.jar:"$REPO"/org/eclipse/jgit/org.eclipse.jgit/4.0.0.201506020755-rc3/org.eclipse.jgit-4.0.0.201506020755-rc3.jar:"$REPO"/com/jcraft/jsch/0.1.51/jsch-0.1.51.jar:"$REPO"/com/googlecode/javaewah/JavaEWAH/0.7.9/JavaEWAH-0.7.9.jar:"$REPO"/io/sentry/sentry-log4j/1.6.3/sentry-log4j-1.6.3.jar:"$REPO"/io/sentry/sentry/1.6.3/sentry-1.6.3.jar:"$REPO"/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar:"$REPO"/org/slf4j/slf4j-log4j12/1.7.25/slf4j-log4j12-1.7.25.jar:"$REPO"/log4j/log4j/1.2.17/log4j-1.2.17.jar:"$REPO"/org/apache/commons/commons-lang3/3.3.2/commons-lang3-3.3.2.jar:"$REPO"/org/projectlombok/lombok/1.16.16/lombok-1.16.16.jar:"$REPO"/com/github/spotbugs/spotbugs-annotations/3.1.12/spotbugs-annotations-3.1.12.jar:"$REPO"/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar:"$REPO"/com/uber/uReplicator/uReplicator-Distribution/2.0.0-SNAPSHOT/uReplicator-Distribution-2.0.0-SNAPSHOT.jar

ENDORSED_DIR=
if [ -n "$ENDORSED_DIR" ] ; then
  CLASSPATH=$BASEDIR/$ENDORSED_DIR/*:$CLASSPATH
fi

if [ -n "$CLASSPATH_PREFIX" ] ; then
  CLASSPATH=$CLASSPATH_PREFIX:$CLASSPATH
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$HOME" ] && HOME=`cygpath --path --windows "$HOME"`
  [ -n "$BASEDIR" ] && BASEDIR=`cygpath --path --windows "$BASEDIR"`
  [ -n "$REPO" ] && REPO=`cygpath --path --windows "$REPO"`
fi

exec "$JAVACMD" $JAVA_OPTS -Dapp_name=uReplicator-Worker -cp /usr/src/app/uReplicator-Distribution/target/uReplicator-Distribution-2.0.0-SNAPSHOT-jar-with-dependencies.jar -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintAdaptiveSizePolicy -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+PrintReferenceGC -XX:+ParallelRefProcEnabled -XX:G1HeapRegionSize=8m -XX:InitiatingHeapOccupancyPercent=85 -XX:+UnlockExperimentalVMOptions -XX:G1MixedGCLiveThresholdPercent=85 -XX:G1HeapWastePercent=5 \
  -classpath "$CLASSPATH" \
  -Dapp.name="start-worker" \
  -Dapp.pid="$$" \
  -Dapp.repo="$REPO" \
  -Dapp.home="$BASEDIR" \
  -Dbasedir="$BASEDIR" \
  com.uber.stream.kafka.mirrormaker.starter.MirrorMakerStarter \
  startMirrorMakerWorker "$@"
