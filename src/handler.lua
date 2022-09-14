local ProxerHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 1000,
}

function ProxerHandler.access(self, config)
    local target_host = ngx.ctx.balancer_address.host .. ":" .. ngx.ctx.balancer_address.port
    kong.log("Forwarding request for: " .. target_host)
    
    local proxy_schema, proxy_host, proxy_port, proxy_ssl_port = config.proxer_schema, config.proxer_host, config.proxer_port, config.proxer_ssl_port
    
    if proxer_schema == '' || proxer_schema == nil then
        proxer_schema = ngx.ctx.balancer_address.schema
    end
    if proxer_schema == "https" then
        proxer_port = proxer_ssl_port
    end
    
    ngx.ctx.balancer_address.schema = proxer_schema
    ngx.ctx.balancer_address.host = proxer_host
    ngx.ctx.balancer_address.port = proxer_port
   
    ngx.req.set_header(config.proxer_schema_header, target_schema)
    ngx.req.set_header(config.proxer_host_header, target_host)
    
    
    kong.log("Forwarding request to: " .. proxer_schema .. "://" .. proxer_host .. ":" .. proxer_port)
end

return ProxerHandler
