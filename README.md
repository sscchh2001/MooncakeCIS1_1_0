# MooncakeCIS1_1_0
This project is for Azure CIS Benchmark 1.1.0 in Azure China cloud.  
See [Details of the CIS Microsoft Azure Foundations Benchmark Regulatory Compliance built-in initiative](https://docs.microsoft.com/en-us/azure/governance/policy/samples/cis-azure-1-1-0) for details.

## Difference between Azure CIS Benchmark in public Azure cloud vs. Azure China cloud  
Most of the built-in policies used by public Azure has already been landed to Azure China cloud, except following ones:  

| Name | Can be deployed to Azure China cloud |
| --- | --- |
| Adaptive network hardening recommendations should be applied on internet facing virtual machines | No |
| [Preview]: Key Vault keys should have an expiration date | No |
| [Preview]: Key Vault secrets should have an expiration date | No |
| [Preview]: Storage account public access should be disallowed | Yes |
| Key vaults should have purge protection enabled | Yes |
| Function apps should have 'Client Certificates (Incoming client certificates)' enabled | Yes |

For the ones that can be deployed to Azure China cloud, we can create custom policies instead.

## Prerequisites  
1. Install [Azure PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps).  
2. Have an Azure China (21ViaNet) subscription.  
3. Have an Azure AD account with Tenant Root management group owner permission, or with Azure AD global admin permission.

## How to Use  
1. Download the deploy.ps1 and *.json files to a local folder.
2. Login Azure portal with an account that is the owner of the tenant root management group. Alternatively if you have an Azure AD global admin, follow https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin to elevate the permission, and assign the owner permission of the Tenant Root Group to the account.
3. Open a PowerShell window, navigate to the local folder.
4. Run deploy.ps1, and provide the Azure AD tenant ID when prompted.
5. Login the account when prompted login window.
6. The script will generate 3 custom policies and a custom initiative named `CIS Azure Benchmark 1.1.0`. You can either go to policy assignment page or security center security policy page to assign this initiative.

## License
[MIT](LICENSE.md)  
