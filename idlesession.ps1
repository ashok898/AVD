Connect-AzAccount -Identity
$vms = Get-AzVM | Where-Object { $_.Tags["AVDHostPool"] -eq "Pooled" }

foreach ($vm in $vms) {
    $status = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    if ($status.Statuses[1].Code -eq "PowerState/running") {
        $sessionInfo = Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -CommandId 'RunPowerShellScript' -ScriptString 'query user'
        if ($sessionInfo.Value[0].Message -notmatch "Active") {
            Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
        }
    }
}
