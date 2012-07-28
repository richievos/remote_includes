require 'uri'

module RemoteIncludes
  SUPPORTED_OPTIONS = [:params, :method, :type]

  class UnsupportedKeys < ArgumentError; end
  class UnsupportedURL < ArgumentError; end

  def self.default_type=(type)
    @default_type = type
  end

  def self.default_type
    @default_type
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger
  end

  module Backend
    def self.render_remote(url, options={})
      unsupported_keys = options.keys - SUPPORTED_OPTIONS
      if !unsupported_keys.empty?
        raise UnsupportedKeys.new("Unsupported options: #{unsupported_keys.join(" ")}")
      end

      type = options.fetch(:type) || self.default_type

      case type
      when "esi"
        render_esi(url, options)
      when "sync", "synchronous"
        render_sync(url, options)
      when "sync_via_rack"
        render_esi(url, options)
      when "ssi"
        render_ssi(url, options)
      when "javascript"
        render_javascript(url, options)
      else
        raise ArgumentError.new("Unknown remote type #{type.inspect}")
      end
    end

    def self.base_uri=(host)
      Thread.current[:remote_include_base_uri] = host
    end

    def self.base_uri
      Thread.current[:remote_include_base_uri]
    end

    def self.render_esi(url, options)
      # alt="http://bak.example.com/2.html" onerror="continue"
      esi = %{<esi:include src="#{make_full_url(url)}"/>}
    end

    def self.render_sync(url, options)
      require 'net/http'
      Net::HTTP.get(make_full_url(url))
    end

    def self.render_ssi(url, options)
      raise UnsupportedURL.new("URL must be local for server side includes") if url =~ %r{^https?://}
      %{<!--# include virtual="#{url}" -->}
    end

    def self.render_javascript(url, options)
      %{<div data-content-url="#{make_full_url(url)}">}
    end

    def self.make_full_url(url)
      if url =~ %r{^https?://}
        url
      else
        URI.join(base_uri, url)
      end
    end
  end

  def render_remote(url, options={})
    RemoteIncludes::Backend.render_remote(url, options)
  end
end