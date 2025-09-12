#!/bin/bash

DOTFILES_DIR="/home/joao/dotfiles"

FILES=(".zshrc" ".config" "scripts" ".tmux" ".tmuxifier")

EXCLUDES=(".git" "znt" ".cache" "node_modules")

check_error() {
	if [ $? -ne 0 ]; then
		echo "An error occurred. Aborting..."
		exit 1
	fi
}

for file in "${FILES[@]}"; do
	echo "Copying $file to $DOTFILES_DIR..."
 rsync -av "${EXCLUDES[@]/#/--exclude=}" "$HOME/$file" "$DOTFILES_DIR"
	check_error
done

echo "Adding all files to git..."
git -C "$DOTFILES_DIR" add .
check_errors

echo "Commiting the changes..."
git -C "$DOTFILES_DIR" commit -m "Updating dotfiles"
check_error

echo "Pushing to main..."
git -C "$DOTFILES_DIR" push origin main
check_error

echo "Dotfiles transferred successfully"
