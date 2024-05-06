# 群星mod脚本

## 用途

GOG平台使用Steam的mod。

## 说明

### 使用说明

脚本用到了 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD:zh-cn) ，需要先行安装。

Steam上的创意工坊链接：https://steamcommunity.com/sharedfiles/filedetails/?id=2645707091

将其中的id填入 `mod_list.txt` ，然后执行脚本即可。

### 原理说明

1. 使用 SteamCMD 下载mod。
2. 取到mod的`descriptor.mod`文件，在其中添加mod的绝对路径，得到新的`descriptor.mod`文件。
3. 将新的`descriptor.mod`文件写入群星mod文件夹。
