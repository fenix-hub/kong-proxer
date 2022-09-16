local typedefs = require "kong.db.schema.typedefs"

return {
    name = "kong-proxer",
    fields = {
        { consumer = typedefs.no_consumer },
        { 
            config = {
                type = "record",
                fields = {
                    { ignore_on_tags = { required = false, type = "array", elements = { type = "string" }, default = { "proxer:hosted", } } },
                    { proxer_schema = { required = false, type = "string", one_of = { "http", "https" } } },
                    { proxer_host = { required = true, type = "string" } },
                    { proxer_port = { required = true, type = "number", default = 80 } },
                    { proxer_ssl_port = { required = false, type = "number", default = 443 } },
                    { proxer_schema_header = { required = true, type = "string", default = "X-ProxyTo-Schema" } },
                    { proxer_host_header = { required = true, type = "string", default = "X-ProxyTo-Host" } }   
                }
            }
        }
    }
}
