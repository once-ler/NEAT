curl -k -u 'htaox:logan0716' https://api.github.com/user/repos -d '{"name":"NEAT"}'

git config --global user.name "htaox"
git config --global user.email htaox@hotmail.com

touch README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://htaox:logan0716@github.com/htaox/NEAT.git
git push -u origin master

## Merge add-hbase to NEAT
git remote add docker-scripts-remote https://htaox:logan0716@github.com/htaox/docker-scripts.git
git fetch docker-scripts-remote
git merge -s ours --no-commit docker-scripts-remote/add-hbase
git read-tree --prefix=docker-scripts/ -u docker-scripts-remote/add-hbase
git commit -m "Imported docker-scripts as a subtree."

#You can track upstream changes like so:
git pull -s subtree docker-scripts-remote master