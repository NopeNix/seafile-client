FROM ubuntu:22.04

# Update Routine
RUN apt update
RUN apt upgrade -y

# ARG/ENV Block
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

# Installing needed prerequisite packages
RUN apt-get -y install tzdata
RUN apt install wget lsb-release inotify-tools -y

# Installing Seafile Client
RUN wget https://linux-clients.seafile.com/seafile.asc -O /usr/share/keyrings/seafile-keyring.asc
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/seafile-keyring.asc] https://linux-clients.seafile.com/seafile-deb/$(lsb_release -cs)/ stable main" | tee /etc/apt/sources.list.d/seafile.list > /dev/null
RUN apt update
RUN apt install seafile-cli -y

# Creating Folders
RUN mkdir /app
RUN mkdir /app/seafiles

# Copy needed Data
COPY script.sh /app/script.sh
RUN chmod u+x /app/script.sh

# Run Sync Script
CMD ["/app/script.sh"]
