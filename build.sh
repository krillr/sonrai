#!/bin/bash
cd src
cat sonrai.coffee events.coffee errors.coffee utils.coffee databases/base.coffee databases/memory.coffee databases/web/localstorage.coffee model.coffee query.coffee fields.coffee sync/base.coffee package.coffee > sonrai-bundle.coffee
coffee -bo ../ -c sonrai-bundle.coffee
