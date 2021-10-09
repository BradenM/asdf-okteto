<div align="center">

# asdf-okteto [![Build](https://github.com/BradenM/asdf-okteto/actions/workflows/build.yml/badge.svg)](https://github.com/BradenM/asdf-okteto/actions/workflows/build.yml) [![Lint](https://github.com/BradenM/asdf-okteto/actions/workflows/lint.yml/badge.svg)](https://github.com/BradenM/asdf-okteto/actions/workflows/lint.yml)


[okteto](https://github.com/okteto/okteto) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add okteto
# or
asdf plugin add okteto https://github.com/BradenM/asdf-okteto.git
```

okteto:

```shell
# Show all installable versions
asdf list-all okteto

# Install specific version
asdf install okteto latest

# Set a version globally (on your ~/.tool-versions file)
asdf global okteto latest

# Now okteto commands are available
okteto version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/BradenM/asdf-okteto/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Braden Mars](https://github.com/BradenM/)
