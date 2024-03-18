<div align="center">

# asdf-k3kcli [![Build](https://github.com/xanmanning/asdf-k3kcli/actions/workflows/build.yml/badge.svg)](https://github.com/xanmanning/asdf-k3kcli/actions/workflows/build.yml) [![Lint](https://github.com/xanmanning/asdf-k3kcli/actions/workflows/lint.yml/badge.svg)](https://github.com/xanmanning/asdf-k3kcli/actions/workflows/lint.yml)

[k3kcli](https://github.com/rancher/k3k) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add k3kcli
# or
asdf plugin add k3kcli https://github.com/xanmanning/asdf-k3kcli.git
```

k3kcli:

```shell
# Show all installable versions
asdf list-all k3kcli

# Install specific version
asdf install k3kcli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global k3kcli latest

# Now k3kcli commands are available
k3kcli --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/xanmanning/asdf-k3kcli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Xan Manning](https://github.com/xanmanning/)
