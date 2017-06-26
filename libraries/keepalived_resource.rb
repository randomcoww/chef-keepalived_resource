module KeepalivedResource
  ## convert hash to yaml like config that unbound and nsd use

  ## sample source config
  # {
  #   'vrrp_sync_group VG_gateway' => [
  #     {
  #       'group' => [
  #         'VI_gateway'
  #       ]
  #     }
  #   ],
  #   'vrrp_instance VI_gateway' => [
  #     {
  #       'state' => 'BACKUP',
  #       'notify_master' => "/sbin/ip link set eth2 up",
  #     	'notify_backup' => "/sbin/ip link set eth2 down",
  #     	'notify_fault' => "/sbin/ip link set eth2 down",
  #       'virtual_router_id' => 20,
  #       'interface' => 'eth0',
  #       'priority' => 100,
  #       'authentication' => [
  #         {
  #           'auth_type' => 'AH',
  #           'auth_pass' => 'PASSWD'
  #         }
  #       ],
  #       'virtual_ipaddress' => [
  #         '192.168.62.240/23'
  #       ]
  #     }
  #   ]
  # }

  def generate_config(config_hash)
    out = []

    config_hash.each do |k, v|
      parse_config_object(out, k, v, '')
    end
    return out.join($/)
  end

  def parse_config_object(out, k, v, prefix)
    case v
    when Hash
      v.each do |e, f|
        parse_config_object(out, e, f, prefix)
      end

    when Array
      if !k.nil?
        out << [prefix, k, ' {'].join
        v.each do |e|
          parse_config_object(out, nil, e, prefix + '  ')
        end
        out << [prefix, '}'].join
      end

    else
      if k.nil?
        out << [prefix, v].join
      else
        out << [prefix, k, ' ', v].join
      end
    end
  end
end
