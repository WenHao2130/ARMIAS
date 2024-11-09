**简体中文** | [日本語](README_JP.md) | [English](README_EN.md)

# 高自定义度的自动安装模块


#### 基础操作


- 将所有模块（zip文件）放入`modules`文件夹中即可。
**注意**：请确保文件名**不含特殊字符**。


#### 进阶功能（可选阅读）


- **DATA和SDCARD一键覆盖**  
  - 鉴于某些模块安装后会生成配置文件等在data/或android文件夹中。
  - 本模块提供一键将模块内目标文件批量复制至data/或sdcard/的功能，便于模块的配置与使用。
  - 同时，也支持直接修改`data`和`sdcard`。  
  **注意**：此操作会复制“模块内目标目录/*”下的所有文件，请确保设置了正确的文件夹结构，并**正确设置权限**。  
  模块内目录示例：`patches/sdcard/`, `patches/data/`, `patches/apks/`


- **自动批量安装APK** `(su)`  
  一个简洁明了的功能，方便您批量安装APK。


- **安装后模块修补**  
  将`/patches/modules/`目录下的文件复制到`data/adb/modules_update/`下
  请在`/patches/modules/`目录下创建与安装模块id相同的文件夹，并将需要补丁的文件放入该文件夹中


- **配置文件：settings.sh**  
  支持修改模块80%的路径变量，语言，禁用log，设置最低安卓API、Magisk版本、ksu版本、apatch版本，以及自定义脚本。  
  __如遇安装问题，请尝试启用**兼容模式**。__


- **语言文件**  
  默认路径 `languages.txt`
  支持修改语言文件


- **高级功能：自定义安装模板**  
  详情见注释

#### 兼容性


- 兼容Magisk、KernelSU、APatch

- 支持在TWRP中安装Magisk模块

#### 使用指南


- 将模块（zip文件）放入`modules`文件夹

- 将其他文件分类放入`patches`文件夹的对应子文件夹中

#### 重要提示


- **文件名请勿包含特殊字符**