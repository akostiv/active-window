[CmdletBinding()]
Param(
[string]$n,[string]$interval
)
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  using System.Diagnostics;
  public class UserWindows {
    private static Process _realProcess;

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
    private delegate bool WindowEnumProc(IntPtr hwnd, IntPtr lparam);

    [DllImport("user32.dll")]
    private static extern bool EnumChildWindows(IntPtr hwnd, WindowEnumProc callback, IntPtr lParam);

    private static bool ChildWindowCallback(IntPtr hwnd, IntPtr lparam)
    {
      var process = Process.GetProcessById(GetWindowProcessId(hwnd));
      if (process.ProcessName != "ApplicationFrameHost")
      {
        _realProcess = process;
      }
      return true;
    }

    private static int GetWindowProcessId(IntPtr hwnd)
    {
      int pid;
      GetWindowThreadProcessId(hwnd, out pid);
      return pid;
    }

    public static Process GetForegroundProcess()
    {
      var foregroundProcess = Process.GetProcessById(GetWindowProcessId(GetForegroundWindow()));
      if (foregroundProcess.ProcessName == "ApplicationFrameHost")
      {
        EnumChildWindows(foregroundProcess.MainWindowHandle, ChildWindowCallback, IntPtr.Zero);
        foregroundProcess = _realProcess;
      }
      return foregroundProcess;
    }
}
"@
try {
	while($n -ne 0){
	    $Process = [UserWindows]::GetForegroundProcess()
	    $string =  $Process | Select ProcessName, @{Name="AppTitle";Expression= {($_.MainWindowTitle)}}, Id
	    Write-Host -NoNewline $string
	    Start-Sleep -s $interval
	    If ($n -gt 0) {$n-=1}
	}
} catch {
 Write-Error "Failed to get active Window details. More Info: $_"
}
