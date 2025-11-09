@echo off

rem NOFX开发环境管理脚本
rem 用于快速启动开发模式的Docker容器并支持代码修改后的重新编译运行

echo ==================================================
echo         NOFX 开发环境管理脚本
 echo ==================================================
echo 此脚本将帮助您在开发模式下运行项目，支持代码修改后快速重新编译

:menu
cls
echo 请选择操作：
echo 1. 启动开发环境（首次运行或重新构建）
echo 2. 重启后端服务（代码修改后）
echo 3. 查看后端日志
echo 4. 停止开发环境
echo 5. 退出

echo.
set /p choice="请输入选项 [1-5]: "

if "%choice%"=="1" goto start_dev
if "%choice%"=="2" goto restart_backend
if "%choice%"=="3" goto view_logs
if "%choice%"=="4" goto stop_dev
if "%choice%"=="5" exit /b

echo 无效选项，请重试
goto menu

:start_dev
echo 正在启动开发环境...
echo 这将构建开发镜像并启动服务，第一次运行可能需要较长时间...
docker-compose -f docker-compose.dev.yml up --build -d

echo 服务正在启动，请稍候...
pause
goto menu

:restart_backend
echo 正在重启后端服务...
echo 重启过程中将重新编译应用程序...
docker-compose -f docker-compose.dev.yml restart nofx

echo 后端服务已重启，可以通过选项3查看编译和启动日志
pause
goto menu

:view_logs
echo 查看后端服务日志（按Ctrl+C退出查看）...
docker-compose -f docker-compose.dev.yml logs -f nofx
pause
goto menu

:stop_dev
echo 正在停止开发环境...
docker-compose -f docker-compose.dev.yml down
echo 开发环境已停止
pause
goto menu

:end
echo ==================================================
echo 开发提示：
echo 1. 当您修改源代码后，只需选择选项2重启后端服务即可重新编译运行
 echo 2. 开发模式下，源代码已挂载到容器内，修改会直接生效
 echo 3. 所有配置文件和数据文件与生产环境保持一致
 echo 4. 完成开发后，建议使用标准的docker-compose.yml部署到生产环境
 echo ==================================================
pause