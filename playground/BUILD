load("//playground:foo.bzl", "foo_test")

foo_test(
    name = "test",
    symlink_foo1 = True,
    # symlink_foo2 = True,
)

genrule(
    name = "generated_foo_file",
    outs = ["foo_file.txt"],
    cmd = """echo "hello world" > $@""",
)
