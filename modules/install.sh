# Install command
local package="$1"; shift
install()
{
    local package="$1"; shift
    local package_hub="https://github.com/Lintine/paque-packages/raw/main"
    local package_dir="$HOME/.paque/packages"
    local package_url="$package_hub/$package.tar.gz"
    # download package from github to package dir if not exists and package url is valid
    if [ ! -d "$package_dir/$package" ] && [ -n "$package_url" ]; then
        echo "Downloading $package to $package_dir"
        mkdir -p "$package_dir/$package"
        curl -sL "$package_url" | tar -x -z -C "$package_dir/$package"
    else
        echo "Package $package already exists or package url is invalid"
        return 1
    fi
    # getting dependencies
    local package_deps="$package_dir/$package/dependencies.txt"
    echo "Looking for dependencies..."
    if [ -f "$package_deps" ]; then
        while read -r dep; do
            install "$dep"
        done < "$package_deps"
    fi
    # load package
    source modules/load.sh "$package_dir/$package"
}

install "$package" "$@"
unset -f install # remove install function