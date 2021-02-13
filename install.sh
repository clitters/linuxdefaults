#!/bin/bash
# Todo dont be root check
echo Starting Install Script...

echo Installing the following packages via pacman
cat pacman.lst
read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    pacman -S --needed - < pacman.lst
fi

# Todo test if git is there
echo Installing the following packages from git
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
    done < git.lst
fi


echo Installing packages from yay
echo Installing the following packages via pacman
cat yay.lst
read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    yay -S --needed - < yay.lst
fi

echo 'all done.. i hope so.'