package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/azure"
    "github.com/stretchr/testify/assert"
)

func TestVnetModuleBasic(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../../",
        Vars: map[string]interface{}{
            "vnet_name":           "vnet-test-terratest",
            "vnet_cidr":          "10.2.0.0/16",
            "location":           "eastus",
            "resource_group_name": "rg-test-terratest",
            "subnets": map[string]interface{}{
                "subnet1": map[string]string{"cidr": "10.2.1.0/24"},
                "subnet2": map[string]string{"cidr": "10.2.2.0/24"},
            },
            "enable_nsg":         false,
            "tags":               map[string]string{"test": "basic"},
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    vnetID := terraform.Output(t, terraformOptions, "vnet_id")
    subnetIDs := terraform.OutputMap(t, terraformOptions, "subnet_ids")

    vnet, err := azure.GetVirtualNetworkE(vnetID, "rg-test-terratest", "")
    assert.NoError(t, err)
    assert.Equal(t, "vnet-test-terratest", *vnet.Name)
    assert.Contains(t, vnet.AddressSpace.AddressPrefixes, "10.2.0.0/16")
    assert.Equal(t, 2, len(subnetIDs))
}