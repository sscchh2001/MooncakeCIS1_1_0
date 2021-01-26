<#************************************************************************
 * Copyright (C) 2020 Microsoft Corporation
 * All rights reserved.
 *
 *      Microsoft Corporation
 *      One Microsoft Way
 *      Redmond, WA 
 *      98052-6399 USA
 *      http://www.microsoft.com
 *
 * DISCLAIMER OF WARRANTIES:
 *
 * THE SOFTWARE PROVIDED HEREUNDER IS PROVIDED ON AN "AS IS" BASIS, WITHOUT
 * ANY WARRANTIES OR REPRESENTATIONS EXPRESS, IMPLIED OR STATUTORY; INCLUDING,
 * WITHOUT LIMITATION, WARRANTIES OF QUALITY, PERFORMANCE, NONINFRINGEMENT,
 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  NOR ARE THERE ANY
 * WARRANTIES CREATED BY A COURSE OR DEALING, COURSE OF PERFORMANCE OR TRADE
 * USAGE.  FURTHERMORE, THERE ARE NO WARRANTIES THAT THE SOFTWARE WILL MEET
 * YOUR NEEDS OR BE FREE FROM ERRORS, OR THAT THE OPERATION OF THE SOFTWARE
 * WILL BE UNINTERRUPTED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

Param(
    [Parameter(Mandatory = $true,
    HelpMessage = "Enter the tenant ID of your AAD tenant")]
    [string] $tenantID
)

Login-AzAccount -Environment AzureChinaCloud

#Create policy 1
$policyName_1 = "StorageAccountPublicAccessDisallowed"
$policyDisName_1 = "[Preview]: Storage account public access should be disallowed"
$policyDesc_1 = "Anonymous public read access to containers and blobs in Azure Storage is a convenient way to share data but might present security risks. To prevent data breaches caused by undesired anonymous access, Microsoft recommends preventing public access to a storage account unless your scenario requires it."

New-AzPolicyDefinition `
    -Metadata '{"category": "Storage"}' `
    -Name $policyName_1 `
    -Description $policyDesc_1 `
    -DisplayName $policyDisName_1 `
    -Policy policyRule_1.json `
    -Parameter policyPara_1.json `
    -Mode "Indexed" `
    -ManagementGroupName $tenantID

#Create policy 2
$policyName_2 = "KeyVaultPurgeProtectionEnabled"
$policyDisName_2 = "Key vaults should have purge protection enabled"
$policyDesc_2 = "Malicious deletion of a key vault can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge key vaults. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted key vaults. No one inside your organization or Microsoft will be able to purge your key vaults during the soft delete retention period."

New-AzPolicyDefinition `
    -Metadata '{"category": "Key Vault"}' `
    -Name $policyName_2 `
    -Description $policyDesc_2 `
    -DisplayName $policyDisName_2 `
    -Policy policyRule_2.json `
    -Parameter policyPara_2.json `
    -Mode "Indexed" `
    -ManagementGroupName $tenantID

#Create policy 3
$policyName_3 = "FunctionAppsEnableClientCertificates"
$policyDisName_3 = "Function apps should have 'Client Certificates (Incoming client certificates)' enabled"
$policyDesc_3 = "Client certificates allow for the app to request a certificate for incoming requests. Only clients with valid certificates will be able to reach the app."

New-AzPolicyDefinition `
    -Metadata '{"category": "App Service"}' `
    -Name $policyName_3 `
    -Description $policyDesc_3 `
    -DisplayName $policyDisName_3 `
    -Policy policyRule_3.json `
    -Parameter policyPara_3.json `
    -Mode "Indexed" `
    -ManagementGroupName $tenantID

#Create the CIS policy set
$policySetName = "CISAzureBenchmark1_1_0"
$policySetDisName = "CIS Microsoft Azure Foundations Benchmark 1.1.0"
$policySetDesc = "This initiative includes audit policies that address a subset of CIS Microsoft Azure Foundations Benchmark recommendations. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/cisazure-blueprint."
#Read policy set definition from json
$policySetDef = Get-Content policySetDef.json
#Insert the tenant ID in the policy set definition
$policySetDef -replace "<tenant>", $tenantID | Out-File policySetDef_withTenant.json

New-AzPolicySetDefinition `
    -Metadata '{"category": "Regulatory Compliance"}' `
    -Name $policySetName `
    -Description $policySetDesc `
    -DisplayName $policySetDisName `
    -PolicyDefinition policySetDef_withTenant.json `
    -Parameter policySetPara.json `
    -ManagementGroupName $tenantID
