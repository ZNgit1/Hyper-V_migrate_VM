# Запросить у пользователя значения для гипервизоров
$sourceHypervisor = Read-Host "Введите имя исходного гипервизора FQDN"
$destinationHypervisor = Read-Host "Введите имя целевого гипервизора FQDN"

# Получить все виртуальные машины на исходном гипервизоре
$vms = Get-SCVirtualMachine -VMHost $sourceHypervisor

# Проверка наличия виртуальных машин
if ($vms.Count -eq 0) {
    Write-Host "На гипервизоре $sourceHypervisor не найдено виртуальных машин."
    exit
}

Write-Host "Начало миграции виртуальных машин с $sourceHypervisor на $destinationHypervisor."

# Перемещение каждой виртуальной машины
foreach ($vm in $vms) {
    $vmName = $vm.Name
    Write-Host "Миграция виртуальной машины: $vmName"
    
    try {
        # Измерение времени миграции
        $startTime = Get-Date
        Move-SCVirtualMachine -VM $vm -VMHost $destinationHypervisor -UseLAN | Out-Null
        $endTime = Get-Date
        
        # Вывод статуса и времени миграции
        Write-Host "Успешно: $vmName перемещена на $destinationHypervisor. Время миграции: $($endTime - $startTime)"
    }
    catch {
        # Обработка ошибок
        Write-Host "Ошибка: Не удалось переместить $vmName. Причина: $($_.Exception.Message)"
    }
}

Write-Host "Миграция завершена."

# Перевод гипервизора в режим обслуживания
#Write-Host "Перевод гипервизора $sourceHypervisor в режим обслуживания."
#try {
#    Set-SCVMHost -VMHost $sourceHypervisor -MaintenanceHost $true | Out-Null
#    Write-Host "Гипервизор $sourceHypervisor успешно переведен в режим обслуживания."
#}
#catch {
#    Write-Host "Ошибка: Не удалось перевести гипервизор $sourceHypervisor в режим обслуживания. Причина: $($_.Exception.Message)"
#}


sleep 120
