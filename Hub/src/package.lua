return {
    name = "hub",
    version = "1.0.0",
    description = "",
    tags = {},
    license = "MIT",
    author = {
        name = "CoreByte"
    },
    dependencies = {
        "luvit/process",
        "luvit/require",
        "luvit/core",
        "luvit/pretty-print",
        "luvit/fs",
        "luvit/path",
        "luvit/json",
        "luvit/los",

        "luvit/secure-socket",
        "creationix/coro-http",

        "creationix/weblit"
    },
    files = {
        "**.lua",
        "!test*"
    }
}  