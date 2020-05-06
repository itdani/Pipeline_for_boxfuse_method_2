FROM tomcat:jdk8-openjdk
# Install pacakges
RUN apt update && apt install -y git maven docker.io
# Clear cache
RUN apt clean
