# Start a Docker container from a config file

This script will parse the config file, pull or create the image, stop and remove any previous container with the same name and create a new one.
The script can automatically build a local image based on a path provided in the config file.


## Installation

```bash
cd
git clone https://github.com/LM1LC3N7/Dockerfiles
sudo cp Dockerfiles/appDeploy/startContainer* /usr/local/bin/
sudo chown ${USER} /usr/local/bin/startContainer*
sudo chmod a-rwx,a+x,u+rx,g+rx /usr/local/bin/startContainer*
```

## Usage

If no config file is passed as an argument, the script will try to find `config.cfg` into the current folder.

```bash
startContainer
```

Or

```bash
startContainer relative/path/to/config.cfg
```

And

```bash
startContainer /full/path/to/config.cfg
```

`startContainer-build` will automatically be used by `startContainer`.
