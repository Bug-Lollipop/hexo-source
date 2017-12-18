hexo generate
cp -R public/* Bug-Lollipop.github.io
cd Bug-Lollipop.github.io
git add .
git commit -m "update"
git push origin master
