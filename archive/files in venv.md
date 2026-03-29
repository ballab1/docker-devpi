==============================================================================================================================================
~ $ ls /env/bin
activate                  activate.nu               pip                       pip3.13                   python3.13
activate.csh              activate.ps1              pip-3.13                  python
activate.fish             activate_this.py          pip3                      python3

check-manifest            devpi-init                pkginfo                   pyproject-build           rst2s5
devpi                     devpi-passwd              prequest                  rst2html                  rst2xetex
devpi-clear-search-index  devpi-server              proutes                   rst2html4                 rst2xml
devpi-export              docutils                  pserve                    rst2html5                 waitress-serve
devpi-fsck                httpx                     pshell                    rst2latex
devpi-gen-config          hupper                    ptweens                   rst2man
devpi-gen-secret          normalizer                pviews                    rst2odt
devpi-import              pdistreport               pygmentize                rst2pseudoxml

==============================================================================================================================================
~ $ devpi-server --help
usage: devpi-server [-h] [-c CONFIGFILE] [--role {master,primary,replica,standalone,auto}] [--version] [--passwd USER] [--debug]
                    [--logger-cfg LOGGER_CFG] [--host HOST] [--port PORT] [--listen LISTEN] [--unix-socket UNIX_SOCKET]
                    [--unix-socket-perms UNIX_SOCKET_PERMS] [--threads THREADS] [--trusted-proxy TRUSTED_PROXY]
                    [--trusted-proxy-count TRUSTED_PROXY_COUNT] [--trusted-proxy-headers TRUSTED_PROXY_HEADERS]
                    [--max-request-body-size MAX_REQUEST_BODY_SIZE] [--outside-url URL] [--absolute-urls] [--profile-requests NUM]
                    [--mirror-cache-expiry SECS] [--primary-url PRIMARY_URL] [--master-url DEPRECATED_MASTER_URL]
                    [--replica-max-retries NUM] [--replica-file-search-path PATH] [--hard-links] [--replica-cert pem_file]
                    [--file-replication-threads NUM] [--proxy-timeout NUM] [--no-replica-streaming] [--request-timeout NUM]
                    [--offline-mode] [--serverdir DIR] [--storage NAME] [--keyfs-cache-size NUM] [--secretfile path] [--requests-only]
                    [--restrict-modify SPEC] [--theme THEME] [--documentation-path DOCUMENTATION_PATH] [--keep-docs-packed]
                    [--indexer-backend NAME]

Start a server which serves multiple users and indices. The special root/pypi index is a cached mirror of pypi.org and is created by
default. All indices are suitable for pip or easy_install usage and setup.py upload ... invocations.

options:
  -h, --help            Show this help message and exit.
  -c, --configfile CONFIGFILE
                        Config file to use. [None]
  --role {master,primary,replica,standalone,auto}
                        set role of this instance. The default 'auto' sets 'standalone' by default and 'replica' if the --primary-url
                        option is used. To enable the replication protocol you have to explicitly set the 'primary' role. The 'master' role
                        is the deprecated variant of 'primary'. [auto]
  --version             show devpi_version (6.14.0) [False]
  --passwd USER         (DEPRECATED, use devpi-passwd command) set password for user USER (interactive) [None]

logging options:
  --debug               run wsgi application with debug logging [False]
  --logger-cfg LOGGER_CFG
                        path to .json or .yaml logger configuration file. [None]

web serving options:
  --host HOST           domain/ip address to listen on. Use --host=0.0.0.0 if you want to accept connections from anywhere. [localhost]
  --port PORT           port to listen for http requests. [3141]
  --listen LISTEN       host:port combination to listen to for http requests. When using * for host bind to all interfaces. Use square
                        brackets for ipv6 like [::1]:8080. You can specify more than one host:port combination with multiple --listen
                        arguments. [None]
  --unix-socket UNIX_SOCKET                                                                                                12:57:22 [40/1908]
                        path to unix socket to bind to. [None]
  --unix-socket-perms UNIX_SOCKET_PERMS
                        permissions for the unix socket if used, defaults to '600'. [None]
  --threads THREADS     number of threads to start for serving clients. [50]
  --trusted-proxy TRUSTED_PROXY
                        IP address of proxy we trust. See waitress documentation. [None]
  --trusted-proxy-count TRUSTED_PROXY_COUNT
                        how many proxies we trust when chained. See waitress documentation. [None]
  --trusted-proxy-headers TRUSTED_PROXY_HEADERS
                        headers to trust from proxy. See waitress documentation. [None]
  --max-request-body-size MAX_REQUEST_BODY_SIZE
                        maximum number of bytes in request body. This controls the max size of package that can be uploaded. [1073741824]
  --outside-url URL     the outside URL where this server will be reachable. Set this if you proxy devpi-server through a web server and
                        the web server does not set or you want to override the custom X-outside-url header. [None]
  --absolute-urls       use absolute URLs everywhere. This will become the default at some point. [False]
  --profile-requests NUM
                        profile NUM requests and print out cumulative stats. After print profiling is restarted. By default no profiling is
                        performed. [0]

