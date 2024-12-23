#!/usr/bin/env bash

supports_wait() {
	"$1" --help 2>&1 | grep -q -- '--wait'
}

if git diff-index --quiet HEAD --; then
	echo "No changes to commit."
	exit 0
fi

git add .

temp_file=$(mktemp /tmp/commit_message.XXXXXX)

echo "Previous commit messages:"
echo "------------------------"
git log -n 10 --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%cd - %s"
echo "------------------------"

if supports_wait "$EDITOR"; then
	"$EDITOR" --wait "$temp_file"
else
	${EDITOR:-nano} "$temp_file"
fi

commit_message=$(cat "$temp_file")

rm "$temp_file"

echo "Commit message preview:"
echo "------------------------"
echo "$commit_message"
echo "------------------------"
echo "Is this message okay? (y/n)"
read -r confirmation

if [ "$confirmation" != "y" ]; then
	echo "Commit aborted."
	exit 0
fi

git commit -m "$commit_message"
git push origin

echo "Changes have been committed successfully."

git tag v0.11.0 $( git rev-parse HEAD ) --force
git push origin --tags --force
