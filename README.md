# 環境準備

```
# 啟用模擬環境
docker run -it --rm -p 4040:4040 -p 9099:9099 -p 9005:9005 -p 9000:9000 -p 8085:8085 -p 8080:8080 -p 5001:5001 -p 5000:5000 -p 4000:4000 -p 9199:9199 -v $PWD:/home/node --name firebase-tools andreysenov/firebase-tools

10.2.2 版本的 andreysenov/firebase-tools 不會出 bug
docker run -it --rm -p 4040:4040 -p 9099:9099 -p 9005:9005 -p 9000:9000 -p 8085:8085 -p 8080:8080 -p 5001:5001 -p 5000:5000 -p 4000:4000 -p 9199:9199 -v $PWD:/home/node --name firebase-tools andreysenov/firebase-tools:10.2.2

# 登入firebase，注意此會將內容存放在.config，之後重換專案要注意
firebase login

# 至firebase 官網建立project
# 依照指示將設定貼回Project內

# firebase init 生成所需組建的設定檔
# 選用Storage與Storage Emultaor，確認規則有生成
# Emulator的管理UI Port為4040
firebase init 

# 修改firebase.json，為各個組件的json object內加上
"host":"0.0.0.0"

# 啟用模擬器，並匯入fireStorage 測試資料集
firebase emulators:start --import=./storage_mock_data

使用完畢匯出資料夾
firebase emulators:start --export-on-exit mock-data

匯入資料夾
firebase emulators:start --import mock-data

```

# Model準備

# Dao準備

# Component嵌入

# Screen導入

# 部署前，需更換Project相關設定為 測試環境、生產環境

# 未來

AD導入