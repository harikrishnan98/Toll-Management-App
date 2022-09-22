# build
npm run build

#save the latest commit hash
LOGSTRING=$(git log)
COMMIT=$(ECHO $LOGSTRING | awk '{print $2}')


#navigate into the build output directory
cd dist

# deployment

git init
git add -A 
git commit -m "deploy (commit: $COMMIT)"


#HTTPS 2FA authentication
git push -f https://github.com/harikrishnan98/Toll-Management-App.git master:gh-pages

cd ..