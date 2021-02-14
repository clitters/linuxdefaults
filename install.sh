#!/bin/bash
# Test if run with root Priv. Shouldnt.
if [ "$EUID" -eq 0 ]
  then echo "Please DONT run as root"
  exit 1
fi

echo Starting Install Script...

if [ -f "pacman.lst" ]; then
    echo "  found pacman.lst - continuing with pacman packages"
    # Test wether pacman is there
    if ! command -v pacman &> /dev/null
    then
        echo "  pacman could not be found"
        exit 2
    else
        echo "  Installing the following packages via pacman"
        cat pacman.lst
        read -p "  Are you sure? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            sudo pacman -S --needed - < pacman.lst
        fi
    fi
fi

if [ -f "git.lst" ]; then
    echo "  found git.lst - continuing with git packages"
    # Test wether git is there. Install if not.
    if ! command -v git &> /dev/null
    then
        echo "  git could not be found"
        echo "  installing git..."
        # Todo generalize.
        sudo pacman -S git || { echo 'git install failed.' ; exit 3; }
    fi

    echo "  Installing the following packages from git"
    cat git.lst
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        while read line; do
        read -a arguments <<< $line
        echo "installing ${arguments[0]} from ${arguments[1]}"
        git clone ${arguments[1]}
        cd ${arguments[0]}
        makepkg -si
        cd ..
        rm -rf ${arguments[0]}
        done < git.lst
    fi

fi

if [ -f "yay.lst" ]; then
    
    echo "  found yay.lst - continuing with yay packages"
    # Test wether git is there. Install if not.
    echo "  Installing the following packages from yay"
    cat yay.lst
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        yay -S --needed - < yay.lst
    fi
fi

echo 'all done.. i hope so.'