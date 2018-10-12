# Introducing Bears (beta)

Bears is a Delegated Proof of Stake blockchain that uses a "Proof of Brain" social consnensus algorithm for token allocation.

  - Currency symbol BEARS.
  - 10% APR inflation narrowing to 1% APR over 20 years.
  - 75% of inflation to "Proof of Brain" social consensus algorithm.
  - 15% of inflation to stake holders.
  - 10% of inflation to block producers.

# Public Announcement & Discussion

Bears was announced on the
[Bitcointalk forum](https://bitcointalk.org/index.php?topic=1410943.new) prior to
the start of any mining.

# No Support & No Warranty

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

# Whitepaper

You can read the Bears Whitepaper at [Bears.io/BearsWhitePaper.pdf](https://bears.io/BearsWhitePaper.pdf).

# Quickstart

Just want to get up and running quickly? We have pre-build docker images for your convenience. More details are in our [quickstart guide](https://github.com/bearshares/bears/blob/master/doc/exchangequickstart.md).

# Building

We strongly recommend using one of our pre-built Docker images or using Docker to build Bears. Both of these processes are described in the [quickstart guide](https://github.com/bearshares/bears/blob/master/doc/exchangequickstart.md).

If you would still like to build from source, we do have [build instructions](https://github.com/bearshares/bears/blob/master/doc/building.md) for Linux (Ubuntu LTS) and macOS X.

## Dockerized p2p Node

To run a p2p node (ca. 2GB of memory is required at the moment):

    docker run \
        -d -p 3331:3331 -p 6990:6990 --name bearsd-default \
        bearshares/bears

    docker logs -f bearsd-default  # follow along

## Dockerized Full Node

To run a node with *all* the data (e.g. for supporting a content website)
that uses ca. 14GB of memory and growing:

    docker run \
        --env USE_WAY_TOO_MUCH_RAM=1 --env USE_FULL_WEB_NODE=1 \
        -d -p 3331:3331 -p 6990:6990 --name bearsd-full \
        bearshares/bears

    docker logs -f bearsd-full

# Environment variables

There are quite a few environment variables that can be set to run bearsd in different ways:

* `USE_WAY_TOO_MUCH_RAM` - if set to true, bearsd starts a 'full node'
* `USE_FULL_WEB_NODE` - if set to true, a default config file will be used that enables a full set of API's and associated plugins.
* `USE_NGINX_FRONTEND` - if set to true, this will enable an NGINX reverse proxy in front of bearsd that proxies websocket requests to bearsd. This will also enable a custom healtcheck at the path '/health' that lists how many seconds away from current blockchain time your node is. It will return a '200' if it's less than 60 seconds away from synced.
* `USE_MULTICORE_READONLY` - if set to true, this will enable bearsd in multiple reader mode to take advantage of multiple cores (if available). Read requests are handled by the read-only nodes, and write requests are forwarded back to the single 'writer' node automatically. NGINX load balances all requests to the reader nodes, 4 per available core. This setting is still considered experimental and may have trouble with some API calls until further development is completed.
* `HOME` - set this to the path where you want bearsd to store it's data files (block log, shared memory, config file, etc). By default `/var/lib/bearsd` is used and exists inside the docker container. If you want to use a different mountpoint (like a ramdisk, or a different drive) then you may want to set this variable to map the volume to your docker container.

# PaaS mode

Bearsd now supports a PaaS mode (platform as a service) that currently works with Amazon's Elastic Beanstalk service. It can be launched using the following environment variables:

* `USE_PAAS` - if set to true, bearsd will launch in a format that works with AWS EB. Containers will exit upon failure so that they can be relaunched automatically by ECS. This mode assumes `USE_WAY_TOO_MUCH_RAM` and `USE_FULL_WEB_NODE`, they do not need to be also set.
* `S3_BUCKET` - set this to the name of the S3 bucket where you will store shared memory files for bearsd in Amazon S3. They will be stored compressed in bz2 format with the file name `blockchain-$VERSION-latest.tar.bz2`, where $VERSION is the release number followed by the git short commit hash stored in each docker image at `/etc/bearsdversion`.
* `SYNC_TO_S3` - if set to true, the node will function to only generate shared memory files and upload them to the specified S3 bucket. This makes fast deployments and autoscaling for bearsd possible.

# Seed Nodes

A list of some seed nodes to get you started can be found in
[doc/seednodes.txt](doc/seednodes.txt).

This same file is baked into the docker images and can be overridden by
setting `BEARSD_SEED_NODES` in the container environment at `docker run`
time to a whitespace delimited list of seed nodes (with port).

# Testing

See [doc/testing.md](doc/testing.md) for test build targets and info
on how to use lcov to check code test coverage.

# System Requirements

For a full web node, you need at least 270GB of disk space available. Bearsd uses a memory mapped file which currently holds 189GB of data and by default is set to use up to 215GB. The block log of the blockchain itself is a little over 48GB. It's highly recommended to run bearsd on a fast disk such as an SSD or by placing the shared memory files in a ramdisk and using the `--shared-file-dir=/path` command line option to specify where. At least 16GB of memory is required for a full web node. Seed nodes (p2p mode) can run with as little as 4GB of memory with a 24 GB state file. Any CPU with decent single core performance should be sufficient. Bearsd is constantly growing. As of December 2017, these numbers were accurate, but you may find you need more disk space to run a full node. We are also constantly working on optimizing Bears's use of disk space.

On Linux use the following Virtual Memory configuration for the initial sync and subsequent replays. It is not needed for normal operation.

```
echo    75 | sudo tee /proc/sys/vm/dirty_background_ratio
echo  1000 | sudo tee /proc/sys/vm/dirty_expire_centisec
echo    80 | sudo tee /proc/sys/vm/dirty_ratio
echo 30000 | sudo tee /proc/sys/vm/dirty_writeback_centisec
```
