variable "prefix" {
    type        = string
    default     = "terraform-test-yoshimura"
    description = "project name given as a prefix"
}

variable "IPs" {
    type        = list(string)
    default     = [
        # ilovex office
        "113.42.0.26/32",
        # yoshimura house
        "133.203.135.66/32",

        # 複数のIPを指定する場合は以下のように記述
        # "xxx.xxx.xxx.xxx/xx", 
        # "yyy.yyy.yyy.yyy/yy",
        # ...
        # "zzz.zzz.zzz.zzz/zz"
    ]
    description = "IPs to allow connections"
}