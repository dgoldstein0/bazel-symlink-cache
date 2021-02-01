def _foo_test_impl(ctx):
    foo_file = ctx.file.foo_file
    symlinks = {}
    if ctx.attr.symlink_foo1:
        symlinks["foo1"] = foo_file
    if ctx.attr.symlink_foo2:
        symlinks["foo2"] = foo_file

    runfiles = ctx.runfiles(
        symlinks = symlinks,
    )
    executable = ctx.actions.declare_file(ctx.label.name)

    ctx.actions.run_shell(
        outputs = [executable],
        command = """
cat > {} <<EOF
#!/bin/sh
cmp -s foo1 foo2 || exit 1
EOF

chmod +x {}""".format(executable.path, executable.path),
    )

    return [DefaultInfo(
        files = depset([executable]),
        executable = executable,
        runfiles = runfiles,
    )]

foo_test = rule(
    _foo_test_impl,
    attrs = {
        "foo_file": attr.label(
            default = Label("//playground:generated_foo_file"),
            allow_single_file = True,
        ),
        "symlink_foo1": attr.bool(),
        "symlink_foo2": attr.bool(),
    },
    test = True,
)
