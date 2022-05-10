@description('Location of the VNET1')
@allowed([
  'eastus2'
  'uk'
  'uae'
  'japaneast'
  'japanwest'
])
param vnet1_location string = 'japaneast'

@description('Location of the VNET2')
@allowed([
  'eastus2'
  'uk'
  'uae'
  'japaneast'
  'japanwest'
])
param vnet2_location string = 'japanwest'

@description('Name for vNet 1')
param vnet1_Name string = 'vNet1'

@description('Name for vNet 2')
param vnet2_Name string = 'vNet2'

var vnet1Config = {
  addressSpacePrefix: '10.1.0.0/24'
  subnetName: 'subnet1'
  subnetPrefix: '10.1.0.0/24'
}
var vnet2Config = {
  addressSpacePrefix: '10.2.0.0/24'
  subnetName: 'subnet1'
  subnetPrefix: '10.2.0.0/24'
}

resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnet1_Name
  location: vnet1_location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet1Config.subnetName
        properties: {
          addressPrefix: vnet1Config.subnetPrefix
        }
      }
    ]
  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnet1_Name}-${vnet2_Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnet2_Name
  location: vnet2_location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet2Config.subnetName
        properties: {
          addressPrefix: vnet2Config.subnetPrefix
        }
      }
    ]
  }
}

resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet2
  name: '${vnet2_Name}-${vnet1_Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
