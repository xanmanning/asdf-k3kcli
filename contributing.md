# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test k3kcli https://github.com/xanmanning/asdf-k3kcli.git "k3kcli --help"
```

Tests are automatically run in GitHub Actions on push and PR.
