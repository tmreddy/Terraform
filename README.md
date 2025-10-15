# HCL (HashiCorp Configuration Language) Complete Guide

HCL is a configuration language created by HashiCorp, used primarily in Terraform, Consul, Vault, and other HashiCorp tools. This guide covers HCL step by step with practical examples.

## Table of Contents
1. [Basic Syntax](#basic-syntax)
2. [Data Types](#data-types)
3. [Variables](#variables)
4. [Functions](#functions)
5. [Expressions](#expressions)
6. [Blocks](#blocks)
7. [Advanced Features](#advanced-features)
8. [Best Practices](#best-practices)

## 1. Basic Syntax

### Comments
```hcl
# Single line comment
// Another single line comment

/*
Multi-line
comment
*/
```

### Basic Structure
```hcl
# attribute = value
name = "example"
count = 3
enabled = true
```

## 2. Data Types

### Primitive Types
```hcl
# String
name = "Hello World"
description = "Multi-line\nstring with\nline breaks"

# Number (integers and floats)
port = 80
cpu_limit = 1.5
memory_gb = 4

# Boolean
enabled = true
debug_mode = false

# Null
database_password = null
```

### Complex Types

#### Lists (Arrays)
```hcl
# Simple list
ports = [80, 443, 8080]
environments = ["dev", "staging", "prod"]

# Mixed types (not recommended but possible)
mixed_list = ["string", 123, true]

# Empty list
empty_list = []
```

#### Maps (Objects)
```hcl
# Simple map
tags = {
  Environment = "production"
  Team        = "devops"
  Project     = "web-app"
}

# Nested map
database_config = {
  host     = "localhost"
  port     = 5432
  settings = {
    max_connections = 100
    timeout         = 30
  }
}
```

#### Sets
```hcl
# Set (unique values)
security_groups = toset(["sg-123", "sg-456", "sg-789"])
```

#### Tuples
```hcl
# Tuple (ordered, mixed types)
server_info = ["web-server", 2, true, "active"]
```

## 3. Variables

### Variable Declaration
```hcl
# variables.tf
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "learning"
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

### Variable Usage
```hcl
# Using variables
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = var.instance_type
  count         = var.instance_count
  
  tags = var.tags
}
```

### Variable Validation
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition = contains([
      "t3.micro", "t3.small", "t3.medium"
    ], var.instance_type)
    error_message = "Instance type must be t3.micro, t3.small, or t3.medium."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

## 4. Functions

HCL has many built-in functions. Here are the most commonly used ones:

### String Functions
```hcl
# String manipulation
upper_name = upper("hello world")           # "HELLO WORLD"
lower_name = lower("HELLO WORLD")           # "hello world"
title_name = title("hello world")           # "Hello World"

# String formatting
formatted = format("Hello, %s!", "World")  # "Hello, World!"
padded = format("%10s", "test")             # "      test"

# String operations
joined = join("-", ["web", "server", "01"]) # "web-server-01"
split_result = split("-", "web-server-01")  # ["web", "server", "01"]

# Substring operations
substr_result = substr("hello world", 0, 5)  # "hello"
```

### Collection Functions
```hcl
# List operations
list_length = length(["a", "b", "c"])      # 3
contains_item = contains(["a", "b"], "a")  # true
index_of = index(["a", "b", "c"], "b")     # 1

# Set operations
unique_list = toset(["a", "b", "a", "c"])  # ["a", "b", "c"]
list_from_set = tolist(toset(["a", "b", "a"])) # ["a", "b"]

# Map operations
map_keys = keys({name = "test", env = "dev"})     # ["name", "env"]
map_values = values({name = "test", env = "dev"}) # ["test", "dev"]

# Merge maps
merged = merge(
  {name = "app"},
  {env = "prod"},
  {version = "1.0"}
)
# Result: {name = "app", env = "prod", version = "1.0"}
```

### Conditional Functions
```hcl
# Conditional expression
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

# Null coalescing
database_url = coalesce(var.database_url, "localhost:5432")

# Try function (handle errors)
safe_value = try(var.optional_config.setting, "default_value")
```

### Type Conversion Functions
```hcl
# Type conversions
string_to_number = tonumber("123")        # 123
number_to_string = tostring(123)          # "123"
string_to_bool = tobool("true")           # true

# JSON operations
json_string = jsonencode({name = "test"}) # "{\"name\":\"test\"}"
parsed_json = jsondecode(json_string)     # {name = "test"}
```

## 5. Expressions

### Arithmetic Operations
```hcl
# Basic math
sum = 10 + 5        # 15
difference = 10 - 5 # 5
product = 10 * 5    # 50
quotient = 10 / 5   # 2
remainder = 10 % 3  # 1
```

### Comparison Operations
```hcl
# Comparisons
equal = 5 == 5        # true
not_equal = 5 != 3    # true
greater = 10 > 5      # true
less_equal = 5 <= 10  # true
```

### Logical Operations
```hcl
# Boolean logic
and_result = true && false  # false
or_result = true || false   # true
not_result = !true          # false
```

### String Interpolation
```hcl
# Basic interpolation
name = "World"
greeting = "Hello, ${name}!"  # "Hello, World!"

# Complex interpolation
resource_name = "${var.project}-${var.environment}-server"

# Conditional interpolation
message = "Server is ${var.enabled ? "enabled" : "disabled"}"

# Function calls in interpolation
timestamp = "Created at ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
```

### Template Expressions
```hcl
# For expressions (list comprehension)
squared_numbers = [for n in [1, 2, 3, 4] : n * n]
# Result: [1, 4, 9, 16]

# Conditional for expressions
even_numbers = [for n in [1, 2, 3, 4, 5, 6] : n if n % 2 == 0]
# Result: [2, 4, 6]

# Object for expressions
name_map = {for item in var.servers : item.name => item.config}

# Nested for expressions
flattened = flatten([
  for subnet in var.subnets : [
    for az in subnet.availability_zones : {
      subnet_id = subnet.id
      az        = az
    }
  ]
])
```

## 6. Blocks

### Basic Block Structure
```hcl
# Basic block
block_type "block_label" {
  attribute = "value"
  nested_block {
    nested_attribute = "nested_value"
  }
}

# Multiple labels
resource "aws_instance" "web_server" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

### Common Terraform Blocks

#### Resource Blocks
```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public.id
  
  user_data = base64encode(file("${path.module}/user-data.sh"))
  
  tags = {
    Name        = "web-server"
    Environment = var.environment
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes       = [ami]
  }
}
```

#### Data Source Blocks
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

#### Module Blocks
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block           = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  tags = var.common_tags
}
```

#### Output Blocks
```hcl
output "instance_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
  sensitive   = false
}

output "database_config" {
  description = "Database connection details"
  value = {
    host     = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    database = aws_db_instance.main.name
  }
  sensitive = true
}
```

#### Local Values
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
  
  instance_name = "${var.project_name}-${var.environment}-web"
  
  database_port = var.environment == "prod" ? 5432 : 5433
}
```

## 7. Advanced Features

### Dynamic Blocks
```hcl
resource "aws_security_group" "web" {
  name_prefix = "web-"
  
  # Dynamic block for multiple ingress rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
}

# Variable definition for ingress_rules
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]
}
```

### Count and For_Each
```hcl
# Using count
resource "aws_instance" "web" {
  count = var.instance_count
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

# Using for_each with list
resource "aws_instance" "web" {
  for_each = toset(var.server_names)
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  tags = {
    Name = each.value
  }
}

# Using for_each with map
resource "aws_instance" "web" {
  for_each = var.servers
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  
  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Role = each.value.role
    }
  )
}
```

### Conditional Resources
```hcl
# Conditional resource creation
resource "aws_instance" "web" {
  count = var.create_instance ? 1 : 0
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
}

# Alternative using for_each
resource "aws_instance" "web" {
  for_each = var.create_instance ? { web = true } : {}
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
}
```

## 8. Best Practices

### 1. File Organization
```
project/
├── main.tf          # Main resources
├── variables.tf     # Variable declarations
├── outputs.tf       # Output definitions
├── providers.tf     # Provider configurations
├── locals.tf        # Local value definitions
├── data.tf          # Data source definitions
└── versions.tf      # Version constraints
```

### 2. Naming Conventions
```hcl
# Use descriptive names
variable "web_server_instance_type" {
  # Not: variable "instance"
}

# Use snake_case for variables and resources
resource "aws_security_group" "web_server_sg" {
  # Not: webServerSG or WebServerSG
}

# Use consistent prefixes/suffixes
resource "aws_instance" "web_server" {}
resource "aws_instance" "app_server" {}
resource "aws_instance" "db_server" {}
```

### 3. Variable Documentation
```hcl
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition = contains([
      "t3.micro", "t3.small", "t3.medium", "t3.large"
    ], var.instance_type)
    error_message = "Instance type must be a valid t3 family type."
  }
}
```

### 4. Use Locals for Complex Expressions
```hcl
locals {
  # Calculate derived values
  environment_config = {
    dev = {
      instance_type = "t3.micro"
      min_size     = 1
      max_size     = 2
    }
    prod = {
      instance_type = "t3.large"
      min_size     = 3
      max_size     = 10
    }
  }
  
  current_env_config = local.environment_config[var.environment]
  
  # Common tags
  common_tags = merge(
    var.additional_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Timestamp   = timestamp()
    }
  )
}
```

### 5. Error Handling
```hcl
# Use try() for optional values
database_config = try(var.database_config.enabled, false) ? {
  host     = try(var.database_config.host, "localhost")
  port     = try(var.database_config.port, 5432)
  database = try(var.database_config.name, "myapp")
} : null

# Use can() for validation
variable "cidr_block" {
  type = string
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "The cidr_block must be a valid IPv4 CIDR block."
  }
}
```

## Conclusion

This guide covers the fundamentals of HCL! Practice with these examples and gradually build more complex configurations. The key is to start simple and progressively add complexity as you become more comfortable with the syntax and concepts.

### Quick Reference

- **Comments**: `#`, `//`, `/* */`
- **Variables**: `var.variable_name`
- **Interpolation**: `"${expression}"`
- **Functions**: `function(args)`
- **Conditionals**: `condition ? true_value : false_value`
- **Lists**: `[item1, item2, item3]`
- **Maps**: `{key1 = value1, key2 = value2}`
- **For expressions**: `[for item in list : expression]`
- **Dynamic blocks**: `dynamic "block_name" { for_each = ... }`

### Additional Resources

- [Terraform Language Documentation](https://www.terraform.io/language)
- [HCL Syntax Reference](https://github.com/hashicorp/hcl)
- [Terraform Functions Reference](https://www.terraform.io/language/functions)
