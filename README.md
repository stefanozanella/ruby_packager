# Ruby Packager Docker Image

## What is it?
The Ruby Packager is a Docker image that takes as input a Ruby version and
outputs a Debian package containing the runtime for given version. The generated
package contains a full Ruby runtime with Bundler preinstalled.

## How to use it
To build a Ruby package with the Ruby Packager you just need to create a new
container based on this image, specifying a volume that maps to the script's
output directory so that the package can be accessed from outside the container:

```shell
docker run \
  --name build_ruby_2_2 \
  --rm \
  -v /local/package/storage:/pkg \
  stefanozanella/ruby_packager:latest
```

This will generate a package at
`/local/package/storage/ruby-runtime_2.2.2_<timestamp>.deb`.

## Configuration
The example above depicts the usage of the image via its defaults. It's possible
to tweak what and where a container based on this image outputs by specifying
custom values for the defined environment variables, as in:

```shell
docker run \
  --name build_jruby_1_9 \
  -e RUBY_TYPE=jruby \
  -e RUBY_VERSION=1.9 \
  -e PKG_NAME=my-ruby \
  -e PKG_DIR=/output \
  --rm \
  -v /local/package/storage:/output \
  stefanozanella/ruby_packager:latest
```

which will output a package at
`/local/package/storage/my-ruby_1.9_<timestamp>.deb`.

The list of available options is the following:

| **Option**  | **Description**  | **Default**  |
|---|---|---|
| `RUBY_TYPE`  | The kind of ruby to be packaged, e.g. `ruby` or `jruby`  | `ruby`  |
| `RUBY_VERSION`  | Version of Ruby to build, e.g. `2.1.2p95`  | `2.2.2`  |
| `PKG_NAME` | Name of the package being built. Note that using a value of `ruby` here might result in conflicts with the distribution packages | `ruby-runtime` |
| `INSTALL_DIR` | Where Ruby will be installed in the destination system | `/opt/ruby` |
| `BUILD_DIR` | Location where the Packager will compile Ruby into. Useful if a derived container already uses the default directory for other purposes | `/target` |
| `PKG_DIR` | Location where the Packager will output the Debian package to. Useful if a container already uses the default directory for other purposes | `/pkg` |
| `BUILD_CPUS` | Number of CPUs to use while compiling the Ruby source code | `1` |

## Internals 
The Ruby Packager Docker image doesn't reinvent the wheel but just wires
together two excellent tools in order to provide a simple means to create a
package; namely [ruby-install](https://github.com/postmodern/ruby-install) 
and [fpm](https://github.com/jordansissel/fpm/wiki).

Provided configuration options are fed directly to those tools, so for
further information about the available formats and supported values please
refer to the linked documentation.
