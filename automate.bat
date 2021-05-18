echo " Install chocho manually in powershell "
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

echo "Install dependency packages" 
dism /online /Enable-Feature /FeatureName:TelnetClient
choco install notepadplusplus -yes
choco install azure-cli -yes
choco install kubernetes-cli -yes
choco install googlechrome -yes

set "clientId=c8cc3204-f015-495f-82d6-e2b0ecefa7e3"
set "clientSecret=mj-ovxpilLJ.GgNX_s-idkJflhJK~Y0hwy" 
set "tenantId=7444ae05-4a17-4552-a204-ba3d48a69fba"
set "resoucegroup=armakstest"
set "clustername=gfc-talon-dev"

echo "Azure login"
start /b az login --service-principal -u %clientId% -p %clientSecret% --tenant %tenantId%

echo "sleep for 10 sec"
powershell Start-Sleep -s 10

echo "Connect to AKS"
start /b az aks get-credentials --resource-group %resoucegroup% --name %clustername%

echo "list worker nodes"
kubectl get nodes -o wide

echo "Delete core in AKS"
kubectl delete -f https://raw.githubusercontent.com/suraj143/netapptest/main/core.yaml

echo "sleep for 20 sec"
powershell Start-Sleep -s 20

echo "Deploy core in AKS"
kubectl apply -f https://raw.githubusercontent.com/suraj143/netapptest/main/core.yaml
rem kubectl apply -f "C:\kubernetes\core.yaml"

echo "sleep for 60 sec"
powershell Start-Sleep -s 60

echo "List running pods in core-dev namespace"
kubectl get pods -n core-dev

echo "sleep 30 sec"
powershell Start-Sleep -s 30

echo "List pod loadbalencer endpoints in core-dev namespace"
kubectl get svc -n core-dev
