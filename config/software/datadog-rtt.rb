name "datadog-rtt"
default_version "last-stable"
github_token = ENV['GITHUB_TOKEN']

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-rtt"
}

if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do
   ship_license "https://raw.githubusercontent.com/DataDog/dd-tcp-rtt/master/LICENSE"
   # command "git config --global url.\"git@github.com:\".insteadOf \"https://github.com/\"", :env => env
   # command "#{gobin} get -d -u github.com/DataDog/dd-tcp-rtt", :env => env
   command "mkdir -p /var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog/dd-tcp-rtt"
   command "git clone https://#{github_token}@github.com/DataDog/dd-tcp-rtt.git", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog"
   command "git checkout #{default_version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog/dd-tcp-rtt"
   command "#{gobin} get -d -u ./...", :env => env, :cwd => "/var/cache/omnibus/src/datadog-rtt/src/github.com/DataDog/dd-tcp-rtt"
   patch :source => "libpcap-static-link.patch", :plevel => 0, :target => "$GOPATH/src/github.com/google/gopacket"
   command "#{gobin} build -o #{install_dir}/bin/dd-tcp-rtt $GOPATH/src/github.com/DataDog/dd-tcp-rtt", :env => env
end
