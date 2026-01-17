<#
	restart-on-offline.ps1
	每10分钟检测一次网络（默认检查 8.8.8.8），若首次失败则立即重试3次，仍失败则重启计算机。
	说明：请以管理员权限运行此脚本，或把它作为开机任务使用。
#>

param()

Write-Host "启动网络监测脚本，按 Ctrl+C 停止。"

function Assert-Admin {
	$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	if (-not $isAdmin) {
		Write-Host "请以管理员权限运行此脚本。"
		exit 1
	}
}

Assert-Admin

$CheckHost = '223.5.5.5'
$IntervalMinutes = 10
$RetryCount = 3
$RetryDelaySeconds = 5
$LogFile = Join-Path $PSScriptRoot 'restart-on-offline.log'

function Test-Network {
	param(
		[string]$HostName
	)
	try {
		return Test-NetConnection -ComputerName $HostName -WarningAction SilentlyContinue -InformationLevel Quiet
	} catch {
		return $false
	}
}

while ($true) {
	$time = Get-Date -Format o
	$ok = Test-Network -HostName $CheckHost
	if ($ok) {
		"$time 网络正常: $CheckHost" | Out-File -FilePath $LogFile -Append -Encoding UTF8
	} else {
		"$time 初次检测网络失败，开始重试..." | Out-File -FilePath $LogFile -Append -Encoding UTF8
		$succeeded = $false
		for ($i = 1; $i -le $RetryCount; $i++) {
			Start-Sleep -Seconds $RetryDelaySeconds
			if (Test-Network -HostName $CheckHost) {
				"$((Get-Date -Format o)) 第 $i 次重试成功" | Out-File -FilePath $LogFile -Append -Encoding UTF8
				$succeeded = $true
				break
			} else {
				"$((Get-Date -Format o)) 第 $i 次重试失败" | Out-File -FilePath $LogFile -Append -Encoding UTF8
			}
		}
		if (-not $succeeded) {
			"$((Get-Date -Format o)) 网络持续不可用，准备重启计算机。" | Out-File -FilePath $LogFile -Append -Encoding UTF8
			try {
				Restart-Computer -Force
			} catch {
				"$((Get-Date -Format o)) 无法执行重启：$($_.Exception.Message)" | Out-File -FilePath $LogFile -Append -Encoding UTF8
			}
		}
	}

	Start-Sleep -Seconds ($IntervalMinutes * 60)
}

