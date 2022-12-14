local ProxerHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 1000,
}

function ProxerHandler.access(self, config)
  
  -- Only apply logic to Services with at least one `tag` in `ignore_on_tags`
  for i, tag in pairs(config.ignore_on_tags) do
    kong.log("tag: " .. i .. " " .. tag)
    for j, ignore_tag in pairs(ngx.ctx.service.tags) do
        kong.log("ignore_tag: " .. j .. " " .. ignore_tag)
        if tag == ignore_tag then
            kong.log("ignoring!")
            return
        end
      end
  end
  
  -- Initialize target host, which is the real target of the service
  local target_host = ngx.ctx.balancer_data.host .. ":" .. ngx.ctx.balancer_data.port
  kong.log("Forwarding request for: " .. target_host)

  -- Load all configuration variables
  local proxer_schema, proxer_host, proxer_port, proxer_ssl_port = config.proxer_schema, config.proxer_host, config.proxer_port, config.proxer_ssl_port

  -- If a schema for Proxer is not define, use the one set for the Service
  if proxer_schema == '' or proxer_schema == nil then
      proxer_schema = ngx.ctx.balancer_data.schema
  end
  
  -- If the schema is HTTPS, use the SSL port
  if proxer_schema == "https" then
      proxer_port = proxer_ssl_port
  end

  -- Change Balancer properties
  ngx.ctx.balancer_data.schema = proxer_schema
  ngx.ctx.balancer_data.host = proxer_host
  ngx.ctx.balancer_data.port = proxer_port

  -- Set Proxer headers
  ngx.req.set_header(config.proxer_schema_header, target_schema)
  ngx.req.set_header(config.proxer_host_header, target_host)
  
  kong.log("Forwarding request to: " .. proxer_schema .. "://" .. proxer_host .. ":" .. proxer_port)
end

return ProxerHandler
