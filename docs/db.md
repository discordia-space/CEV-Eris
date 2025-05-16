# Database informatio

The Eris build uses MySQL databases. For historical reasons, there are two databases:

- erisdb - the main database, contains all neccesary tables for game.
- donations - it stores information about donations and other things loosely related to the gameplay.

The `sql/` folder contains Docker image and schemas of the last two databases: erisdb - `schema`, donations - `donations`.

## Initial setup

- You need to install `Docker Hub`: https://www.docker.com/get-started/.
- Open the build root folder in terminal:

``sh
$ cd CEV-Eris/
```

- Build the image:

```sh
$ ./sql/Build.ps1
```

_If you only have bash/sh - run a similar file but with the extension `.sh`_

### Memory Limitation

!!! Following information is for Windows users only

Most windows Docker Hub users uses wsl2 that by default is not resourses limited.

To limit it, you need to locate (or create) file ".wslconfig" in the %UserProfile% directory and write (modify) the following
```toml
[wsl2]
memory=3GB   # Limits VM memory in WSL 2 up to 3GB
processors=2 # Makes the WSL 2 VM use two virtual processors
```

P.S. If you have information about limitation on Docker in Unix-like system, feel free to modify this guide.

### Run

```sh
$ ./sql/Run.ps1
```

You may see errors in the console - no big deal, it means that the container is running for the first time.

### Stopping DB

You can stop the MySQL container through the Docker Desktop interface or with the command:

``sh
$ docker stop erisdb
```

### Configuration

The database configuration is located in the `config/dbconfig.txt` file (if you don't have it, extract it from the `config/examples` folder). From this file the build learns where to connect to and with what login/password.

By default the configuration is already made for Docker image and it doesn't need to be touched.

### Special thanks

igorsaux for initial guide and scripts
