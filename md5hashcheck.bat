@echo off
cls

setlocal enabledelayedexpansion
set count=0

for %%F in (%*) do (
    if exist "%%F" (
        set /a count+=1
        echo File !count!: %%F
        set "file!count!=%%F"
    ) else (
        echo File %%F does not exist or cannot be accessed.
        goto error
    )
)

if !count!==0 (
    echo No valid files were provided.
    goto error
)

echo.
echo Total number of valid files: !count!
echo.
echo -------------------------

for /L %%N in (1, 1, !count!) do (
    echo Processing File %%N: !file%%N!
    for /f "tokens=*" %%a in ('certutil -hashfile "!file%%N!" MD5 2^>nul ^| findstr /v "hash"') do (
        if "%%a"=="" (
            echo Error processing file !file%%N!.
            goto error
        ) else (
            echo File %%N: !file%%N!
            echo Hash: %%a
            echo -------------------------
            echo.
        )
    )
)
endlocal
exit /b

:error
call :help
exit /b

:help
echo.
echo This script calculates the MD5 hash of a list of files passed as arguments.
echo.
echo Usage: %~nx0 [file1] [file2] ...
echo.
echo Calculates the MD5 hash of each file and prints the results.
echo.
exit /b
