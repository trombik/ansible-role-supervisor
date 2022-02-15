require "spec_helper"
require "serverspec"

package = case os[:family]
          when "freebsd"
            "sysutils/py-supervisor"
          else
            raise "unknown os[:family]: `#{os[:family]}`"
          end
service = case os[:family]
          when "freebsd"
            "supervisord"
          end
config_dir = case os[:family]
             when "freebsd"
               "/usr/local/etc/supervisor"
             else
               "/etc/supervisor"
             end
conf_d_dir = "#{config_dir}/conf.d"
config  = "#{config_dir}/supervisord.conf"
user    = "root"
group   = case os[:family]
          when "freebsd", "openbsd"
            "wheel"
          else
            "root"
          end
ports   = []
log_dir = "/var/log/supervisor"
unix_socket_dir = case os[:family]
                  when "freebsd"
                    "/var/run/supervisor"
                  end
unix_socket_file = "#{unix_socket_dir}/supervisor.sock"
pid_dir = case os[:family]
          when "freebsd"
            "/var/run/supervisor"
          end

describe package(package) do
  it { should be_installed }
end

describe file config_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 755 }
end

describe file conf_d_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 755 }
end

describe file conf_d_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 755 }
end

describe file pid_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 755 }
end

describe file unix_socket_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 755 }
end

describe file unix_socket_file do
  it { should exist }
  it { should be_socket }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 700 }
end

describe file config do
  it { should exist }
  it { should be_file }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 644 }
  its(:content) { should match Regexp.escape("Managed by ansible") }
end

case os[:family]
when "freebsd"
  describe file "/etc/rc.conf.d/#{service}" do
    it { should exist }
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 644 }
    its(:content) { should match Regexp.escape("Managed by ansible") }
  end
end

describe file log_dir do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
