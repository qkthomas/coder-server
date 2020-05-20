# stage golang
FROM golang:latest as golang

# go get debugger
RUN go get -u github.com/go-delve/delve/cmd/dlv
# go get language server
RUN GO111MODULE=on go get golang.org/x/tools/gopls@latest

# stage coder-server
FROM codercom/code-server:latest

ARG the_home=/home/coder
ARG ext_dir=${the_home}/.local/share/code-server/extensions/
ARG project_dir=${the_home}/project
ARG the_gopath=${project_dir}/go
ARG gobin_dir=${the_gopath}/bin
ARG sys_go_dir=/usr/local/go
ARG sys_go_bin_dir=${sys_go_dir}/bin
ARG sys_local_bin=/usr/local/bin/

# VSCode extensions
RUN mkdir -p ${ext_dir}
ENV SERVICE_URL https://marketplace.visualstudio.com/_apis/public/gallery
# RUN code-server  --install-extension eamodio.gitlens \
#     && code-server --install-extension ms-vscode.Go \
#     && code-server --install-extension ms-azuretools.vscode-docker \
#     # && code-server --install-extension ms-python.python \
#     && code-server --install-extension shakram02.bash-beautify \
#     # && code-server --install-extension mads-hartmann.bash-ide-vscode \
#     # && code-server --install-extension rust-lang.rust \
#     && code-server --install-extension redhat.vscode-yaml

# move go bin from golang stage
RUN mkdir -p ${gobin_dir}
ENV GOPATH ${the_gopath}
ENV PATH ${gobin_dir}:${sys_go_bin_dir}:$PATH
COPY --from=golang ${sys_go_dir} ${sys_go_dir}
COPY --chown=coder:coder --from=golang /go/bin ${gobin_dir}

# install go linter
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b ${gobin_dir} v1.24.0

# create src dir and set owner of home
RUN mkdir -p ${project_dir}/src
RUN chown -R coder:coder ${the_home}

# set entry point
COPY --chown=coder:coder entrypoint.sh ${sys_local_bin}
RUN chmod u+x ${sys_local_bin}/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]