mirroring options:
  --mirror-cache-expiry SECS
                        (experimental) time after which projects in mirror indexes are checked for new releases. [1800]

replica options:
  --primary-url PRIMARY_URL
                        run as a replica of the specified primary server [None]
  --master-url DEPRECATED_MASTER_URL
                        DEPRECATED, use --primary-url instead [None]
  --replica-max-retries NUM
                        Number of retry attempts for replica connection failures (such as aborted connections to pypi). [0]
  --replica-file-search-path PATH
                        path to existing files to try before downloading from primary. These could be from a previous replication attempt
                        or downloaded separately. Expects the structure from previous state or +files. [None]
  --hard-links          use hard links during export, import or with --replica-file-search-path instead of copying or downloading files.
                        All limitations for hard links on your OS apply. USE AT YOUR OWN RISK [False]
  --replica-cert pem_file
                        when running as a replica, use the given .pem file as the SSL client certificate to authenticate to the server
                        (EXPERIMENTAL) [None]
  --file-replication-threads NUM
                        number of threads for file download from primary [5]
  --proxy-timeout NUM   Number of seconds to wait before proxied requests from the replica to the primary time out (login, uploads etc).
                        [30]
  --no-replica-streaming
                        use separate requests instead of replica streaming protocol [False]

request options:
  --request-timeout NUM
                        Number of seconds before request being terminated (such as connections to pypi, etc.). [5]
  --offline-mode        (experimental) prevents connections to any upstream server (e.g. pypi) and only serves locally cached files through
                        the simple index used by pip. [False]

storage options:
  --serverdir DIR       directory for server data. [/data/server]
  --storage NAME        the storage backend to use. "sqlite": SQLite backend with files on the filesystem [sqlite]
  --keyfs-cache-size NUM
                        size of keyfs cache. If your devpi-server installation gets a lot of writes, then increasing this might improve
                        performance. Each entry uses 1kb of memory on average. So by default about 10MB are used. [10000]

deployment options:
  --secretfile path     file containing the server side secret used for user validation. If not specified, a random secret is generated on
                        each start up. [None]
  --requests-only       only start as a worker which handles read/write web requests but does not run an event processing or replication
                        thread. [False]

permission options:
  --restrict-modify SPEC
                        specify which users/groups may create other users and their indices. Multiple users and groups are separated by
                        commas. Groups need to be prefixed with a colon like this: ':group'. By default anonymous users can create users
                        and then create indices themself, but not modify other users and their indices. The root user can do anything. When
                        this option is set, only the specified users/groups can create and modify users and indices. You have to add root
                        explicitly if wanted. [None]

devpi-web theme options:
  --theme THEME         folder with template and resource overwrites for the web interface [None]

devpi-web doczip options:
  --documentation-path DOCUMENTATION_PATH
                        path for unzipped documentation. By default the --serverdir is used. [None]
  --keep-docs-packed    fetch data from doczips instead of unpacking them [False]

devpi-web search indexing:
  --indexer-backend NAME
                        the indexer backend to use [whoosh]

==============================================================================================================================================
~ $ devpi --help
usage: devpi [-h] [--version] [--debug] [-y] [-v] [--clientdir DIR]
             {use,getjson,patchjson,list,remove,user,passwd,login,logoff,logout,index,upload,test,push,install,refresh} ...

The devpi commands (installed via devpi-client) wrap common Python packaging, uploading, installation and testing activities, using a
remote devpi-server managed index. For more information see http://doc.devpi.net

positional arguments:
  {use,getjson,patchjson,list,remove,user,passwd,login,logoff,logout,index,upload,test,push,install,refresh}
    use                 show/configure current index and target venv for install activities.
    getjson             show remote server and index configuration.
    patchjson           send a PATCH request with the specified json content to the specified path.
    list                list project versions and files for the current index.
    remove              removes project info/files from current index.
    user                add, remove, modify, list user configuration.
    passwd              change password of specified user or current user if not specified.
    login               login to devpi-server with the specified user.
    logoff              log out of the current devpi-server.
    logout              log out of the current devpi-server.
    index               create, delete and manage indexes.
    upload              (build and) upload packages to the current devpi-server index.
    test                download and test a package against tox environments.
    push                push a release and releasefiles to an internal or external index.
    install             install packages through current devpi index.
    refresh             invalidates the mirror caches for the specified package(s).

options:
  -h, --help            show this help message and exit
  --version             show program's version number and exit

generic options:
  --debug               show debug messages including more info on server requests
  -y                    assume 'yes' on confirmation questions
  -v, --verbose         increase verbosity
  --clientdir DIR       directory for storing login and other state
==============================================================================================================================================
