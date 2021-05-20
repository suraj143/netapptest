
@echo off

echo This will first install chocolatey, then other tools
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco feature enable -n=allowGlobalConfirmation
choco --version

echo "Install dependency packages" 
dism /online /Enable-Feature /FeatureName:TelnetClient
rem choco uninstall azure-cli -y
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi"
choco install kubernetes-cli -y
kubectl --version
choco install googlechrome -y
choco install notepadplusplus -y

echo "sleep for 10 sec"
rem powershell Start-Sleep -s 10

set "clientId=c8cc3204-f015-495f-82d6-e2b0ecefa7e3"
set "clientSecret=mj-ovxpilLJ.GgNX_s-idkJflhJK~Y0hwy" 
set "tenantId=7444ae05-4a17-4552-a204-ba3d48a69fba"
set "resoucegroup=armakstest"
set "clustername=gfc-talon-dev"

echo "Azure login"
start /b az login --service-principal -u %clientId% -p %clientSecret% --tenant %tenantId%

echo "sleep for 10 sec"
rem powershell Start-Sleep -s 10

echo "Connect to AKS"
start /b az aks get-credentials --resource-group %resoucegroup% --name %clustername%

echo "list worker nodes"
kubectl get nodes -o wide

echo "Delete core in AKS"
kubectl delete -f https://raw.githubusercontent.com/suraj143/netapptest/main/core.yaml

echo "sleep for 20 sec"
rem powershell Start-Sleep -s 20

echo "Deploy core in AKS"
kubectl apply -f https://raw.githubusercontent.com/suraj143/netapptest/main/core.yaml

echo "sleep for 30 sec"
powershell Start-Sleep -s 30

echo "List running pods in core-dev namespace"
kubectl get pods -n core-dev

echo "sleep 30 sec"
rem powershell Start-Sleep -s 30

echo "List pod loadbalencer endpoints in core-dev namespace"
kubectl get svc -n core-dev

exit 0
