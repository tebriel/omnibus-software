name "datadog-rtt"
default_version "last-stable"
github_token = ENV['GITHUB_TOKEN']

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-rtt"
}

dependency "libpcap"

if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do
   ship_license "https://raw.githubusercontent.com/DataDog/dd-tcp-rtt/master/LICENSE"
   command "mkdir -p /var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog", :env => env
   command "git clone https://#{github_token}:x-oauth-basic@github.com/DataDog/dd-tcp-rtt.git", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog"
   command "git checkout #{default_version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog/dd-tcp-rtt"
   command "#{gobin} get -v -d github.com/Sirupsen/logrus", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt"
   command "#{gobin} get -v -d github.com/google/gopacket", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt"
   command "#{gobin} get -v -d github.com/DataDog/datadog-go/statsd", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt"
   command "#{gobin} get -v -d gopkg.in/tomb.v2", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt"
   command "#{gobin} get -v -d gopkg.in/yaml.v2", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt"
   patch :source => "libpcap-static-link.patch", :plevel => 1, :target => "/var/cache/omnibus/src/datadog-rtt/src/github.com/google/gopacket/pcap/pcap.go"
   command "#{gobin} build -o #{install_dir}/bin/dd-tcp-rtt $GOPATH/src/github.com/DataDog/dd-tcp-rtt", :env => env
end
