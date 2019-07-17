variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "web_server_location" {}
variable "web_server_rg" {}
variable "resource_prefix" {}
variable "web_server_address_space" {}
variable "web_server_address_prefix" {}
variable "web_server_name" {}

provider "azurerm" {
    version          = "1.28.0"
    client_id        = "${var.client_id}"
    client_secret    = "${var.client_secret}"
    tenant_id        = "${var.tenant_id}"
    subscription_id  = "${var.subscription_id}"
  
}

resource "azurerm_resource_group" "web_server_rg" {
    name             = "${var.web_server_rg}"
    location         = "${var.web_server_location}"
}
# comenting this one for kubernetes
#resource "azurerm_virtual_network" "web_server_vnet" {
 #   name                = "${var.resource_prefix}-vnet"
  #  location            = "${var.web_server_location}"
  #  resource_group_name = "${azurerm_resource_group.web_server_rg.name}"
  #  address_space       = ["${var.web_server_address_space}"]
    #subnet {
        #name = "${var.resource_prefix}-subnet"
       # address_prefix = "${var.web_server_address_prefix}"
    #}
  
#}
#resource "azurerm_subnet" "web_server_subnet" {
   # name                 = "${var.resource_prefix}-subnet"
    #resource_group_name  = "${azurerm_resource_group.web_server_rg.name}"
   # virtual_network_name = "${azurerm_virtual_network.web_server_vnet.name}"
   #address_prefix        = "${var.web_server_address_prefix}"

  
#}



#resource "azurerm_public_ip" "web_server_public_ip" {

  #  name = "${var.web_server_name}-public-ip"
   # location = "${var.web_server_location}"
   # resource_group_name = "${azurerm_resource_group.web_server_rg.name}"
   # allocation_method = "Dynamic"
    
    #tags = {
      #  environment = "Production"
   # }
 
#}
#resource "azurerm_network_interface" "wev_server_nic" {
   # name                 = "${var.web_server_name}-nic"
   # location             = "${var.web_server_location}"
   # resource_group_name  = "${azurerm_resource_group.web_server_rg.name}"
   # network_security_group_id = "${azurerm_network_security_group.web-server-nsg.id}"
    #ip_configuration {
     #   name             = "${var.web_server_name}-ip"
     #   subnet_id        = "${azurerm_subnet.web_server_subnet.id}"
     #   private_ip_address_allocation = "dynamic"
     #   public_ip_address_id = "${azurerm_public_ip.web_server_public_ip.id}"
   # }
  
#}
#resource "azurerm_network_security_group" "web-server-nsg" {

    #name = "${var.web_server_name}-nsg"
    #location = "${var.web_server_location}"
    #resource_group_name = "${azurerm_resource_group.web_server_rg.name}"
 
#}
#resource "azurerm_network_security_rule" "web_server_nsg_rule_rdp" {
    #name = "RDP Inbound"
   # priority = 100
   # direction = "inbound"
   # access = "Allow"
   # protocol = "TCP"
   # source_port_range = "*"
    #destination_port_range = "*"
    #source_address_prefix = "*"
   # destination_address_prefix = "*"
   # resource_group_name  = "${azurerm_resource_group.web_server_rg.name}"
   # network_security_group_name = "${azurerm_network_security_group.web-server-nsg.name}"

  
#}

resource "azurerm_kubernetes_cluster" "web_server_rg" {
    name = "prod"
    location = "${var.web_server_location}"
    
    resource_group_name = "${azurerm_resource_group.web_server_rg.name}"
    dns_prefix = "prod-dns"

    agent_pool_profile {

       name = "default"
       count = 2
       vm_size = "Standard_DS2_v2"
       os_type = "Linux"
       os_disk_size_gb = 30
    }
    service_principal {
        client_id = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }
    tags = {
        Environment = "Production"
    }

  
}





