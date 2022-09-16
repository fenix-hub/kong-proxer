return {
    name = "kong-proxer",
    fields = {
        { consumer = typedefs.no_consumer },
        { 
            config = {
                type = "record",
                fields = {
                    { proxer_schema = {required = false, type = "string"} },
                    { proxer_host = {required = true, type = "string"} },
                    { proxer_port = {required = true, type = "number", default = 80} },
                    { proxer_ssl_port = {required = false, type = "number", default = 443} },
                    { proxer_schema_header = {required = true, type = "number", default = "X-ProxyTo-Schema"} },
                    { proxer_host_header = {required = true, type = "number", default = "X-ProxyTo-Host"} }   
                }
            }
        }
    }
}
