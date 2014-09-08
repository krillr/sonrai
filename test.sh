istanbul cover _mocha  -- --compilers coffee:coffee-script/register
coffee -c test/*.coffee
mochify --wd
rm test/*.js
