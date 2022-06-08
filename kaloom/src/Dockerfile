# stage golang
FROM golang:latest as golang

# go get debugger
RUN go install github.com/go-delve/delve/cmd/dlv@latest
# go get language server
RUN go install golang.org/x/tools/gopls@latest

# stage coder-server
FROM codercom/code-server:latest

ARG the_home=/home/coder
ARG project_dir=${the_home}/project
ARG the_gopath=${project_dir}/go
ARG gobin_dir=${the_gopath}/bin
ARG sys_go_dir=/usr/local/go
ARG sys_go_bin_dir=${sys_go_dir}/bin
ARG sys_local_bin=/usr/local/bin/

# move go bin from golang stage
RUN mkdir -p ${gobin_dir}
ENV GOPATH ${the_gopath}
ENV PATH ${gobin_dir}:${sys_go_bin_dir}:$PATH
COPY --from=golang ${sys_go_dir} ${sys_go_dir}
COPY --chown=coder:coder --from=golang /go/bin ${gobin_dir}

# install go linter
ARG linter_version='v1.41.1'
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b ${gobin_dir} ${linter_version}

# update apt
RUN sudo apt update

# install build-essential and pcap headers
RUN sudo apt -y install build-essential libpcap-dev

# install python2&3
RUN sudo apt -y install python python-dev python3 python3-dev python3-pip

# install pip2
RUN curl -OJ https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python2 get-pip.py

# install pylint
RUN pip install pylint
RUN pip3 install pylint

# install yaml
RUN pip install pyyaml
RUN pip3 install pyyaml

# install nodejs and its package manager
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# install bash language server
RUN sudo npm i -g bash-language-server

# update path
ARG dot_local_bin=${the_home}/.local/bin
ENV PATH ${dot_local_bin}:$PATH

# create src dir and set owner of home
RUN mkdir -p ${project_dir}/src
RUN chown -R coder:coder ${the_home}

# set entry point
COPY --chown=coder:coder entrypoint.sh ${sys_local_bin}
RUN chmod u+x ${sys_local_bin}/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
