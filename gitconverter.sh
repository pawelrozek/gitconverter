#!/bin/bash

# Check that a file was provided as input
if [ $# -lt 1 ]; then
  echo "Usage: $0 file"
  exit 1
fi

# Read the input file line by line
while read line; do
  # Split the line into the Bitbucket and GitHub URLs
  bitbucket_url=$(echo $line | cut -d'-' -f1)
  github_url=$(echo $line | cut -d'-' -f2)

  # Clone the repository from Bitbucket
  git clone --mirror $bitbucket_url
  repo_name=$(basename -s .git $bitbucket_url)

  # Change to the cloned repository directory
  cd $repo_name.git

  # Update the remote URL to the GitHub URL
  git remote set-url origin $github_url

  # Push all branches and tags to GitHub
  git push --mirror

  # Change back to the parent directory
  cd ..

  # Remove the cloned repository
  rm -rf $repo_name.git
done < $1
