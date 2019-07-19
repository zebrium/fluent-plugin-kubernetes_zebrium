require "fluent/filter"

module Fluent::Plugin
  class ZebriumK8Output < Fluent::Plugin::Filter
    # Register type
    Fluent::Plugin.register_filter("kubernetes_zebrium", self)

    config_param :exclude_namespace_regex, :string, :default => ""
    config_param :exclude_pod_regex, :string, :default => ""
    config_param :exclude_container_regex, :string, :default => ""

    def configure(conf)
      super
    end

    def filter(tag, time, record)
      zb_metadata = record["_zb_metadata"] || {}
      record["_zb_metadata"] = zb_metadata

      # Allow fields to be overridden by annotations
      if record.key?("kubernetes") and not record.fetch("kubernetes").nil?
        # Clone kubernetes hash so we don't override the cache
        kubernetes = record["kubernetes"].clone
        k8s_metadata = {
          :namespace => kubernetes["namespace_name"],
          :pod => kubernetes["pod_name"],
          :pod_id => kubernetes['pod_id'],
          :container => kubernetes["container_name"],
        }

        if kubernetes.has_key? "labels"
          kubernetes["labels"].each { |k, v| k8s_metadata["label:#{k}".to_sym] = v }
        end
        k8s_metadata.default = "undefined"

        unless @exclude_namespace_regex.empty?
          if Regexp.compile(@exclude_namespace_regex).match(k8s_metadata[:namespace])
            return nil
          end
        end

        unless @exclude_pod_regex.empty?
          if Regexp.compile(@exclude_pod_regex).match(k8s_metadata[:pod])
            return nil
          end
        end

        unless @exclude_container_regex.empty?
          if Regexp.compile(@exclude_container_regex).match(k8s_metadata[:container])
            return nil
          end
        end

      end
      record
    end
  end
end
